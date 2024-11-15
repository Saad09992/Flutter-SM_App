// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sm_app/utils/secure_storage.dart';
import 'package:sm_app/utils/routes/routes_name.dart';
import 'package:get/get.dart';
import 'package:sm_app/controller/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthController authController = Get.find();

  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    // Check if token exists
    String? token = await secureStorage.readStorageData('token');

    // Navigate based on token existence
    if (token != null) {
      // Navigate to Home if token exists
      authController.setLoggedIn(true);
      Navigator.pushReplacementNamed(context, RoutesName.home);
    } else {
      // Navigate to Login if no token exists
      Navigator.pushReplacementNamed(context, RoutesName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
