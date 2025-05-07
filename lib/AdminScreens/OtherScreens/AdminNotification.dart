import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motorbikesafety/AdminScreens/OtherScreens/NotificationDetailPage.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [
    {
      "type": "Violation Alert",
      "message": "Bike No. ABC-123 violated a signal at I-8 Markaz.",
      "time": DateTime.now().subtract(Duration(minutes: 10)),
      "icon": Icons.warning,
      "color": Colors.red
    },
    {
      "type": "System Upgrade",
      "message":
          "New software update available. Update now for better performance.",
      "time": DateTime.now().subtract(Duration(hours: 1)),
      "icon": Icons.system_update,
      "color": Colors.blue
    },
    {
      "type": "New Duty Assigned",
      "message": "You have been assigned duty at Rawal Road Chowki.",
      "time": DateTime.now().subtract(Duration(days: 1)),
      "icon": Icons.work,
      "color": Colors.green
    },
    {
      "type": "Reminder",
      "message": "Your duty starts at 6:00 AM tomorrow. Be prepared.",
      "time": DateTime.now().subtract(Duration(days: 2)),
      "icon": Icons.notifications_active,
      "color": Colors.orange
    },
  ];

  void removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  void markAllAsRead() {
    setState(() {
      notifications.clear();
    });
  }

  String formatTime(DateTime time) {
    return DateFormat('MMM dd, hh:mm a').format(time);
  }

  void openNotificationPage(
      BuildContext context, Map<String, dynamic> notification) {
    Widget page;
    switch (notification["type"]) {
      case "Violation Alert":
        page = NotificationDetailPage(
            notification: notification); // Create a page for violation alerts
        break;
      case "System Upgrade":
        page = NotificationDetailPage(
            notification: notification); // Create a page for system updates
        break;
      case "New Duty Assigned":
        page = NotificationDetailPage(
            notification: notification); // Create a page for duty assignments
        break;
      default:
        page = NotificationDetailPage(
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
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: markAllAsRead,
              child:
                  Text("Mark All Read", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                "No new notifications",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(notification["message"]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => removeNotification(index),
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
                        backgroundColor: notification["color"].withOpacity(0.2),
                        child: Icon(notification["icon"],
                            color: notification["color"]),
                      ),
                      title: Text(
                        notification["type"],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification["message"]),
                          SizedBox(height: 5),
                          Text(formatTime(notification["time"]),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                      onTap: () => openNotificationPage(context, notification),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
