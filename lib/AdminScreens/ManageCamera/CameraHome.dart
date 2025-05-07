import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motorbikesafety/AdminScreens/ManageCamera/Addcamera.dart';

import 'package:motorbikesafety/Model/Camera.dart';
import 'package:motorbikesafety/Model/City.dart';
import 'package:motorbikesafety/Model/Direction.dart';
import 'package:motorbikesafety/Model/Place.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class Managecamera extends StatefulWidget {
  const Managecamera({super.key});

  @override
  State<Managecamera> createState() => _ManagecameraState();
}

class _ManagecameraState extends State<Managecamera> {
  API api = API();
  bool _isLoading = false;
  List<Place> placeList = [];
  List<City> cityList = [];
  List<Direction> directionList = [];
  List<Camera> cameraList = [];
  List<Camera> filteredcameraList = [];
  String? selectedCity;
  String? selectedPlace;
  String? selectedDirection;
  String? selectedtype;
  String selectedValue = 'All';

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
          filteredcameraList = [];
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Place fetched successfully')),
        // );
      } else if (response.statusCode == 404) {
        placeList = [];
        directionList = [];
        cameraList = [];
        filteredcameraList = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No places found for the specified city')),
        );
      } else {
        placeList = [];
        directionList = [];
        cameraList = [];
        filteredcameraList = [];
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
          filteredcameraList = [];
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Direction fetched successfully')),
        // );
      } else if (response.statusCode == 404) {
        directionList = [];
        cameraList = [];
        filteredcameraList = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Direction found for the specified Place')),
        );
      } else {
        directionList = [];
        cameraList = [];
        filteredcameraList = [];
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

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Camera fetched successfully')),
        // );
      } else if (response.statusCode == 404) {
        cameraList = [];
        filteredcameraList = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'No Camera found for the ${placename} at point ${directionname} ')),
        );
      } else {
        cameraList = [];
        filteredcameraList = [];
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
      filteredcameraList = cameraList;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deletecamera(
      String cameraname, String directionname, String type) async {
    if (cameraname.isEmpty || directionname.isEmpty || type.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please Pass a Camera name and Directionname and Type')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await api.deleteCamera(cameraname, directionname, type);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Delete Camera')),
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
                          "Camera",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Set up and manage Camera ",
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCamera()),
          );
          setState(() {
            _getcamera(selectedPlace!, selectedDirection!);
          });
        },
        child: const Text(
          '+',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center align the row
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Select City"),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.teal, width: 1.5),
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
                                setState(() {
                                  selectedCity = newValue;
                                });
                                if (selectedCity != null) {
                                  _getplaces(selectedCity!);
                                }
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
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Select Place"),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.teal, width: 1.5),
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
                                  style: TextStyle(color: Colors.black)),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedPlace = newValue;
                                });
                                if (selectedPlace != null) {
                                  _getdirection(selectedPlace!);
                                }
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

                SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Select Direction"),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.teal, width: 1.5),
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
                              value: selectedDirection,
                              hint: Text(
                                  directionList.isEmpty
                                      ? "No Direction Found"
                                      : "Select Direction",
                                  style: TextStyle(color: Colors.black)),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedDirection = newValue;
                                });
                                if (selectedDirection != null) {
                                  _getcamera(
                                      selectedPlace!, selectedDirection!);
                                }
                              },
                              isExpanded: true,
                              underline: Container(),
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.teal),
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
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Filter"),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 57,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.teal, width: 1.5),
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
                            child: SingleChildScrollView(
                              // Prevent overflow
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly, // Distributes evenly
                                children: [
                                  Radio<String>(
                                    value: 'All',
                                    groupValue: selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value!;
                                        filteredcameraList = cameraList;
                                      });
                                    },
                                  ),
                                  Text('All'),
                                  Radio<String>(
                                    value: 'front',
                                    groupValue: selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value!;
                                        filteredcameraList = cameraList
                                            .where(
                                                (city) => city.Type == "front")
                                            .toList();
                                      });
                                    },
                                  ),
                                  Text('front'),
                                  Radio<String>(
                                    value: 'side',
                                    groupValue: selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value!;
                                        filteredcameraList = cameraList
                                            .where(
                                                (city) => city.Type == "side")
                                            .toList();
                                      });
                                    },
                                  ),
                                  Text('side'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // Display the list of places

                _isLoading
                    ? Expanded(
                        child: Center(child: CircularProgressIndicator()))
                    : Expanded(
                        child: filteredcameraList.length > 0
                            ? ListView.builder(
                                itemCount: filteredcameraList.length,
                                itemBuilder: (context, index) {
                                  Camera camera = filteredcameraList[index];
                                  return Card(
                                    margin: const EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // Rounded corners for card
                                    ),
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
                                                  'Camera ID: ${camera.id}',
                                                  style: TextStyle(
                                                    fontSize:
                                                        15, // Reduced font size
                                                    fontWeight: FontWeight
                                                        .bold, // Slightly lighter for style
                                                    color: Colors.teal
                                                        .shade700, // More vibrant color for text
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        4), // Reduced space between text lines
                                                Text(
                                                  'Camera Name: ${camera.name}',
                                                  style: TextStyle(
                                                    fontSize:
                                                        15, // Adjusted font size for readability
                                                    fontWeight: FontWeight
                                                        .w600, // Slightly lighter than bold
                                                    color: Colors
                                                        .black87, // Darker shade for better contrast
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.teal),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      "Delete Camera",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    content: const Text(
                                                      "Are you sure you want to Delete this Camera?",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    actions: [
                                                      // Cancel Button
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                      // Delete Button
                                                      TextButton(
                                                        onPressed: () async {
                                                          await _deletecamera(
                                                              camera.name,
                                                              camera.direction,
                                                              camera.Type!);
                                                          setState(() {
                                                            _getcamera(
                                                                selectedPlace!,
                                                                selectedDirection!);
                                                          });

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text('No Camera Found'),
                              )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
