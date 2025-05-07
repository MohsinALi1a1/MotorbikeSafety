import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:motorbikesafety/MobileCamera/SingleImage/Responsescreen.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image;
  final picker = ImagePicker();

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Capture image from camera
  Future<void> _captureImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Upload image to API
  Future<void> _uploadImage() async {
    if (_image == null) return;

    final uri = Uri.parse(
        "http://127.0.0.1:4321/upload-image"); // Replace with your API URL

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final responseData = jsonDecode(responseString);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResponseScreen(responseData),
          ),
        );
      } else {
        _showErrorDialog("Failed to upload image. Please try again.");
      }
    } catch (e) {
      _showErrorDialog("Error uploading image: $e");
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
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
              // Ensures content is centered
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers content vertically
                children: [
                  Text(
                    "Camera Detection",
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Container(
                    width: 300, // Set the width of the image container
                    height: 300,
                    color: Colors.grey, // Set the height of the image container
                    child: Center(
                      child: Text('No Image is Selected'),
                    ))
                : SizedBox(
                    width: 300, // Set the width of the image container
                    height: 300, // Set the height of the image container
                    child: Image.file(
                      _image!,
                      fit: BoxFit
                          .cover, // Ensure the image fits within the container
                    ),
                  ),
            SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton(
            //       onPressed: _pickImage,
            //       child: Text('Pick Image'),
            //     ),
            //     SizedBox(width: 20),
            //     ElevatedButton(
            //       onPressed: _captureImage,
            //       child: Text('Capture Image'),
            //     ),
            //   ],
            // ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(50),
                  elevation: 5,
                ),
                onPressed: _pickImage,
                child: const Text(
                  'Upload Image',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(50),
                  elevation: 5,
                ),
                onPressed: _uploadImage,
                child: const Text(
                  'Submit Image',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
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
