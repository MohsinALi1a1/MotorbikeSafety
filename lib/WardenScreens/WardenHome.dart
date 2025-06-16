import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motorbikesafety/Model/DutyRoster.dart';
import 'package:motorbikesafety/Model/NotificationModel.dart';

import 'package:motorbikesafety/Service/ApiHandle.dart';
import 'package:motorbikesafety/WardenScreens/Challan/ChallanHistory.dart';
import 'package:motorbikesafety/WardenScreens/DutyRoster/DutyRosterDetailsScreen.dart';
import 'package:motorbikesafety/WardenScreens/OtherScreens/WardenNotification.dart';

import 'package:motorbikesafety/WardenScreens/Violations/Violationhistory.dart';

class Wardenhome_page extends StatefulWidget {
  final int id;
  const Wardenhome_page({super.key, required this.id});

  @override
  State<Wardenhome_page> createState() => _Wardenhome_pageState();
}

class _Wardenhome_pageState extends State<Wardenhome_page> {
  TextEditingController chowkiController = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  String? Wardenname;
  int? Naka_id;
  API api = API();
  bool _isLoading = false;
  List<DutyRoster> dlist = [];
  List<NotificationModel> notificationList = [];
  Timer? _timer;

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
      var response = await api.getnotificationbywardenid(widget.id);

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

  Future<void> _getwardensdutyrosterbyid(int id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await api.getwardendutyrosterbyid(id);

      if (response.statusCode == 200) {
        List<dynamic> placemap = json.decode(response.body);
        dlist = placemap.map((e) => DutyRoster.fromMap(e)).toList();
        if (dlist.isEmpty) {
          chowkiController.text = "No Naka Assign";
          shiftController.text = "No Shift is Assign";
        } else {
          Naka_id = dlist[0].chowki_id;
          chowkiController.text =
              "${dlist[0].chowkiName!}   (${dlist[0].chowkiPlace!})";

          shiftController.text =
              "${dlist[0].shiftName!}   (${dlist[0].shiftTime!})";
          Wardenname = dlist[0].wardenName;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Warden DutyRoster Fetched successfully')),
        );
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Warden DutyRoster Found')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch Warden Duty Roster')),
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
    await _getwardensdutyrosterbyid(widget.id);
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
                      Wardenname != null
                          ? Text(
                              "Welcome Back,$Wardenname",
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextField(
                  controller: chowkiController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Assign Naka",
                    labelStyle: GoogleFonts.poppins(fontSize: 14),

                    prefixIcon: Icon(Icons.location_city, color: Colors.teal),
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextField(
                  controller: shiftController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Assigned Shift and Time",
                    labelStyle: GoogleFonts.poppins(fontSize: 14),

                    prefixIcon: Icon(Icons.timelapse, color: Colors.teal),
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 150, // Fixed width
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size.fromHeight(50),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // No rounding
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DutyRosterDetailsScreen(
                              duty: dlist[0],
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Duty Roster',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size.fromHeight(50),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // No rounding
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViolationHistoryScreen(
                                naka_id: Naka_id!,
                                warden_id: widget.id,
                              )),
                    );
                  },
                  child: const Text(
                    'View Violations',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.teal,
              //       minimumSize: const Size.fromHeight(50),
              //       elevation: 5,
              //     ),
              //     onPressed: () {
              //       // Navigator.push(
              //       //   context,
              //       //   MaterialPageRoute(
              //       //       builder: (context) => CreateChallanScreen(
              //       //             violationhistory: ,
              //       //             wardenId:widget.id,
              //       //           )),
              //       // );
              //     },
              //     child: const Text(
              //       'Create Challan',
              //       style: TextStyle(fontSize: 16, color: Colors.white),
              //     ),
              //   ),
              // ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size.fromHeight(50),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // No rounding
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChallanHistoryScreen(
                                warden_id: widget.id,
                              )),
                    );
                  },
                  child: const Text(
                    'Challan History',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
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
