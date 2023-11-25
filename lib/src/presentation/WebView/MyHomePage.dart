import 'package:app_portfolio/src/Config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late InAppWebViewController _webViewController;
  Uri? appUrl;
  @override
  void initState() {
    appUrl = Uri.tryParse(AppConstants.appUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _goBack,
        child: webView(),
      ),
    );
  }

  Future<bool> _goBack() async {
    if (await _webViewController.canGoBack()) {
      _webViewController.goBack();
      return false;
    }
    return true;
  }

  Widget webView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: appUrl),
      initialOptions:
          InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions()),
      onWebViewCreated: (InAppWebViewController controller) {
        _webViewController = controller;
      },
    );
  }
}
