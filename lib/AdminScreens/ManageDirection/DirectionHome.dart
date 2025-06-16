import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motorbikesafety/Model/City.dart';
import 'package:motorbikesafety/Model/Direction.dart';
import 'package:motorbikesafety/Model/Place.dart';
import 'package:motorbikesafety/AdminScreens/ManageDirection/Adddirection.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class DirectionDetailScreen extends StatefulWidget {
  const DirectionDetailScreen({super.key});

  @override
  State<DirectionDetailScreen> createState() => _DirectionDetailScreenState();
}

class _DirectionDetailScreenState extends State<DirectionDetailScreen> {
  API api = API();
  bool _isLoading = false;
  List<Place> placeList = [];
  List<City> cityList = [];
  List<Direction> directionList = [];
  String? selectedCity;
  String? selectedPlace;

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No places found for the specified city')),
        );
      } else {
        placeList = [];
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
          SnackBar(content: Text('No Direction found for the specified Place')),
        );
      } else {
        directionList = [];
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

  Future<void> _deletedirection(String directionname, String placename) async {
    if (directionname.isEmpty || placename.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Pass a Direction name and placename')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await api.deletedirection(directionname, placename);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Direction deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Delete Direction')),
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
                          "Direction",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Set up and manage directions ",
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
            MaterialPageRoute(builder: (context) => AddDirection()),
          );
          setState(() {
            _getdirection(selectedPlace!);
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
                      "Select City",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
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
                SizedBox(
                  height: 10,
                ),
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
                        placeList.isEmpty ? "No Place Found" : "Select Place",
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

                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
                SizedBox(
                  height: 10,
                ),
                // Display the list of places
                Expanded(
                    child: directionList.isNotEmpty
                        ? ListView.builder(
                            itemCount: directionList.length,
                            itemBuilder: (context, index) {
                              Direction direction = directionList[index];
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
                                              'Direction ID: ${direction.id}',
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
                                              'Direction Name: ${direction.name}',
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
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  "Delete Direction",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: const Text(
                                                  "Are you sure you want to Delete this Direction?",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                actions: [
                                                  // Cancel Button
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
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
                                                      await _deletedirection(
                                                          direction.name,
                                                          selectedPlace!);
                                                      setState(() {
                                                        _getdirection(
                                                            selectedPlace!);
                                                      });

                                                      Navigator.pop(context);
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
                            child: Text('No Direction Found'),
                          )),
              ],
            ),
          ),
          // Positioned(
          //   bottom: 30,
          //   left: 16,
          //   right: 16,
          //   child: SizedBox(
          //     width: double.infinity,
          //     child: ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.teal,
          //         minimumSize: const Size.fromHeight(50),
          //         elevation: 5,
          //       ),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       },
          //       child: const Text(
          //         'Back',
          //         style: TextStyle(fontSize: 16, color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
