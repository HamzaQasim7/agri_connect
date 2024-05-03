import 'package:flutter/material.dart';

extension CustomSnackBar on BuildContext {
  void showCustomSnackBar(String value) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(value)),
    );
  }
}
