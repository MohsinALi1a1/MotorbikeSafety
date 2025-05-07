import 'dart:convert';
import 'package:flutter/material.dart';

class ResponseScreen extends StatelessWidget {
  final dynamic responseData;

  const ResponseScreen(this.responseData, {super.key});

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
              // Ensures content is centered
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers content vertically
                children: [
                  Text(
                    "Violation Detector ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Automated Motorbike Safety Violation Detection and Alert System for Traffic Police",
                    textAlign: TextAlign.center, // Centers text horizontally
                    style: TextStyle(
                      color: Colors
                          .grey[200], // Use light grey for better visibility
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
            Text(
              'Violations Detected:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            responseData['violations_and_plates'] != null
                ? Column(
                    children: List.generate(
                      responseData['violations_and_plates'].length,
                      (index) {
                        var item = responseData['violations_and_plates'][index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Violations: ${item['violations'].join(', ')}'),
                            item['cropped_license_plate'] != null
                                ? Image.memory(
                                    base64Decode(item['cropped_license_plate']),
                                    width: 300, // Set width for cropped plates
                                    height:
                                        300, // Set height for cropped plates
                                    fit: BoxFit.cover,
                                  )
                                : Container(),
                            SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  )
                : Text('No violations detected.'),
            SizedBox(
              height: 50,
            ),
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
