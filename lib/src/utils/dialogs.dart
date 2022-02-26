import 'package:flutter/material.dart';

class Dialogs {
  void defaultDialog(
    BuildContext context,
    String message,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            message,
          ),
        );
      },
    );
  }
}
