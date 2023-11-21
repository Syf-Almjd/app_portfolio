import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppWidgets {
  static Widget loadingAnimation = LoadingAnimationWidget.staggeredDotsWave(
      size: 30, color: CupertinoColors.systemPurple);
}
