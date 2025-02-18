import 'package:chawi_hotel/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.7, 1.0],
            colors: [
              AppColors.primary,
              const Color.fromARGB(255, 4, 107, 64),
              Colors.white
            ],
          ),
        ),
        child: Center(
          child: AnimatedSplashScreen(
            duration: 2000,
            splash: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to Hotel Booking',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.transparent,
            nextScreen: OnBoarding(),
          ),
        ),
      ),
    );
  }
}
