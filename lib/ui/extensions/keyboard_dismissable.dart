import 'package:flutter/material.dart';

extension DismissKeyboard on BuildContext {
  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
