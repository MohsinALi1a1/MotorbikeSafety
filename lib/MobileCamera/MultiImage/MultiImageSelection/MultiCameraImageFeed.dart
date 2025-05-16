import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motorbikesafety/Model/Camera.dart';
import 'package:motorbikesafety/Model/City.dart';
import 'package:motorbikesafety/Model/Direction.dart';
import 'package:motorbikesafety/Model/Place.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class CameraUploadScreen extends StatefulWidget {
  @override
  _CameraUploadScreenState createState() => _CameraUploadScreenState();
}

class _CameraUploadScreenState extends State<CameraUploadScreen> {
  API api = API();
  bool _isLoading = false;
  List<Place> placeList = [];
  List<City> cityList = [];
  List<Direction> directionList = [];
  List<Camera> cameraList = [];
  String? selectedCity;
  String? selectedPlace;
  String? selectedDirection;

  Map<int, XFile?> uploadedImages = {};
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false;

  Future<void> _uploadImages() async {
    final uri = Uri.parse("http://192.168.1.5:4321/upload-multicameraimages");
    final request = http.MultipartRequest('POST', uri);

    List<int> indices = [];

    for (var entry in uploadedImages.entries) {
      final index = entry.key;
      final xfile = entry.value;

      if (xfile != null) {
        indices.add(index);
        request.files.add(await http.MultipartFile.fromPath(
          'images',
          xfile.path,
          filename: "image_$index.jpg",
        ));
      }
    }

    if (indices.isEmpty) {
      _showErrorDialog("Please select at least one image.");
      return;
    }

    request.fields['image_indices'] = indices.join(',');

    setState(() => isUploading = true);

    try {
      final response = await request.send();

      setState(() => isUploading = false);

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final responseData = jsonDecode(responseString);
        _showSuccessDialog("Upload Successful!", responseData);
      } else {
        _showErrorDialog("Failed to upload images. Please try again.");
      }
    } catch (e) {
      setState(() => isUploading = false);
      _showErrorDialog("Error uploading images: $e");
    }
  }

  void _showSuccessDialog(String title, dynamic data) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(data.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text("OK"),
            )
          ],
        );
      },
    );
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

  Future<void> _getplaces(String name) async {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Pass a city name')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await api.getAllplaces(name);

      if (response.statusCode == 200) {
        List<dynamic> placemap = json.decode(response.body);
        placeList = placemap.map((e) => Place.fromMap(e)).toList();
        selectedPlace = placeList.isNotEmpty ? placeList[0].name : null;
        if (selectedPlace != null) {
          _getdirection(selectedPlace!);
        } else {
          directionList = [];
          cameraList = [];
        }
      } else if (response.statusCode == 404) {
        placeList = [];
        directionList = [];
        cameraList = [];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No places found for the specified city')),
        );
      } else {
        placeList = [];
        directionList = [];
        cameraList = [];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch places')),
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

  Future<void> _getdirection(String name) async {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Pass a Place name')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await api.getAllDirection(name);

      if (response.statusCode == 200) {
        List<dynamic> directionmap = json.decode(response.body);
        directionList = directionmap.map((e) => Direction.fromMap(e)).toList();
        selectedDirection =
            directionList.isNotEmpty ? directionList[0].name : null;
        if (selectedDirection != null) {
          _getcamera(selectedPlace!, selectedDirection!);
        } else {
          cameraList = [];
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Direction fetched successfully')),
        // );
      } else if (response.statusCode == 404) {
        directionList = [];
        cameraList = [];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Direction found for the specified Place')),
        );
      } else {
        directionList = [];
        cameraList = [];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch Direction')),
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

  Future<void> _getcamera(String placename, String directionname) async {
    if (placename.isEmpty || directionname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Pass a Camera name')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await api.getAllCamera(placename, directionname);

      if (response.statusCode == 200) {
        List<dynamic> cameramap = json.decode(response.body);

        cameraList = cameramap.map((e) => Camera.fromMap(e)).toList();
        uploadedImages = {
          for (var cam in cameraList) cam.id!: null,
        };
      } else if (response.statusCode == 404) {
        cameraList = [];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'No Camera found for the ${placename} at point ${directionname} ')),
        );
      } else {
        cameraList = [];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch Camera')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print("eror$e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCities() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await api.getAllCities();

      if (response.statusCode == 200) {
        List<dynamic> mapList = jsonDecode(response.body);
        cityList = mapList.map((e) => City.fromMap(e)).toList();

        // Set the first city as the selected city by default
        selectedCity = cityList.isNotEmpty ? cityList[0].name : null;

        // Fetch places for the default selected city
        if (selectedCity != null) {
          _getplaces(selectedCity!);
        }

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Cities fetched successfully')),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch cities')),
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
    _getCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildGradientAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDropdowns(),
                      const SizedBox(height: 20),
                      _buildCameraList(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            minimumSize: const Size.fromHeight(50),
                            elevation: 5,
                          ),
                          onPressed: () {
                            _uploadImages();
                          },
                          child: isUploading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Submit Images',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientAppBar() {
    return PreferredSize(
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
                // Back Arrow Button
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
                        "Camera Upload",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Upload images for traffic cameras",
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
    );
  }

  Widget _buildDropdowns() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedCity,
          decoration: InputDecoration(
            labelText: "Select City",
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          items: cityList.map((city) {
            return DropdownMenuItem(
              value: city.name,
              child: Text(city.name),
            );
          }).toList(), // <-- Don't forget the comma here!
          onChanged: (value) {
            setState(() {
              selectedCity = value;
              _getplaces(selectedCity!);
              uploadedImages = {};
              selectedPlace = null;
              selectedDirection = null;
            });
          },
        ),
        const SizedBox(height: 12),
        if (selectedCity != null)
          DropdownButtonFormField<String>(
            value: selectedPlace,
            decoration: InputDecoration(
              labelText: placeList.isEmpty ? "No Place Found" : "Select Place",
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            items: placeList.map((place) {
              return DropdownMenuItem(
                value: place.name,
                child: Text(place.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedPlace = value;
                _getdirection(selectedPlace!);
                uploadedImages = {};
                selectedDirection = null;
              });
            },
          ),
        const SizedBox(height: 12),
        if (selectedPlace != null)
          DropdownButtonFormField<String>(
            value: selectedDirection,
            decoration: InputDecoration(
              labelText: directionList.isEmpty
                  ? "No Direction Found"
                  : "Select Direction",
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            items: directionList.map((direction) {
              return DropdownMenuItem(
                value: direction.name,
                child: Text(direction.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedDirection = value;
                uploadedImages = {};
                _getcamera(selectedPlace!, selectedDirection!);
              });
            },
          ),
      ],
    );
  }

  Widget _buildCameraList() {
    if (selectedDirection == null) {
      return const SizedBox.shrink();
    }

    if (cameraList.isEmpty) {
      return const Text("No Camera Found",
          style: TextStyle(color: Colors.grey));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cameraList.length,
      itemBuilder: (context, index) {
        final camera = cameraList[index];
        final image = uploadedImages[camera.id!];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(camera.Type,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                image != null
                    ? Column(
                        children: [
                          Image.file(
                            File(image.path),
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() => uploadedImages[camera.id!] = null);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text("Remove",
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      )
                    : ElevatedButton.icon(
                        onPressed: () async {
                          final picked = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (picked != null) {
                            setState(() {
                              uploadedImages[camera.id!] = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.upload),
                        label: const Text("Upload Image"),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
