import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_tracker/pages/login.dart';

DateTime? dateTime;
String? x;
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
                accentColor: Colors.lightBlue.shade200,
              ),
              debugShowCheckedModeBanner: false,
              home: AnimatedSplashScreen(
                duration: 3000,
                splash: Image.asset('assets/cleangym.jpg'),
                nextScreen: Login(),
                splashTransition: SplashTransition.slideTransition,
                splashIconSize: 250,
                backgroundColor: Colors.lightBlue.shade200,
              ));
        });
  }
}
