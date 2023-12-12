import 'dart:async';

import 'package:flutter/material.dart';
import '../service/spotify.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Spotify.checkValidity().then((value) {
      if (value) {
        Timer(const Duration(seconds: 2),
            () => Navigator.pushReplacementNamed(context, "/home"));
      } else {
        Timer(const Duration(seconds: 2),
            () => Navigator.pushReplacementNamed(context, "/login"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: Center(
          child: Image.asset(
        "assets/images/logo.png",
        width: MediaQuery.of(context).size.width / 2,
      )),
    );
  }
}
