import 'package:dungeon_master/sign_in.dart';
import 'package:flutter/material.dart';

import 'Homepage.dart';
import 'Settings.dart';
import 'Sign_up.dart';
import 'SplashScreen.dart';

void main() {
  runApp( SignInApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dungeon Master',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(
        onTimeout: () {
          // Naviguer vers la page d'accueil après le splash
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInApp()),
          );
        },
      ),

    );
  }
}
