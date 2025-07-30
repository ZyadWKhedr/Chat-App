import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ToastService {
  static void show(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0.sp,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  }
}
