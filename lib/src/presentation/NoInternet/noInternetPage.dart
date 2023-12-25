import 'package:flutter/material.dart';

import '../../Config/AppAssets.dart';
import '../../Config/AppConstants.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage(AppAssets.noDataLogo)),
          SizedBox(
            height: 10,
            width: 10,
          ),
          Text(
            AppConstants.noDataMessage,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
            width: 50,
          ),
          Text(
            AppConstants.disconnectedMessage,
            style: TextStyle(color: Colors.red, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
