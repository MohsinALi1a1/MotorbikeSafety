import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motorbikesafety/Model/Vehicle.dart';
import 'package:motorbikesafety/Model/Violation.dart';
import 'package:motorbikesafety/Model/ViolationHistory.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';
import 'package:motorbikesafety/WardenScreens/Challan/CreateChallanScreen.dart';
import 'package:motorbikesafety/WardenScreens/Violations/ViolationDetailsScreen.dart';

class ViolationHistoryScreen extends StatefulWidget {
  final int naka_id;
  final int warden_id;

  const ViolationHistoryScreen(
      {super.key, required this.naka_id, required this.warden_id});

  @override
  State<ViolationHistoryScreen> createState() => _ViolationHistoryScreenState();
}

class _ViolationHistoryScreenState extends State<ViolationHistoryScreen> {
  API api = API();
  bool _isLoading = false;
  List<ViolationHistory> violationhistorylist = [];
  List<ViolationHistory> filterviolationhistorylist = [];
  String? selectedType;
  String? selectedStatus;
  String? selectedorder;
  final TextEditingController _searchController = TextEditingController();

  List<String> statusList = ['Pending', 'Issue', 'Runner'];
  List<String> sortOptions = ['Asc', 'Desc'];
  List<Violation> violationrulelist = [];

  void _applyFilters() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filterviolationhistorylist = violationhistorylist.where((item) {
        final matchesSearch = item.licenseplate.toLowerCase().contains(query);
        // final matchesType = selectedType == null ||
        //     item.violationDetails.contains(selectedType!);

        final matchesStatus =
            selectedStatus == null || item.status == selectedStatus;
        return matchesSearch && matchesStatus;
      }).toList();

      // if (selectedorder == 'Asc') {
      //   filterviolationhistorylist.sort((a, b) =>
      //       DateTime.parse(a.violationDatetime)
      //           .compareTo(DateTime.parse(b.violationDatetime)));
      // } else if (selectedorder == 'Desc') {
      //   filterviolationhistorylist.sort((a, b) =>
      //       DateTime.parse(b.violationDatetime)
      //           .compareTo(DateTime.parse(a.violationDatetime)));
      // }
    });
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

  Future<void> getviolationhistoryfornakabyid(
      int chowkiid, int wardenid) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await api.getviolationhistorybynakaid(chowkiid, wardenid);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> violationmap = data['violation_histories'] ?? [];
        violationhistorylist =
            violationmap.map((e) => ViolationHistory.fromMap(e)).toList();
        filterviolationhistorylist = List.from(violationhistorylist);
        if (violationhistorylist.isEmpty) {
        } else {
          setState(() {});
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Violation History Fetched successfully')),
        );
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Violation History Found Found')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch Violation History')),
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
    _getViolationsRule();
    _searchController.addListener(_applyFilters);
    getviolationhistoryfornakabyid(widget.naka_id, widget.warden_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                          "Violation Record",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25, // Larger title for prominence
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5, // Elegance with letter spacing
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: "Search BY Bike Number",
                        labelStyle: GoogleFonts.poppins(fontSize: 14),

                        prefixIcon: Icon(Icons.search, color: Colors.teal),
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
                  ),
                ),
                SizedBox(width: 10),
                // Expanded(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(12),
                //       border: Border.all(color: Colors.teal, width: 1.5),
                //       color: Colors.white,
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.shade300,
                //           offset: Offset(0, 2),
                //           blurRadius: 4,
                //         ),
                //       ],
                //     ),
                //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                //     child: DropdownButton<String>(
                //       value: selectedorder,
                //       hint: Text(
                //         "Order By",
                //         style: TextStyle(
                //             color: Colors.black, fontWeight: FontWeight.w500),
                //       ),
                //       onChanged: (val) {
                //         setState(() => selectedorder = val);
                //         _applyFilters();
                //       },
                //       isExpanded: true,
                //       underline: Container(),
                //       icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
                //       items: sortOptions.map((s) {
                //         return DropdownMenuItem<String>(
                //           value: s,
                //           child: Text(
                //             s,
                //             style: TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //         );
                //       }).toList(),
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 10),

            // Filters
            Text("Filter by :", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                // Expanded(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(12),
                //       border: Border.all(color: Colors.teal, width: 1.5),
                //       color: Colors.white,
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.shade300,
                //           offset: Offset(0, 2),
                //           blurRadius: 4,
                //         ),
                //       ],
                //     ),
                //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                //     child: DropdownButton<String>(
                //       value: selectedType,
                //       hint: Text(
                //         "Select Violation Type",
                //         style: TextStyle(
                //             color: Colors.black, fontWeight: FontWeight.w500),
                //       ),
                //       onChanged: (val) {
                //         setState(() => selectedType = val);
                //         _applyFilters();
                //       },
                //       isExpanded: true,
                //       underline: Container(),
                //       icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
                //       items: violationrulelist.map((violation) {
                //         return DropdownMenuItem<String>(
                //           value: violation.name,
                //           child: Text(
                //             violation.name,
                //             style: TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //         );
                //       }).toList(),
                //     ),
                //   ),
                // ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
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
                      value: selectedStatus,
                      hint: Text(
                        "Select Status",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      onChanged: (val) {
                        setState(() => selectedStatus = val);
                        _applyFilters();
                      },
                      isExpanded: true,
                      underline: Container(),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
                      items: statusList.map((s) {
                        return DropdownMenuItem<String>(
                          value: s,
                          child: Text(
                            s,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            Text("Results :", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            violationhistorylist.isEmpty
                ? Center(
                    child: Text("No Violation Record"),
                  )
                :
                // Violation Cards
                Expanded(
                    child: ListView.builder(
                      itemCount: filterviolationhistorylist.length,
                      itemBuilder: (context, index) {
                        final violation = filterviolationhistorylist[index];
                        final isPending = violation.status;

                        // Track tap state
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Card(
                              color: violation.status == "Pending"
                                  ? Colors.red[300]
                                  : Colors.grey[300],
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: ViolationCard(
                                w_id: widget.warden_id,
                                violationhisrty: violation,
                                vehicleNumber: violation.licenseplate,
                                status: violation.status,
                                date: _extractDate(violation.violationDatetime),
                                time: _extractTime(violation.violationDatetime),
                                type: violation.violationDetails.isNotEmpty
                                    ? violation.violationDetails
                                        .map((v) => v.violationName)
                                        .join(', ')
                                    : "N/A",
                                location: violation.location,
                                naka_id: widget.naka_id,
                                refreshData: getviolationhistoryfornakabyid,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

String _extractDate(String datetime) {
  // From "Wed, 16 Apr 2025 11:22:09 GMT" ➜ "16 Apr 2025"
  List<String> parts = datetime.replaceAll("GMT", "").trim().split(' ');
  return "${parts[1]} ${parts[2]} ${parts[3]}";
}

String _extractTime(String datetime) {
  // From "Wed, 16 Apr 2025 11:22:09 GMT" ➜ "11:22:09"
  List<String> parts = datetime.replaceAll("GMT", "").trim().split(' ');
  return parts[4];
}

class ViolationCard extends StatefulWidget {
  String vehicleNumber, status, date, time, type, location;
  final ViolationHistory violationhisrty;
  final int w_id;
  final int naka_id;
  final Function refreshData;
  ViolationCard(
      {super.key,
      required this.violationhisrty,
      required this.vehicleNumber,
      required this.status,
      required this.date,
      required this.time,
      required this.type,
      required this.location,
      required this.w_id,
      required this.naka_id,
      required this.refreshData});

  @override
  State<ViolationCard> createState() => _ViolationCardState();
}

class _ViolationCardState extends State<ViolationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.status == "Pending"
          ? Colors.red[200]
          : widget.status == "Runner"
              ? Colors.red[300]
              : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: Colors.teal.withOpacity(0.3),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_bike, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text(
                      "Vehicle: ",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      widget.vehicleNumber,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 6),
                    Text(
                      "Status: ${widget.status}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.status == "Pending"
                            ? Colors.red
                            : Colors.green,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.date_range, color: Colors.blueGrey),
                SizedBox(width: 8),
                Text(
                  "Violation Date: ",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  "${widget.date} ${widget.time}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.report_gmailerrorred, color: Colors.redAccent),
                SizedBox(width: 8),
                Text(
                  "Type: ",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Expanded(
                  child: Text(
                    widget.type,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Location: ",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Expanded(
                  child: Text(
                    widget.location,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      String check = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViolationDetailsScreen(
                            violationhistory: widget.violationhisrty,
                            wardenid: widget.w_id,
                            nakaid: widget.naka_id,
                          ),
                        ),
                      );
                      await widget.refreshData(widget.naka_id, widget.w_id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: Colors.white, // Text/icon color
                    ),
                    icon: Icon(Icons.info_outline),
                    label: Text(
                      "View Details",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(width: 16), // spacing between buttons
                if (widget.status != "Issue")
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        bool? check = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateChallanScreen(
                              wardenId: widget.w_id,
                              violationhistory: widget.violationhisrty,
                            ),
                          ),
                        );
                        await widget.refreshData(widget.naka_id, widget.w_id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: Colors.white,
                      ),
                      icon: Icon(Icons.receipt),
                      label: Text(
                        "Create Challan",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
