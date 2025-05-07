import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motorbikesafety/Model/shifts.dart';
import 'package:motorbikesafety/AdminScreens/MangeShifts/AddShifts.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class Shifts extends StatefulWidget {
  const Shifts({super.key});

  @override
  State<Shifts> createState() => _ShiftsState();
}

class _ShiftsState extends State<Shifts> {
  API api = API();
  bool _isLoading = false;
  List<Shift> shiftlist = [];

  // Fetching the places based on the selected city
  Future<void> _getshifts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await api.getAllShifts();

      if (response.statusCode == 200) {
        List<dynamic> shiftmap = json.decode(response.body);
        shiftlist = shiftmap.map((e) => Shift.fromMap(e)).toList();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shifts fetched successfully')),
        );
      } else if (response.statusCode == 404) {
        shiftlist = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Shifts found ')),
        );
      } else {
        shiftlist = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch shifts')),
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

  Future<void> _deleteshifts(
      String shifttype, String starttime, String endtime) async {
    if (shifttype.isEmpty || starttime.isEmpty || endtime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please Pass a Shift Type , Start Time and End Time')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the API method to delete the city
      bool success = await api.deleteshift(shifttype, starttime, endtime);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shift deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Delete Shift')),
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
    _getshifts(); // Fetch the cities when the screen loads
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
                          "Shift",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25, // Larger title for prominence
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5, // Elegance with letter spacing
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Set up and manage Shift ",
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
            MaterialPageRoute(builder: (context) => const NewShift()),
          );
          setState(() {
            _getshifts();
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
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          _isLoading
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: shiftlist.length > 0
                      ? ListView.builder(
                          itemCount: shiftlist.length,
                          itemBuilder: (context, index) {
                            Shift shift = shiftlist[index];
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
                                          Row(
                                            children: [
                                              Text(
                                                'ID: ${shift.id}',
                                                style: TextStyle(
                                                  fontSize:
                                                      15, // Reduced font size
                                                  fontWeight: FontWeight
                                                      .bold, // Slightly lighter for style
                                                  color: Colors.teal
                                                      .shade700, // More vibrant color for text
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Type: ${shift.shiftType}',
                                                style: TextStyle(
                                                  fontSize:
                                                      15, // Reduced font size
                                                  fontWeight: FontWeight
                                                      .bold, // Slightly lighter for style
                                                  color: Colors.teal
                                                      .shade700, // Darker shade for better contrast
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height:
                                                  4), // Reduced space between text lines
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Start time: ${shift.startTime}',
                                                style: TextStyle(
                                                  fontSize:
                                                      12, // Adjusted font size for readability
                                                  fontWeight: FontWeight
                                                      .w600, // Slightly lighter than bold
                                                  color: const Color.fromARGB(
                                                      221,
                                                      82,
                                                      82,
                                                      82), // Darker shade for better contrast
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'End time: ${shift.endTime}',
                                                style: TextStyle(
                                                  fontSize:
                                                      12, // Adjusted font size for readability
                                                  fontWeight: FontWeight
                                                      .w600, // Slightly lighter than bold
                                                  color: const Color.fromARGB(
                                                      221,
                                                      82,
                                                      82,
                                                      82), // Darker shade for better contrast
                                                ),
                                              ),
                                            ],
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
                                                "Delete Shift",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: const Text(
                                                "Are you sure you want to Delete this Shift?",
                                                style: TextStyle(fontSize: 16),
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
                                                    await _deleteshifts(
                                                        shift.shiftType,
                                                        shift.startTime,
                                                        shift.endTime);
                                                    setState(() {
                                                      _getshifts();
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
                          child: Text('No Shift Found'),
                        )),
        ],
      ),
    );
  }
}
