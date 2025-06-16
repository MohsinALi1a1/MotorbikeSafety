import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motorbikesafety/Model/City.dart';
import 'package:motorbikesafety/Model/Place.dart';
import 'package:motorbikesafety/AdminScreens/Manageplace/Addplace.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({super.key});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  API api = API();
  bool _isLoading = false;
  List<Place> placeList = [];
  List<City> cityList = [];
  String? selectedCity; // To hold the selected city for the dropdown

  // Fetching the places based on the selected city
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

  Future<void> _deleteplace(String placename, String cityname) async {
    if (placename.isEmpty || cityname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Pass a city name and placename')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the API method to delete the city
      bool success = await api.deleteplace(placename, cityname);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Place deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Delete Place')),
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

  // Fetching cities from the API
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
    _getCities(); // Fetch the cities when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(120), // Increased height for more space
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5, // Shadow effect under the app bar
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal.shade800,
                  Colors.teal.shade500
                ], // Rich gradient for depth
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40), // Smooth rounded corners
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 20.0), // Padding to give space to the content
              child: Stack(
                children: [
                  // Back Arrow Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 15.0), // Margin to position it well
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.5), // Semi-transparent background
                        shape: BoxShape
                            .circle, // Circular background for the arrow
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45, // Soft shadow for depth
                            blurRadius: 6.0, // Shadow blur radius
                            offset: Offset(2, 2), // Shadow offset for realism
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors
                              .teal.shade900, // Darker arrow color for contrast
                          size: 30, // Larger size for the back arrow
                        ),
                        onPressed: () {
                          Navigator.pop(
                              context); // Go back to the previous screen
                        },
                      ),
                    ),
                  ),
                  // Title and Subtitle Text Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Place",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25, // Larger title for prominence
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5, // Elegance with letter spacing
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Set up and manage Place ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 15, // Subtitle with moderate size
                            fontWeight: FontWeight.w400, // Lighter font weight
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
            MaterialPageRoute(builder: (context) => AddPLace()),
          );
          setState(() {
            _getplaces(selectedCity!);
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Dropdown for selecting a city
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal, width: 1.5),
                color: Colors.white, // Set background color
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.grey.shade300, // Light shadow for subtle depth
                    offset: Offset(0, 2), // Position of shadow
                    blurRadius: 4, // Blur radius of the shadow
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 3), // Increased padding for a more spacious feel
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
                    _getplaces(selectedCity!); // Fetch places for selected city
                  }
                },
                isExpanded:
                    true, // Make the dropdown expand to fit the container width
                underline:
                    Container(), // Removes the underline that appears by default
                icon: Icon(Icons.arrow_drop_down,
                    color: Colors.teal), // Custom dropdown arrow
                items: cityList.map((city) {
                  return DropdownMenuItem<String>(
                    value: city.name,
                    child: Text(
                      city.name,
                      style: TextStyle(
                        color: Colors
                            .black, // More prominent color for dropdown items
                        fontWeight: FontWeight
                            .w600, // Make the text bold for better readability
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Show loading indicator while fetching data
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.teal, // Matching spinner color
                  strokeWidth:
                      3, // Custom stroke width for the loading indicator
                ),
              ),
            SizedBox(
              height: 10,
            ),

            // Display the list of places
            Expanded(
                child: placeList.isNotEmpty
                    ? ListView.builder(
                        itemCount: placeList.length,
                        itemBuilder: (context, index) {
                          Place place = placeList[index];
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Place ID: ${place.id}',
                                          style: TextStyle(
                                            fontSize: 15, // Reduced font size
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
                                          'Place Name: ${place.name}',
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
                                            title: const Text("Delete place"),
                                            content: const Text(
                                              "Are you sure you want to Delete Place ?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await _deleteplace(place.name,
                                                      selectedCity!);
                                                  setState(() {
                                                    _getplaces(selectedCity!);
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.red),
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
                        child: Text('No Place Found'),
                      )),
          ],
        ),
      ),
    );
  }
}
