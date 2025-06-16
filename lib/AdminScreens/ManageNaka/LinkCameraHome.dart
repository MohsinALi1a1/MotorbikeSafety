import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:motorbikesafety/Model/Camera.dart';
import 'package:motorbikesafety/Model/CameraNaka.dart';

import 'package:motorbikesafety/Model/Naka.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class LinkCameraHome extends StatefulWidget {
  final Naka naka;

  const LinkCameraHome({super.key, required this.naka});

  @override
  _LinkCameraHomeState createState() => _LinkCameraHomeState();
}

class _LinkCameraHomeState extends State<LinkCameraHome> {
  API api = API();
  bool _isLoading = false;
  List<CameraNaka> cameraList = [];
  List<CameraNaka> unselectedCameras = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _getcamera(widget.naka.name);
  }

  void toggleCameraSelection(CameraNaka camera) {
    setState(() {
      if (unselectedCameras.any((c) => c.camera_id == camera.camera_id)) {
        unselectedCameras.removeWhere((c) => c.camera_id == camera.camera_id);
      } else {
        unselectedCameras.add(camera);
      }
    });
  }

  Future<void> _getcamera(String chowkiname) async {
    if (chowkiname.isEmpty) {
      _showSnackbar('Please Pass Naka name ');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await api.getAllCamerasofNaka(chowkiname);

      if (response.statusCode == 200) {
        List<dynamic> cameramap = json.decode(response.body);
        setState(() {
          cameraList = cameramap.map((e) => CameraNaka.fromMap(e)).toList();
        });
      } else if (response.statusCode == 404) {
        setState(() {
          cameraList = [];
        });
        _showSnackbar('No Camera found for $chowkiname ');
      } else {
        setState(() {
          cameraList = [];
        });
        _showSnackbar('Failed to fetch cameras');
      }
    } catch (e) {
      _showSnackbar('Error: $e');
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Attach the global key
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade800, Colors.teal.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 6.0,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.teal.shade900,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Link Camera",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Link Camera with Naka",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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
          children: [
            // Display Chowki Name at the Top
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal),
              ),
              child: Text(
                "Chowki: ${widget.naka.name}",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54),
              ),
            ),
            SizedBox(height: 10),
            _isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: cameraList.isNotEmpty
                        ? ListView.builder(
                            itemCount: cameraList.length,
                            itemBuilder: (context, index) {
                              CameraNaka camera = cameraList[index];
                              bool isSelected = unselectedCameras
                                  .any((c) => c.camera_id == camera.camera_id);

                              return GestureDetector(
                                // onTap: () => toggleCameraSelection(camera),
                                child: Card(
                                  margin: const EdgeInsets.all(8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: isSelected
                                      ? Colors.teal.shade100
                                      : Colors.white,
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Camera ID: ${camera.camera_id}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal.shade700,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Camera Name: ${camera.camera_name}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // IconButton(
                                        //   icon: Icon(
                                        //     isSelected
                                        //         ? Icons.link_off
                                        //         : Icons.link,
                                        //     color: isSelected
                                        //         ? Colors.red
                                        //         : Colors.blue,
                                        //   ),
                                        //   onPressed: () {
                                        //     toggleCameraSelection(camera);
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(child: Text('No Camera Found')),
                  ),
          ],
        ),
      ),
    );
  }
}
