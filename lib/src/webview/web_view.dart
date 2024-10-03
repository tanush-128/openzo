import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewC extends StatefulWidget {
  String? url;
  WebViewC({
    super.key,
    this.url,
  });

  @override
  State<WebViewC> createState() => _WebViewCState();
}

class _WebViewCState extends State<WebViewC> {
  late final WebViewController controller;
  final WebViewCookieManager _cookieManager = WebViewCookieManager();
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
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
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('FlutterChannel',
          onMessageReceived: (JavaScriptMessage message) {
        // Handle the message sent from Next.js or any other site
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Received from web: ${message.message}')),
        // );
        log('Received from web: ${message.message}');
        Provider.of<SalesProvider>(context, listen: false)
            .fetchSaleById(message.message);
      });

    _setCookiesAndLoadUrl();
  }

  Future<void> _setCookiesAndLoadUrl() async {
    await _cookieManager.setCookie(
      const WebViewCookie(
        name: 'myCookie',
        value: 'myValue',
        domain: '.openzo.in',
        path: '/',
      ),
    );
    controller.loadRequest(
      Uri.parse(widget.url ?? 'https://www.openzo.in/privacy-policy'),
    );
  }

  Future<bool> _onWillPop() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: null,
        body: Stack(
          children: [
            SafeArea(
              child: WebViewWidget(
                controller: controller,
              ),
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
          ],
        ),
      ),
    );
  }
}
