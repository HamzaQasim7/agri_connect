import 'package:farmassist/app_theme.dart';
import 'package:flutter/material.dart';

class UserMessageHelper {
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        backgroundColor: AppTheme.nearlyGreen,
        behavior: SnackBarBehavior.floating,
        content: Text(msg),
      ),
    );
  }
}
