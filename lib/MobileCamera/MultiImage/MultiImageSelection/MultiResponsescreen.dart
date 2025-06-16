import 'package:flutter/material.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class MultiResponseScreen extends StatelessWidget {
  final dynamic responseData;

  const MultiResponseScreen(this.responseData, {super.key});

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
                    "Violations Detected and Saved Paths",
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Image Saved Path:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Check if 'image_data' exists in the response
                responseData['image_data'] != null
                    ? Column(
                        children: List.generate(
                          responseData['image_data'].length,
                          (index) {
                            var item = responseData['image_data'][index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display the filename (optional, just for clarity)
                                Text(
                                  'File: ${item['filename']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                // Image display using the filepath returned by the server
                                Image.network(
                                  "${API.baseurl}/uploadsmulti/${item['filename']}",
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
                    : Text('No Image Saved.'),
                SizedBox(height: 50),
                // Back Button
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
        ],
      ),
    );
  }
}
