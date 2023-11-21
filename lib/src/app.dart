import 'package:app_portfolio/src/Config/AppAssets.dart';
import 'package:app_portfolio/src/Config/AppConstants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'domain/AppConnectivity.dart';
import 'presentation/WebView/MyHomePage.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map _source = {ConnectivityResult.none: false};
  final AppConnectivity _connectivity = AppConnectivity.instance;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = false;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        isConnected = true;
        break;
      case ConnectivityResult.wifi:
        isConnected = true;
        break;
      case ConnectivityResult.none:
      default:
        isConnected = false;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.title,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Visibility(
        replacement: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage(AppAssets.noDataLogo)),
                const SizedBox(
                  height: 10,
                  width: 10,
                ),
                Text(
                  AppConstants.noDataMessage,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                  width: 50,
                ),
                LoadingAnimationWidget.waveDots(
                    color: isConnected ? Colors.green : Colors.red, size: 50),
                const SizedBox(
                  height: 10,
                  width: 10,
                ),
                Text(
                  isConnected
                      ? AppConstants.connectedMessage
                      : AppConstants.disconnectedMessage,
                  style: TextStyle(
                      color: isConnected ? Colors.green : Colors.red,
                      fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        child: MyHomePage(),
      ),
    );
  }
}
