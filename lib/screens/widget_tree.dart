import 'package:chawi_hotel/main.dart';
import 'package:chawi_hotel/screens/home_screen.dart';
import 'package:chawi_hotel/screens/splash_screen.dart';
import 'package:chawi_hotel/widgets/bottomnavbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Bottomnavscreen();
        } else {
          return SplashScreen();
        }
      },
    );
  }
}
