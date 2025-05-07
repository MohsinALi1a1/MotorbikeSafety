import 'package:flutter/material.dart';
import 'package:motorbikesafety/LoginScreens/RoleSelectionScreen.dart';
import 'package:motorbikesafety/LoginScreens/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Flow',
      debugShowCheckedModeBanner: false,
      home: TrafficGuardianApp(),
    );
  }
}
