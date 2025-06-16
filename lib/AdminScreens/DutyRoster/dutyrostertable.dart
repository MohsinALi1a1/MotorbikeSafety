import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motorbikesafety/Model/DutyRoster.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class DutyRoasterTable extends StatefulWidget {
  const DutyRoasterTable({super.key});

  @override
  _DutyRoasterTableState createState() => _DutyRoasterTableState();
}

class _DutyRoasterTableState extends State<DutyRoasterTable> {
  API api = API();
  bool _isLoading = false;
  List<DutyRoster> dlist = [];

  Future<void> _getdutyroster() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await api.getAlldutyroster();

      if (response.statusCode == 200) {
        List<dynamic> placemap = json.decode(response.body);
        dlist = placemap.map((e) => DutyRoster.fromMap(e)).toList();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Duty Roster fetched successfully')),
        );
      } else if (response.statusCode == 404) {
        dlist = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Duty found')),
        );
      } else {
        dlist = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch dutyroster')),
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
    _getdutyroster(); // Fetch the duty roster when the screen loads
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
                          "Duty Roster",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Assigned Officers to Naka",
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
      body: Column(
        children: [
          // Header Section

          // Duty Roster Table Section
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator()) // Show loading spinner
              : Expanded(
                  child: dlist.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Warden Name')),
                                DataColumn(label: Text('Badge Number')),
                                DataColumn(label: Text('Naka')),
                                DataColumn(label: Text('Place')),
                                DataColumn(label: Text('Shift')),
                                DataColumn(label: Text('Time')),
                                DataColumn(label: Text('Date')),
                              ],
                              rows: dlist.map((duty) {
                                return DataRow(cells: [
                                  DataCell(Text(duty.wardenName)),
                                  DataCell(Text(duty.badgeNumber)),
                                  DataCell(Text(duty.chowkiName)),
                                  DataCell(Text(duty.chowkiPlace)),
                                  DataCell(Text(duty.shiftName)),
                                  DataCell(Text(duty.shiftTime)),
                                  DataCell(Text(duty.dutyDate)),
                                ]);
                              }).toList(),
                            ),
                          ),
                        )
                      : Center(child: Text("No Record Found")),
                ),

          // Back Button
        ],
      ),
    );
  }
}
