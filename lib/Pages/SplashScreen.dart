import 'package:flutter/material.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../Services/FirebaseDBService.dart';
import 'HomePage.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: 'assets/splash.png',
      splashIconSize: 200,
      screenFunction: () async {
        print(Firebase.apps.length);

        if (FirebaseAuth.instance.currentUser != null) {
          print(
              "logged in uid:${FirebaseAuth.instance.currentUser.uid} mobile:${FirebaseAuth.instance.currentUser.phoneNumber}");
          if (await RestaurantDBService().checkExistingRestaurant()) {
            Get.offAllNamed("/dashboard");
          } else {
            print("Not Registered yet");
            Get.offAllNamed('/registerinfo');
          }
        } else {
          print("Not logged in");
        }
        return HomePage();
      },
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: Duration(milliseconds: 0),
      backgroundColor: Colors.amber,
    );
  }
}
