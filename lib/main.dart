import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_tracker/pages/login.dart';
import 'package:food_tracker/pages/user/user_main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for Errors
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return MaterialApp(
              title: 'Food Tracking System',
              theme: ThemeData(
                primarySwatch: Colors.green,
              ),
              debugShowCheckedModeBanner: false,
              home: AnimatedSplashScreen(
                duration: 4000,
                splash: Image.asset('assets/image.png'),
                nextScreen: Login(),
                splashTransition: SplashTransition.rotationTransition,
                backgroundColor: Colors.lightBlue.shade200,
              ));
        });
  }
}
