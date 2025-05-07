import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:motorbikesafety/MobileCamera/MultiImage/MultiImageSelection/MultiResponsescreen.dart';
import 'package:motorbikesafety/MobileCamera/MultiImage/MultiImageSelection/getimage.dart';
import 'package:motorbikesafety/Model/Camera.dart';
import 'package:motorbikesafety/Model/City.dart';
import 'package:motorbikesafety/Model/Direction.dart';
import 'package:motorbikesafety/Model/Place.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class MultiImagePickerScreen extends StatefulWidget {
  const MultiImagePickerScreen({super.key});

  @override
  _MultiImagePickerScreenState createState() => _MultiImagePickerScreenState();
}

class _MultiImagePickerScreenState extends State<MultiImagePickerScreen> {
  API api = API();
  bool _isLoading = false;
  List<File?> uploadedImages = [];
  List<Place> placeList = [];
  List<City> cityList = [];
  List<Direction> directionList = [];
  List<Camera> cameraList = [];
  String? selectedCity;
  String? selectedPlace;
  String? selectedDirection;

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
    uploadedImages = List<File?>.filled(cameraList.length, null);
  }

  final List<File> _images = []; // List to store selected images
  final picker = ImagePicker();

  // Pick multiple images from gallery
  Future<void> _pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    setState(() {
      _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
    });
  }

  // Remove an image from the list
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery); // or camera

    if (pickedFile != null) {
      setState(() {
        uploadedImages[index] = File(pickedFile.path);
      });
    }
  }

  void removeImages(int index) {
    setState(() {
      uploadedImages[index] = null;
    });
  }

// Upload multiple images to API
  Future<void> _uploadImages() async {
    if (_images.isEmpty) return;

    final uri = Uri.parse(
        "http://127.0.0.1:4321/upload-images"); // Replace with your API URL

    final request = http.MultipartRequest('POST', uri);

    // Add user data (these could also come from the user input fields in your app)

    // Add all images to the request
    for (var image in _images) {
      request.files
          .add(await http.MultipartFile.fromPath('images', image.path));
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final responseData = jsonDecode(responseString);

        // Navigate to the response screen with the API response data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiResponseScreen(responseData),
          ),
        );
      } else {
        _showErrorDialog("Failed to upload images. Please try again.");
      }
    } catch (e) {
      _showErrorDialog("Error uploading images: $e");
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
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => getimage(),
                ),
              );
            },
            child: Icon(Icons.view_array_sharp)),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: AppBar(
            automaticallyImplyLeading: false,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("  Select City"),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.teal, width: 1.5),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 3),
                                child: DropdownButton<String>(
                                  value: selectedCity,
                                  hint: Text(
                                    "Select City",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onChanged: (newValue) {
                                    Future.delayed(Duration.zero, () {
                                      setState(() {
                                        selectedCity = newValue;
                                      });
                                      if (selectedCity != null) {
                                        _getplaces(selectedCity!);
                                      }
                                    });
                                  },
                                  isExpanded: true,
                                  underline: Container(),
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Colors.teal),
                                  items: cityList.map((city) {
                                    return DropdownMenuItem<String>(
                                      value: city.name,
                                      child: Text(
                                        city.name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("  Select Place"),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.teal, width: 1.5),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 3),
                                child: DropdownButton<String>(
                                  value: selectedPlace,
                                  hint: Text(
                                    placeList.isEmpty
                                        ? "No Place Found"
                                        : "Select Place",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onChanged: (newValue) {
                                    Future.delayed(Duration.zero, () {
                                      setState(() {
                                        selectedPlace = newValue;
                                      });
                                      if (selectedPlace != null) {
                                        _getdirection(selectedPlace!);
                                      }
                                    });
                                  },
                                  isExpanded: true,
                                  underline: Container(),
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Colors.teal),
                                  items: placeList.map((place) {
                                    return DropdownMenuItem<String>(
                                      value: place.name,
                                      child: Text(
                                        place.name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("  Select Direction"),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.teal, width: 1.5),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                          child: DropdownButton<String>(
                            value: selectedDirection,
                            hint: Text(
                              directionList.isEmpty
                                  ? "No Direction Found"
                                  : "Select Direction",
                              style: TextStyle(color: Colors.black),
                            ),
                            onChanged: (newValue) {
                              Future.delayed(Duration.zero, () {
                                setState(() {
                                  selectedDirection = newValue;
                                });
                                if (selectedDirection != null) {
                                  _getcamera(
                                      selectedPlace!, selectedDirection!);
                                }
                              });
                            },
                            isExpanded: true,
                            underline: Container(),
                            icon:
                                Icon(Icons.arrow_drop_down, color: Colors.teal),
                            items: directionList.map((direction) {
                              return DropdownMenuItem<String>(
                                value: direction.name,
                                child: Text(
                                  direction.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                cameraList.isEmpty
                    ? Center(child: Text('No Camera Found'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cameraList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cameraList[index].Type,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  uploadedImages[index] != null
                                      ? Column(
                                          children: [
                                            Image.file(
                                              uploadedImages[index]!,
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                            TextButton.icon(
                                              onPressed: () =>
                                                  removeImages(index),
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red),
                                              label: Text("Remove",
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        )
                                      : ElevatedButton.icon(
                                          onPressed: () => pickImage(index),
                                          icon: Icon(Icons.upload),
                                          label: Text("Upload Image"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
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
                    onPressed: uploadedImages.isEmpty ? null : _uploadImages,
                    child: const Text(
                      'Submit Images',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
        ));
  }
}
