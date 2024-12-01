import 'package:barber_shop/resources/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

// Custom Progress indicator

class CustomProgress {
  late SimpleFontelicoProgressDialog progressDialog;
  BuildContext context;

  CustomProgress(this.context);

  // Show progress
  void showDialog(
      String message, SimpleFontelicoProgressDialogType type) async {
    progressDialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    progressDialog.show(
        backgroundColor: backGroundColor,
        message: message,
        type: type,
        indicatorColor: textColor);
  }

  // hide progress
  void hideDialog() async {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
