import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:motorbikesafety/AdminScreens/ManageNaka/LinkCamera.dart';
import 'package:motorbikesafety/Model/Camera.dart';
import 'package:motorbikesafety/Model/City.dart';
import 'package:motorbikesafety/Model/Direction.dart';
import 'package:motorbikesafety/Model/Place.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class AddNaka extends StatefulWidget {
  const AddNaka({super.key});

  @override
  State<AddNaka> createState() => _AddNakaState();
}

class _AddNakaState extends State<AddNaka> {
  final TextEditingController _nakacontroller = TextEditingController();
  String? selectedCity;
  String? selectedPlace;

  bool _isLoading = false;
  API api = API();
  List<City> cityList = [];
  List<Place> placeList = [];
  List<Direction> directionList = [];
  List<Direction> selectedDirections = [];
  List<Camera> selectedCameras = [];
  // just for color change

  void toggleDirectionSelection(Direction direction) {
    setState(() {
      if (selectedDirections.contains(direction)) {
        selectedDirections.remove(direction); // Remove if already selected
      } else {
        selectedDirections.add(direction); // Add if not selected
      }
    });
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
        if (cityList.isEmpty) {
          placeList = [];
          directionList = [];
        }

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
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Place fetched successfully')),
        // );
      } else if (response.statusCode == 404) {
        placeList = [];
        directionList = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No places found for the specified city')),
        );
      } else {
        placeList = [];

        directionList = [];
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

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Direction fetched successfully')),
        // );
      } else if (response.statusCode == 404) {
        directionList = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('No Camera Location found for the specified Place')),
        );
      } else {
        directionList = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch Camera Location')),
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

  Future<void> _addnaka() async {
    if (selectedPlace == null || _nakacontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Select Place  and Enter Naka Name')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the API method to save the city
      bool success = await api.addNaka(
          _nakacontroller.text, selectedPlace!, selectedCameras);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Naka added successfully')),
        );
        _nakacontroller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Naka')),
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
                          "AddNaka",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Set up and manage Naka ",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nakacontroller,
              decoration: InputDecoration(
                labelText: 'Naka Name',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                hintText: 'Enter the name of the Naka',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(Icons.camera, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.teal,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.teal, // Unfocused border color
                    width: 1.5,
                  ),
                ),
                // The border when the TextFormField is focused
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.teal, // Focused border color
                    width: 2.0, // Thicker border when focused
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Dropdown for City
            const Text('Select City:'),
            const SizedBox(height: 10),
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: DropdownButton<String>(
                value: selectedCity,
                hint: Text(
                  cityList.isEmpty ? "No City Available" : "Select City ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
                onChanged: (newValue) {
                  setState(() {
                    selectedCity = newValue;
                    if (selectedCity != null) {
                      _getplaces(selectedCity!);
                    }
                  });
                },
                isExpanded: true,
                underline: Container(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
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
            const SizedBox(height: 10),
            // Dropdown for Place
            const Text('Select Place:'),
            const SizedBox(height: 10),
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: DropdownButton<String>(
                value: selectedPlace,
                hint: Text(
                    placeList.isEmpty ? "No Place Available" : "Select Place",
                    style: TextStyle(color: Colors.black)),
                onChanged: (newValue) {
                  setState(() {
                    selectedPlace = newValue;
                    if (selectedPlace != null) {
                      _getdirection(selectedPlace!);
                    }
                  });
                },
                isExpanded: true,
                underline: Container(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
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
            const SizedBox(height: 10),

            const Text(
              "Camera Locations:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            directionList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: directionList.length,
                    itemBuilder: (context, index) {
                      Direction direction = directionList[index];
                      bool isSelected = selectedDirections.contains(direction);

                      return Card(
                        color: isSelected ? Colors.teal.shade100 : Colors.white,
                        child: ListTile(
                          title: Text(
                            direction.name,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  isSelected
                                      ? Icons.link_off
                                      : Icons.open_in_new,
                                  color: isSelected ? Colors.red : Colors.blue,
                                ),
                                onPressed: () async {
                                  selectedCameras = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LinkCamera(
                                        direction: direction,
                                        selectedCameras: selectedCameras,
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    selectedDirections.add(direction);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: Text('No Camera Available')),
            const SizedBox(height: 20),
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(50),
                  elevation: 5,
                ),
                onPressed: () {
                  _addnaka();

                  setState(() {
                    selectedDirections = [];
                  });
                },
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between buttons
          ],
        ),
      ),
    );
  }
}
