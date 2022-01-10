import 'package:flutter/material.dart';

class StatusSnackBar {
  static void show(BuildContext context, String content) {
    var snackBar = SnackBar(
        content: Text(content),
        backgroundColor: Theme.of(context).primaryColorLight);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
