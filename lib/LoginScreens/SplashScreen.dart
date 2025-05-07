import 'package:flutter/material.dart';
import 'package:motorbikesafety/LoginScreens/RoleSelectionScreen.dart';

class TrafficGuardianApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Guardian',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEAEA), // light grey background
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top time and icons

            // Main image
            Center(
              child: Image.asset(
                'assets/logo.png', // Make sure you place your icon here
                height: 180,
              ),
            ),

            SizedBox(height: 20),

            // Title
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Traffic',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  TextSpan(
                    text: 'Guardian',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            Text(
              'Real Time traffic monitoring',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            Text(
              '&',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            Text(
              'Automatic Violations Detection System',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),

            SizedBox(height: 40),

            // Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF28A9A1),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
