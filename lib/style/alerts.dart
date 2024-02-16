import 'package:flutter/material.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class AppAlert {
  void showFailedAlert(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: StyleText.boldBtnText,
        ),
        backgroundColor: ColorPalette.red,
      ),
    );
  }

  void showSuccessAlert(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: StyleText.boldBtnText,
        ),
        backgroundColor: ColorPalette.green,
      ),
    );
  }

  void showConfirmDialog(BuildContext context, String title, String content,
      VoidCallback onConfirm) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.titleSmall,),
        content: Text(content, style: Theme.of(context).textTheme.bodySmall,),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
