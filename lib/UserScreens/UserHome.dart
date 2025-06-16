import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motorbikesafety/Model/DutyRoster.dart';
import 'package:motorbikesafety/Model/NotificationModel.dart';
import 'package:motorbikesafety/Model/user.dart';

import 'package:motorbikesafety/Service/ApiHandle.dart';
import 'package:motorbikesafety/UserScreens/Challan/UserChallanHistory.dart';
import 'package:motorbikesafety/WardenScreens/Challan/ChallanHistory.dart';

import 'package:motorbikesafety/WardenScreens/OtherScreens/WardenNotification.dart';

class Userhome_page extends StatefulWidget {
  final int id;
  const Userhome_page({super.key, required this.id});

  @override
  State<Userhome_page> createState() => _Userhome_pageState();
}

class _Userhome_pageState extends State<Userhome_page> {
  String? username;
  int? TotalFine;
  API api = API();
  bool _isLoading = false;
  List<User> userlist = [];
  List<NotificationModel> notificationList = [];
  Timer? _timer;

  User? user;
  void startFetchingNotifications() {
    // Cancel existing timer if any
    _timer?.cancel();

    // Start periodic fetch every 1 second
    _timer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      fetchNotifications();
    });
  }

  void stopFetchingNotifications() {
    _timer?.cancel();
  }

  Future<void> fetchNotifications() async {
    print("Fetching notifications...");

    try {
      var response = await api.getnotificationbyuserid(int.parse(user!.cnic));

      if (response.statusCode == 200) {
        List<dynamic> notificationMap = json.decode(response.body);

        List<NotificationModel> notificationList =
            notificationMap.map((e) => NotificationModel.fromJson(e)).toList();

        if (notificationList.isEmpty) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('No Notifications Found')),
          // );
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Notifications Fetched Successfully')),
          // );
        }

        // If you store the list in state, do it here
        setState(() {
          this.notificationList = notificationList;
        });
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Notifications Found')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch Notifications')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getuserid(int id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await api.getuserbyid(id);

      if (response.statusCode == 200) {
        Map<String, dynamic> userMap = json.decode(response.body);
        user = User.fromMap(userMap); // Assuming fromMap returns a single User
        username = user!.name;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User fetched successfully')),
        );
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getuserid(widget.id);
    fetchNotifications();
    startFetchingNotifications();
  }

  @override
  void dispose() {
    stopFetchingNotifications();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade700, Colors.teal.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                      20.0), // Outer padding around the entire widget
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape
                          .circle, // Makes the container's shape circular
                      border: Border.all(
                          color: Colors.black,
                          width:
                              2), // Adds a black border around the CircleAvatar
                    ),
                    child: CircleAvatar(
                      radius: 50, // The radius of the CircleAvatar
                      backgroundColor: Colors
                          .white, // The background color of the CircleAvatar
                      backgroundImage: AssetImage(
                          'assets/logo.png'), // The image displayed inside the CircleAvatar
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      username != null
                          ? Text(
                              "Welcome Back,$username",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : CircularProgressIndicator(),
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WardenNotificationsPage(
                                          id: widget.id,
                                        )),
                              );
                            },
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          if (notificationList.isNotEmpty)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${notificationList.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: const Text(
                  "UnPaid Challan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  "1000",
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: const Text(
                  "Total Fine",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  "Rs. ${1000}",
                  style: const TextStyle(fontSize: 18, color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  int? cnicInt = int.tryParse(user!.cnic);
                  if (cnicInt != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserChallanHistoryScreen(
                          user_cnic: cnicInt,
                        ),
                      ),
                    );
                  } else {
                    // Handle invalid CNIC format
                  }
                },
                child: const Text(
                  'View Challans',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 14),

          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.teal,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.teal, // Unfocused border color
              width: 1.5,
            ),
          ),
          // The border when the TextFormField is focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.teal, // Focused border color
              width: 2.0, // Thicker border when focused
            ),
          ),
        ),
      ),
    );
  }
}
