import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewC extends StatefulWidget {
  const WebViewC({super.key});

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
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

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
      Uri.parse('https://www.openzo.in'),
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
