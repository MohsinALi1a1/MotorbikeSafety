import 'package:flutter/material.dart';
import 'package:motorbikesafety/AdminScreens/AdminHome.dart';
import 'package:motorbikesafety/AdminScreens/OtherScreens/AdminNotification.dart';
import 'package:motorbikesafety/AdminScreens/OtherScreens/AdminProfile.dart';
import 'package:motorbikesafety/AdminScreens/OtherScreens/AdminSetting.dart';

class AdminMain extends StatefulWidget {
  final int id; // Accepts the ID

  const AdminMain({Key? key, required this.id})
      : super(key: key); // Updated constructor

  @override
  _AdminMainState createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // If you want to pass the ID to child pages, do it here
    _pages = [
      Adminhome_page(id: widget.id),
      NotificationsPage(),
      ProfilePage(),
      SettingsPage(),
    ];
  }

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
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
