import 'package:flutter/material.dart';
import 'package:motorbikesafety/AdminScreens/OtherScreens/AdminEditProfilePage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, String> wardenDetails = {
    "name": "Ali Khan",
    "badge_number": "TW-4567",
    "cnic": "42101-1234567-8",
    "email": "ali.khan@example.com",
    "mobile_number": "+92 321 9876543",
    "city": "Islamabad",
    "image_url": "assetslogo.png", // Replace with actual image path
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Traffic Warden Profile"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditAdminProfilePage(wardenDetails: wardenDetails),
                ),
              ).then((updatedDetails) {
                if (updatedDetails != null) {
                  setState(() {
                    wardenDetails = updatedDetails;
                  });
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(wardenDetails["image_url"]!),
            ),
            SizedBox(height: 20),

            // Warden Details
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildProfileItem(
                        Icons.person, "Name", wardenDetails["name"]!),
                    _buildProfileItem(Icons.badge, "Badge Number",
                        wardenDetails["badge_number"]!),
                    _buildProfileItem(
                        Icons.credit_card, "CNIC", wardenDetails["cnic"]!),
                    _buildProfileItem(
                        Icons.email, "Email", wardenDetails["email"]!),
                    _buildProfileItem(
                        Icons.phone, "Mobile", wardenDetails["mobile_number"]!),
                    _buildProfileItem(
                        Icons.location_city, "City", wardenDetails["city"]!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 10),
          Text(
            "$title: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
