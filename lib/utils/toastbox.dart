import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showToast(String msg, String status) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 3,
    backgroundColor: (status == 'error' ? Color(0xFFFA3B1E) : Colors.grey),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
