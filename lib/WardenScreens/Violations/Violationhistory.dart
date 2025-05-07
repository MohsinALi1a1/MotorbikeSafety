import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motorbikesafety/Model/Vehicle.dart';
import 'package:motorbikesafety/Model/ViolationHistory.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';
import 'package:motorbikesafety/WardenScreens/Challan/CreateChallanScreen.dart';
import 'package:motorbikesafety/WardenScreens/Violations/ViolationDetailsScreen.dart';

class ViolationHistoryScreen extends StatefulWidget {
  final int naka_id;
  final int warden_id;

  const ViolationHistoryScreen(
      {Key? key, required this.naka_id, required this.warden_id})
      : super(key: key);

  @override
  State<ViolationHistoryScreen> createState() => _ViolationHistoryScreenState();
}

class _ViolationHistoryScreenState extends State<ViolationHistoryScreen> {
  API api = API();
  bool _isLoading = false;
  List<ViolationHistory> violationlist = [];

  Future<void> _getviolationhistoryfornakabyid(int id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await api.getviolationhistorybynakaid(id);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> violationmap = data['violation_histories'] != null
            ? data['violation_histories']
            : [];
        violationlist =
            violationmap.map((e) => ViolationHistory.fromMap(e)).toList();
        if (violationlist.isEmpty) {
        } else {}
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

    _getviolationhistoryfornakabyid(widget.naka_id);
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
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Violation Type or Location",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12),
                  ),
                  child: Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Filters
            Text("Filter by :", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    hint: Text("Violation Type"),
                    items: ["Red Light", "Speeding", "Helmet"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    hint: Text("By Status"),
                    items: ["All", "Pending", "Action", "Dispute"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            Text("Results :", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            violationlist.isEmpty
                ? Center(
                    child: Text("No Violation Record"),
                  )
                :
                // Violation Cards
                Expanded(
                    child: ListView.builder(
                      itemCount: violationlist.length,
                      itemBuilder: (context, index) {
                        final violation = violationlist[index];
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

class ViolationCard extends StatelessWidget {
  final String vehicleNumber, status, date, time, type, location;
  final ViolationHistory violationhisrty;
  final int w_id;
  ViolationCard(
      {required this.violationhisrty,
      required this.vehicleNumber,
      required this.status,
      required this.date,
      required this.time,
      required this.type,
      required this.location,
      required this.w_id});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: status == "Pending" ? Colors.red[200] : Colors.grey[200],
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
                      vehicleNumber,
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
                      "Status: $status",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: status == "Pending" ? Colors.red : Colors.green,
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
                  "$date $time",
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
                    type,
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
                    location,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViolationDetailsScreen(
                            violationhistory: violationhisrty,
                            wardenid: w_id,
                          ),
                        ),
                      );
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
                if (status == "Pending")
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateChallanScreen(
                              wardenId: w_id,
                              violationhistory: violationhisrty,
                            ),
                          ),
                        );
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
