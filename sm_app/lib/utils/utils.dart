import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Utils {
  static void errorMessage(String msg, BuildContext context) {
    Flushbar(
      message: msg,
      messageText: Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      icon: const Icon(
        Icons.error_outline,
        color: Colors.redAccent,
        size: 28,
      ),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.black87,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      duration: const Duration(seconds: 4),
      forwardAnimationCurve: Curves.easeOutExpo,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  static void successMessage(String msg, BuildContext context) {
    Flushbar(
      message: msg,
      messageText: Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.greenAccent,
        size: 28,
      ),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.black87,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      duration: const Duration(seconds: 4),
      forwardAnimationCurve: Curves.easeOutExpo,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  static void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void displayMessages(dynamic data, BuildContext context) {
    if (data['status'] == 'error') {
      Utils.errorMessage(data['msg'], context);
    } else {
      Utils.successMessage(data['msg'], context);
    }
  }
}
