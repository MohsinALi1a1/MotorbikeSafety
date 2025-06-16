import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WardenNotificationDetailPage extends StatelessWidget {
  final Map<String, dynamic> notification;

  const WardenNotificationDetailPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(notification["type"])),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: notification["color"].withOpacity(0.2),
                  child:
                      Icon(notification["icon"], color: notification["color"]),
                ),
                SizedBox(width: 10),
                Text(
                  notification["type"],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              notification["message"],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Received: ${DateFormat('MMM dd, hh:mm a').format(notification["time"])}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
