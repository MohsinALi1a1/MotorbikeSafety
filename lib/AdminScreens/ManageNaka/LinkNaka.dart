import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:motorbikesafety/AdminScreens/ManageNaka/LinkCameraHome.dart';
import 'package:motorbikesafety/AdminScreens/ManageNaka/LinkNakaHome.dart';

import 'package:motorbikesafety/Model/Camera.dart';
import 'package:motorbikesafety/Model/City.dart';
import 'package:motorbikesafety/Model/Direction.dart';
import 'package:motorbikesafety/Model/LinkNaka.dart';
import 'package:motorbikesafety/Model/Naka.dart';
import 'package:motorbikesafety/Model/Place.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class LinkNaka extends StatefulWidget {
  final Naka naka;
  final List<Linknaka> selectednaka;

  const LinkNaka({super.key, required this.naka, required this.selectednaka});

  @override
  _LinkNakaState createState() => _LinkNakaState();
}

class _LinkNakaState extends State<LinkNaka> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  API api = API();
  bool _isLoading = false;
  List<Place> placeList = [];
  List<City> cityList = [];
  List<Naka> nakaList = [];
  List<Naka> unselectednaka = [];
  String? selectedCity;
  String? selectedPlace;
  List<int> selectedNakaid = [];

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
          _getNaka(selectedPlace!);
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

  Future<void> _getNaka(String name) async {
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
      var response = await api.getAllNaka(name);

      if (response.statusCode == 200) {
        List<dynamic> nakamap = json.decode(response.body);
        nakaList = nakamap.map((e) => Naka.fromMap(e)).toList();
        unselectednaka = nakaList.where((naka) {
          return !widget.selectednaka.any((selected) => selected.id == naka.id);
        }).toList();

        unselectednaka = unselectednaka.where((naka) {
          return naka.id != widget.naka.id;
        }).toList();

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Naka fetched successfully')),
        // );
      } else if (response.statusCode == 404) {
        nakaList = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Naka found for the specified Place')),
        );
      } else {
        nakaList = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch Naka')),
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

  Future<void> _deletenaka(String nakaname, String placename) async {
    if (nakaname.isEmpty || placename.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Pass a Naka name and placename')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await api.deletenaka(nakaname, placename);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Naka deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Delete Naka')),
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

  Future<bool> _Linknakawithnaka() async {
    if (selectedNakaid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Select Naka to Link with This Naka')),
      );
      return false;
    }

    try {
      List<int> zeroDistances = List.filled(selectedNakaid.length, 0);

      // Get the full HTTP response from the API
      var response = await api.add_NakawithNaka(
          widget.naka.id!, selectedNakaid, zeroDistances);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Naka Link successfully')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Link Naka: ${response.body}')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    } finally {
      setState(() {});
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
                          Navigator.pop(context, widget.selectednaka);
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Link Naka",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Link Naka with Naka",
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
      ), // Display Chowki Name at the Top

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
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
                        _getNaka(selectedPlace!);
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
                    child: unselectednaka.isNotEmpty
                        ? ListView.builder(
                            itemCount: unselectednaka.length,
                            itemBuilder: (context, index) {
                              Naka naka = unselectednaka[index];
                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                                              'Naka ID: ${naka.id}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.teal.shade700,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Naka Name: ${naka.name}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Checkbox(
                                        value: selectedNakaid.any(
                                            (selected) => selected == naka.id),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedNakaid.add(naka.id!);
                                            } else {
                                              selectedNakaid.removeWhere(
                                                  (selected) =>
                                                      selected == naka.id);
                                            }
                                          });
                                        },
                                        activeColor: Colors.teal,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text('No Naka Found'),
                          )),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size.fromHeight(50),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // 👈 Slight curve
                      ),
                    ),
                    onPressed: () async {
                      bool success = await _Linknakawithnaka();
                      if (success) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
