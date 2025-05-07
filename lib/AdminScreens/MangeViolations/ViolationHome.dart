import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motorbikesafety/AdminScreens/MangeViolations/addviolation.dart';
import 'package:motorbikesafety/AdminScreens/MangeViolations/updateviolation.dart';
import 'package:motorbikesafety/Model/City.dart';
import 'package:motorbikesafety/AdminScreens/ManageCity/AddCity.dart';
import 'package:motorbikesafety/Model/Violation.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class ViolationsDetailScreen extends StatefulWidget {
  const ViolationsDetailScreen({super.key});

  @override
  State<ViolationsDetailScreen> createState() => _ViolationsDetailScreenState();
}

class _ViolationsDetailScreenState extends State<ViolationsDetailScreen> {
  API api = API();
  bool _isLoading = false;
  List<Violation> violationrulelist = [];
  Future<void> _updateviolationstatus(int id, String Status) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the API method to update the violation
      bool success = await api.updateviolationstatus(id, Status);

      if (success) {
        _getViolationsRule();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Violation Status updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update Violation Status')),
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

  Future<void> _getViolationsRule() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await api.getAllViolation();

      if (response.statusCode == 200) {
        List<dynamic> violationrulemap = json.decode(response.body);
        violationrulelist =
            violationrulemap.map((e) => Violation.fromMap(e)).toList();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Violation Rule fetched successfully')),
        );
      } else if (response.statusCode == 404) {
        violationrulelist = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Violation Rule found ')),
        );
      } else {
        violationrulelist = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch Violation Rule')),
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
    _getViolationsRule(); // Fetch the cities when the screen loads
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
                            color: Colors.teal
                                .shade900, // Darker arrow color for contrast
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
                            "Violations Rule", // Corrected typo
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25, // Larger title for prominence
                              fontWeight: FontWeight.bold,
                              letterSpacing:
                                  1.5, // Elegance with letter spacing
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Set up and manage Violations ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[200],
                              fontSize: 15, // Subtitle with moderate size
                              fontWeight:
                                  FontWeight.w400, // Lighter font weight
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
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Addviolation();
            }));

            setState(() {
              _getViolationsRule();
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
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,  use to adjust floating button position
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: violationrulelist.isNotEmpty
                        ? ListView.builder(
                            itemCount: violationrulelist.length,
                            itemBuilder: (context, index) {
                              Violation violationrule =
                                  violationrulelist[index];
                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'ID: ${violationrule.id} - ${violationrule.name}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal.shade700,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  await Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return UpdateViolation(
                                                      violationrule:
                                                          violationrule,
                                                    );
                                                  }));
                                                  setState(() {
                                                    _getViolationsRule();
                                                  });
                                                },
                                                icon: Icon(Icons.edit,
                                                    color: Colors.red),
                                              ),
                                              // Add this variable at the top (inside your StatefulWidget)

                                              IconButton(
                                                icon: Icon(
                                                  violationrule.status ==
                                                          'Active'
                                                      ? Icons.toggle_on
                                                      : Icons.toggle_off,
                                                  color: violationrule.status ==
                                                          'Active'
                                                      ? Colors.green
                                                      : Colors.grey,
                                                  size: 36,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          violationrule
                                                                      .status ==
                                                                  'Active'
                                                              ? "Deactivate Rule"
                                                              : "Activate Rule",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        content: Text(
                                                          violationrule
                                                                      .status ==
                                                                  'Active'
                                                              ? "Are you sure you want to deactivate this rule?"
                                                              : "Do you want to activate this rule again?",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                Navigator.pop(
                                                                    context);
                                                                String status = violationrule
                                                                            .status ==
                                                                        "Active"
                                                                    ? "Deactive"
                                                                    : "Active";
                                                                _updateviolationstatus(
                                                                    violationrule
                                                                        .id,
                                                                    status);
                                                              });
                                                            },
                                                            child: Text(
                                                              violationrule
                                                                          .status ==
                                                                      'Active'
                                                                  ? "Deactivate"
                                                                  : "Activate",
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: violationrule
                                                                            .status ==
                                                                        'Active'
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .green,
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
                                        ],
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Description: ${violationrule.description}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      violationrule.limitValue != -1
                                          ? Text(
                                              'Limit: ${violationrule.limitValue}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[700],
                                              ),
                                            )
                                          : SizedBox(),
                                      // violationrule.limitValue != -1
                                      //     ? SizedBox(height: 10)
                                      //     : Text(''),
                                      Text(
                                        'Fines:',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal.shade700,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      violationrule.fines.isNotEmpty
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: violationrule.fines
                                                  .map((fine) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 4.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Fine: ${fine.fine} PKR',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .redAccent,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Date: ${fine.createdDate}',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ))
                                                  .toList(),
                                            )
                                          : Text(
                                              'No fines available',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text('No Violation Rule Found'),
                          ),
                  ),
          ],
        ));
  }
}
