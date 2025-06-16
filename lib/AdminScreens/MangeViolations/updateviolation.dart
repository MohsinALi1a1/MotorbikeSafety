import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:motorbikesafety/Model/Violation.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UpdateViolation extends StatefulWidget {
  Violation violationrule; // Accepting City object

  UpdateViolation({super.key, required this.violationrule});

  @override
  State<UpdateViolation> createState() => _updateviolationState();
}

class _updateviolationState extends State<UpdateViolation> {
  API api = API();
  bool _isLoading = false;
  bool _isChecked = false;
  DateTime? startselectedDateTime;
  DateTime? endselectedDateTime;

  late TextEditingController _namecontroller;
  late TextEditingController _limitcontroller;

  late TextEditingController _finecontroller;
  late TextEditingController _descriptioncontroller;
  bool isAllRidersRequired = false;
  @override
  void initState() {
    super.initState();
    isAllRidersRequired = widget.violationrule.name == "Helmet" &&
            widget.violationrule.limitValue != -1
        ? true
        : false;
    _isChecked = widget.violationrule.name == "OverRiding" &&
            widget.violationrule.limitValue != -1
        ? true
        : false;
    _namecontroller = TextEditingController(text: widget.violationrule.name);
    _limitcontroller = TextEditingController(
        text: widget.violationrule.limitValue != -1
            ? widget.violationrule.limitValue.toString()
            : "");
    startselectedDateTime = widget.violationrule.startDate;
    endselectedDateTime = widget.violationrule.endDate;
    _finecontroller = TextEditingController(
        text: widget.violationrule.fines[0].fine.toString());
    _descriptioncontroller =
        TextEditingController(text: widget.violationrule.description);
  }

  Future<void> _updateviolation() async {
    DateTime? startdate;
    DateTime? enddate;
    int? limit;

    if (_namecontroller.text.isEmpty ||
        _finecontroller.text.isEmpty ||
        _descriptioncontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (_isChecked && !isAllRidersRequired) {
      if (startselectedDateTime == null ||
          endselectedDateTime == null ||
          _limitcontroller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please select both Start and End date/time and enter Limit',
            ),
          ),
        );
        return;
      }
      startdate = startselectedDateTime;
      enddate = endselectedDateTime;
      limit = int.tryParse(_limitcontroller.text);
    } else if (!_isChecked && !isAllRidersRequired) {
      // Case when checkbox is not checked and all riders not required
      limit = -1;
      startdate = null;
      enddate = null;
    } else if (isAllRidersRequired && !_isChecked) {
      if (_limitcontroller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Limit value is required')),
        );
        return;
      }
      limit = int.tryParse(_limitcontroller.text);
      startdate = null;
      enddate = null;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await api.updateviolation(
          widget.violationrule.id,
          _namecontroller.text,
          _descriptioncontroller.text,
          limit,
          int.tryParse(_finecontroller.text),
          startdate,
          enddate);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Violation Rule updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update Violation')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<DateTime?> selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return null;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
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
                          "Update Rule",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25, // Larger title for prominence
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5, // Elegance with letter spacing
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Set up and manage Violations Rule ",
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
                labelText: 'Enter Violation Type',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                hintText: 'Enter the name of the Violation',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                prefixIcon:
                    Icon(Icons.type_specimen_outlined, color: Colors.teal),
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
              keyboardType: TextInputType.number, // Number keypad
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Restricts input to digits only
              controller: _finecontroller,
              decoration: InputDecoration(
                labelText: 'Enter Fine',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                hintText: 'Enter the Fine amount',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(FontAwesomeIcons.rupeeSign,
                    color: Colors.teal, size: 18),
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
            SizedBox(
              height: 150, // Adjust height as needed
              child: TextField(
                controller: _descriptioncontroller,
                keyboardType: TextInputType.multiline,
                maxLines: 5, // Allows unlimited lines
                decoration: InputDecoration(
                  labelText: 'Enter Description',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                  hintText: 'Enter Description of Violation',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                  prefixIcon: Icon(Icons.description, color: Colors.teal),
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
                      color: Colors.teal,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _namecontroller.text == "OverRiding"
                ? Column(children: [
                    SwitchListTile(
                      title: Text(
                        _isChecked
                            ? "Current sitting limit is 1. Turn OFF to allow 2 persons."
                            : "Current sitting limit is 2. Turn ON to allow 1 person only.",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      value: _isChecked,
                      onChanged: (bool value) {
                        setState(() {
                          _isChecked = value;
                          if (_isChecked) {
                            _limitcontroller.text = "1";
                          } else {
                            _limitcontroller.text = "-1";
                          }
                        });
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _isChecked
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  DateTime? picked =
                                      await selectDateTime(context);
                                  if (picked != null) {
                                    setState(() {
                                      startselectedDateTime = picked;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.calendar_today,
                                          color: Colors.teal, size: 28),
                                      SizedBox(height: 12),
                                      if (startselectedDateTime != null) ...[
                                        Text(
                                          "Selected Date & Time",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "${startselectedDateTime!.day}-${startselectedDateTime!.month}-${startselectedDateTime!.year}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "${startselectedDateTime!.hour.toString().padLeft(2, '0')}:${startselectedDateTime!.minute.toString().padLeft(2, '0')}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ] else ...[
                                        Text(
                                          "Tap to select Date & Time",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? picked =
                                      await selectDateTime(context);
                                  if (picked != null) {
                                    setState(() {
                                      endselectedDateTime = picked;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.calendar_today,
                                          color: Colors.teal, size: 28),
                                      SizedBox(height: 12),
                                      if (endselectedDateTime != null) ...[
                                        Text(
                                          "Selected Date & Time",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "${endselectedDateTime!.day}-${endselectedDateTime!.month}-${endselectedDateTime!.year}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "${endselectedDateTime!.hour.toString().padLeft(2, '0')}:${endselectedDateTime!.minute.toString().padLeft(2, '0')}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ] else ...[
                                        Text(
                                          "Tap to select Date & Time",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ])
                : SizedBox(),
            _namecontroller.text == "Helmet"
                ? SwitchListTile(
                    title: Text(
                      isAllRidersRequired
                          ? "All persons on bike must wear helmet. Turn off to make it only rider."
                          : "Only rider must wear helmet. Turn on to require all persons on bike to wear helmet.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    value: isAllRidersRequired,
                    onChanged: (bool value) {
                      setState(() {
                        isAllRidersRequired = value;
                        if (isAllRidersRequired) {
                          _limitcontroller.text = "1";
                        } else {
                          _limitcontroller.text = "-1";
                        }
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  )
                : SizedBox(),

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
                onPressed: () async {
                  await _updateviolation();
                  setState(() {
                    // _getViolationsRule();
                  });
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
