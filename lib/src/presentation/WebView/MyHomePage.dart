import 'package:app_portfolio/src/Config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    final appUrl = Uri.tryParse(AppConstants.appUrl);
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    if (appUrl != null) {
      _webViewController.loadRequest(appUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          if (await _webViewController.canGoBack()) {
            await _webViewController.goBack();
          } else {
            await SystemNavigator.pop();
          }
        },
        child: WebViewWidget(controller: _webViewController),
      ),
    );
  }
}
