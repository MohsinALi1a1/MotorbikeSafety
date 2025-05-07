import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motorbikesafety/Model/City.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class Warden extends StatefulWidget {
  const Warden({super.key});

  @override
  State<Warden> createState() => _WardenState();
}

class _WardenState extends State<Warden> {
  API api = API();
  bool _isLoading = false;
  List<City> cityList = [];
  final TextEditingController _namecontroller = TextEditingController();

  final TextEditingController _cniccontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _mobilenumbercontroller = TextEditingController();

  String? selectedCity;

  Future<void> _addwarden() async {
    if (selectedCity == null ||
        _namecontroller.text.isEmpty ||
        _cniccontroller.text.isEmpty ||
        _addresscontroller.text.isEmpty ||
        _emailcontroller.text.isEmpty ||
        _mobilenumbercontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Fill All Require Fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the API method to save the city
      bool success = await api.addwarden(
          _namecontroller.text,
          _addresscontroller.text,
          _cniccontroller.text,
          _emailcontroller.text,
          _mobilenumbercontroller.text,
          selectedCity!);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Warden added successfully')),
        );
        _namecontroller.clear();
        _addresscontroller.clear();
        _cniccontroller.clear();
        _emailcontroller.clear();
        _mobilenumbercontroller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Warden')),
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cities fetched successfully')),
        );
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
                          "Warden",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25, // Larger title for prominence
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5, // Elegance with letter spacing
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Set up and manage Warden ",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: _namecontroller,
              decoration: InputDecoration(
                labelText: 'Enter Name',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                hintText: 'Enter the name of the Warden',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(Icons.person, color: Colors.teal),
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
            TextField(
              controller: _emailcontroller,
              decoration: InputDecoration(
                labelText: 'Enter Email',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                hintText: 'Enter warden email',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(Icons.email, color: Colors.teal),
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
            TextField(
              controller: _mobilenumbercontroller,
              decoration: InputDecoration(
                labelText: 'Enter Mobile Number',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                hintText: 'Enter the Number of warden',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(Icons.phone, color: Colors.teal),
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
            TextField(
              controller: _cniccontroller,
              decoration: InputDecoration(
                labelText: 'Enter CNIC',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                hintText: 'Enter the CNIC number',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(Icons.perm_identity, color: Colors.teal),
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

            TextField(
              controller: _addresscontroller,
              decoration: InputDecoration(
                labelText: 'Enter Address',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                hintText: 'Enter the Address ',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(Icons.location_city, color: Colors.teal),
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
            const Text('Select City:'),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
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
                  _addwarden();
                  print('Save button pressed');
                },
                child: const Text(
                  'Save',
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
