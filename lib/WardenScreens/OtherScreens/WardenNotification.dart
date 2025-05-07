import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motorbikesafety/Model/NotificationModel.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';
import 'package:motorbikesafety/WardenScreens/OtherScreens/WardenNotificationDetailPage.dart';

class WardenNotificationsPage extends StatefulWidget {
  final int id;
  const WardenNotificationsPage({super.key, required this.id});
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<WardenNotificationsPage> {
  API api = API();
  bool _isLoading = false;
  List<NotificationModel> notificationList = [];

  final Map<String, IconData> iconMap = {
    "Violation Alert": Icons.warning_amber_rounded,
    "TrafficWarden": Icons.security,
    "Camera": Icons.videocam,
    "Challan Issued": Icons.receipt_long,
    "Shift Start": Icons.access_time_filled,
    "Shift End": Icons.flag,
    "Success": Icons.check_circle,
    "Error": Icons.error,
    "Info": Icons.info,
    "System Upgrade": Icons.system_update,
    "Warning": Icons.warning,
    "User": Icons.person,
    "Duty Roster": Icons.work,
    "Reminder": Icons.notifications_active,
  };

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

  @override
  void initState() {
    super.initState();

    fetchNotifications();
  }

  @override
  void dispose() {
    stopFetchingNotifications();
    super.dispose();
  }

  String formatTime(DateTime time) {
    return DateFormat('MMM dd, hh:mm a').format(time);
  }

  void openNotificationPage(
      BuildContext context, Map<String, dynamic> notification) {
    Widget page;
    switch (notification["type"]) {
      case "Violation Alert":
        page = WardenNotificationDetailPage(
            notification: notification); // Create a page for violation alerts
        break;
      case "System Upgrade":
        page = WardenNotificationDetailPage(
            notification: notification); // Create a page for system updates
        break;
      case "New Duty Assigned":
        page = WardenNotificationDetailPage(
            notification: notification); // Create a page for duty assignments
        break;
      default:
        page = WardenNotificationDetailPage(
            notification: notification); // Default page for other notifications
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications",
            style: TextStyle(fontWeight: FontWeight.bold)),
        // actions: [
        //   if (notificationList.isNotEmpty)
        //     // TextButton(
        //     //   // onPressed: markAllAsRead,
        //     //   child:
        //     //       Text("Mark All Read", style: TextStyle(color: Colors.white)),
        //     // ),
        // ],
      ),
      body: notificationList.isEmpty
          ? Center(
              child: Text(
                "No new notifications",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final notification = notificationList[index];
                return Dismissible(
                  key: Key(notificationList[index].message),
                  direction: DismissDirection.endToStart,
                  // onDismissed: (direction) => removeNotification(index),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            notificationList[index].type == "Violation Alert"
                                ? Colors.red.withOpacity(0.2)
                                : Colors.white,
                        child: Icon(
                          iconMap[notificationList[index].type],
                          color:
                              notificationList[index].type == "Violation Alert"
                                  ? Colors.red
                                  : Colors.green,
                        ),
                      ),
                      title: Text(
                        notificationList[index].type,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notificationList[index].message),
                          SizedBox(height: 5),
                          Text(notificationList[index].createdAt.toString(),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                      // onTap: () => openNotificationPage(context,  notificationList[index]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
