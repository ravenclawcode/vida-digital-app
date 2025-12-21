import 'package:flutter/material.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:mindfullshelter/utils/app_assets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _navigateToNextScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.introduction);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        _navigateToNextScreen(context);
      });
    });
    return Scaffold(
      body: SafeArea(
        child: Center(child: Image.asset(icLogo, height: 102, width: 110)),
      ),
    );
  }
}
