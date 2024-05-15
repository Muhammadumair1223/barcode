import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      final controller = Provider.of<AuthController>(context, listen: false);
      if (controller.isLogged()) {
        Navigator.pushReplacementNamed(context, "/checkprice");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
