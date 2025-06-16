import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motorbikesafety/Service/ApiHandle.dart';

class getimage extends StatefulWidget {
  const getimage({super.key});

  @override
  _getimageState createState() => _getimageState();
}

class _getimageState extends State<getimage> {
  final TextEditingController _cnicController = TextEditingController();
  List<dynamic> _imageData = []; // List to store image paths
  String? name;
  String? cnic1;
  String? email;
  String? mobile;
  API a = new API();

  // Function to fetch image paths from the server
  Future<void> _fetchImages() async {
    final cnic = _cnicController.text;
    if (cnic.isEmpty) {
      // Display a message if the CNIC is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a CNIC')),
      );
      return;
    }

    final url =
        '${API.baseurl}/get-images/$cnic'; // Replace with your server URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _imageData = responseData['image_data'] ?? [];
          name = responseData['user_data']['name'];
          cnic1 = responseData['user_data']['cnic'];
          mobile = responseData['user_data']['mobilenumber'];
          email = responseData['user_data']['email']; // Update image data
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch images.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(150), // Adjusted height for better spacing
        child: AppBar(
          automaticallyImplyLeading: false, // Removes default back button
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade700, Colors.teal.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Get Images",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Automated Motorbike Safety Violation Detection and Alert System for Traffic Police",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _cnicController,
              decoration: InputDecoration(
                labelText: 'Enter CNIC',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            // Button to fetch images based on CNIC
            ElevatedButton(
              onPressed: _fetchImages,
              child: Text('Get Images'),
            ),
            SizedBox(height: 20),
            name != null ? Text("name :$name") : SizedBox(),
            SizedBox(height: 20),
            // Display fetched images
            _imageData.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _imageData.length,
                      itemBuilder: (context, index) {
                        var item = _imageData[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display the filename (optional, just for clarity)
                            Text(
                              'File: ${item['img_path']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            // Image display using the filepath returned by the server
                            Image.network(
                              "${API.baseurl}/uploadsmulti/${item['img_path']}",
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  )
                : Center(child: Text('No images available for this CNIC')),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(50),
                  elevation: 5,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
