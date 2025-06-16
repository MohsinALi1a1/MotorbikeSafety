import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:motorbikesafety/AdminScreens/ManageNaka/LinkNaka.dart';

import 'package:motorbikesafety/Model/Camera.dart';
import 'package:motorbikesafety/Model/CameraNaka.dart';
import 'package:motorbikesafety/Model/LinkNaka.dart';

import 'package:motorbikesafety/Model/Naka.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class LinkNakaHome extends StatefulWidget {
  final Naka naka;

  const LinkNakaHome({super.key, required this.naka});

  @override
  _LinkNakaHomeState createState() => _LinkNakaHomeState();
}

class _LinkNakaHomeState extends State<LinkNakaHome> {
  API api = API();
  bool _isLoading = false;
  List<Linknaka> nakaList = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _getnaka(widget.naka.id!);
  }

  Future<void> _deleteLinknaka(int nakaid, int linknaka) async {
    if (linknaka == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Pass a Link Naka id and Link Naka')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await api.deleteLinknaka(nakaid, linknaka);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('link Naka deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Delete Link Naka')),
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

  Future<void> _getnaka(int nakaid) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await api.getAllNakaofNaka(nakaid);

      if (response.statusCode == 200) {
        var decoded = json.decode(response.body); // decode full JSON
        List<dynamic> nakamap = decoded is List
            ? decoded
            : decoded['data'] ?? []; // handle both cases

        setState(() {
          nakaList = nakamap.map((e) => Linknaka.fromMap(e)).toList();
        });
      } else if (response.statusCode == 404) {
        setState(() {
          nakaList = [];
        });
        _showSnackbar('No Link Naka found for Naka ID $nakaid');
      } else {
        setState(() {
          nakaList = [];
        });
        _showSnackbar('Failed to fetch Link Naka');
      }
    } catch (e) {
      _showSnackbar('Error: $e');
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LinkNaka(
                      naka: widget.naka,
                      selectednaka: nakaList,
                    )),
          );
          setState(() {
            _getnaka(widget.naka.id!);
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Chowki Name at the Top
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
            _isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: nakaList.isNotEmpty
                        ? ListView.builder(
                            itemCount: nakaList.length,
                            itemBuilder: (context, index) {
                              Linknaka naka = nakaList[index];

                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.white,
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
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
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
                                                  "Delete Naka",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: const Text(
                                                  "Are you sure you want to delete this Naka?",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context); // Cancel
                                                    },
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      // TODO: Replace with your actual delete function
                                                      await _deleteLinknaka(
                                                        widget.naka.id!,
                                                        naka.id!,
                                                      );
                                                      setState(() {
                                                        _getnaka(
                                                            widget.naka.id!);
                                                      });
                                                      Navigator.pop(
                                                          context); // Close dialog
                                                    },
                                                    child: const Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          fontSize: 16,
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
                        : Center(child: Text('No Link Naka Found')),
                  ),
          ],
        ),
      ),
    );
  }
}
