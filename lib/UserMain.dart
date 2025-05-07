import 'package:flutter/material.dart';
import 'package:motorbikesafety/AdminScreens/AdminHome.dart';
import 'package:motorbikesafety/AdminScreens/OtherScreens/AdminNotification.dart';
import 'package:motorbikesafety/AdminScreens/OtherScreens/AdminProfile.dart';
import 'package:motorbikesafety/AdminScreens/OtherScreens/AdminSetting.dart';

import 'package:motorbikesafety/WardenScreens/WardenHome.dart';

class Usermain extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Usermain> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Adminhome_page(
      id: 1,
    ),
    NotificationsPage(),
    ProfilePage(),
    SettingsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pages[_selectedIndex], // Display the selected page
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _onItemTapped, // Handle navigation
        ),
      ),
    );
  }
}
