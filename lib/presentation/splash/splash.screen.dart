import 'dart:async';
import 'package:bayamsalam/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextScreen();
  }

  Future<void> _decideNextScreen() async {
    // CORRECTION : Durée ajustée à 2.5 secondes
    await Future.delayed(const Duration(milliseconds: 2500));

    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenIntro = prefs.getBool('has_seen_intro') ?? false;

    if (hasSeenIntro) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.INTRODUCTION);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animations/splash_animation.json', 
          width: 250,
          height: 250,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
