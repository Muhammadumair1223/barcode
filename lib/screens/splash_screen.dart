import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isDenied) {
      PermissionStatus permissionStatus = await Permission.storage.request();
      if (permissionStatus.isDenied) {
        openAppSettings();
      }
    } else {
      // Permission is granted
      // Proceed with reading/writing to external storage
    }
  }

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
