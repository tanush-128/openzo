import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:openzo_frontend/views/store/widgets/product_list_skeleton.dart';
import 'package:openzo_frontend/views/store/widgets/store_details_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewC extends StatefulWidget {
  final String? url;
  const WebViewC({
    Key? key,
    this.url,
  }) : super(key: key);

  @override
  State<WebViewC> createState() => _WebViewCState();
}

class _WebViewCState extends State<WebViewC> {
  late final WebViewController _controller;
  final WebViewCookieManager _cookieManager = WebViewCookieManager();
  bool _isLoading = true;
  bool _webViewInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    // Set cookies before loading the webview
    await _setCookies();

    // Initialize the controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          log('Received from web: ${message.message}');
          Provider.of<SalesProvider>(context, listen: false)
              .fetchSaleById(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (navigation) {
            final host = Uri.parse(navigation.url).host;
            if (host.contains('youtube.com')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Blocking navigation to $host',
                  ),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    // Load the initial URL
    _controller.loadRequest(
      Uri.parse(widget.url ?? 'https://www.openzo.in/privacy-policy'),
    );

    setState(() {
      _webViewInitialized = true;
    });
  }

  Future<void> _setCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    String userId = Provider.of<UserProvider>(context, listen: false).user?.id ?? ''; 

    await _cookieManager.setCookie(
      WebViewCookie(
        name: 'token',
        value: token ?? '',
        domain: 'openzo-webview.vercel.app',
        path: '/',
      ),
    );

    await _cookieManager.setCookie(
      WebViewCookie(
        name: 'userId',
        value: userId,
        domain: 'openzo-webview.vercel.app',
        path: '/',
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    } else {
      return true;
    }
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            if (_webViewInitialized)
              WebViewWidget(
                controller: _controller,
              ),
            if (_isLoading || !_webViewInitialized)
              const Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Center(
                      child: StoreDetailsSkeleton(),
                    ),
                    ProductListSkeleton(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
