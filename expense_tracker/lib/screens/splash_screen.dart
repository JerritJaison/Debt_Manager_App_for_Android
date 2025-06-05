import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../screens/welcome_view.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';


class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context){
    return AnimatedSplashScreen(
      splash: Center(
            child :Lottie.asset(
              'assets/animation/Animation - 1748590378840.json'
            ),
        ),
        nextScreen:const WelcomeView(),
        duration :5000,
        backgroundColor: Colors.transparent,
        splashIconSize: 700,
        );
  }
}