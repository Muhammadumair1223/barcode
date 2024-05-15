import 'package:flutter/material.dart';

import '../utils/global_context_key.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snaki(
    {required String msg}) {
  return scaffoldMessengerKey.currentState!.showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 1500),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
