import 'package:flutter/material.dart';
import '../Helper/color.dart';

setSnackbar(String msg, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: black,
        ),
      ),
      duration: const Duration(
        seconds: 2,
      ),
      backgroundColor: white,
      elevation: 1.0,
    ),
  );
}
