import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;

  const LoadingIndicator({super.key, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return CircularProgressIndicator(color: color);

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return CupertinoActivityIndicator(color: color);
      default:
        return CircularProgressIndicator(color: color);
    }
  }
}
