import 'package:flutter/material.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';
import 'package:intl/intl.dart';

class NewShift extends StatefulWidget {
  const NewShift({super.key});

  @override
  State<NewShift> createState() => _NewShiftState();
}

class _NewShiftState extends State<NewShift> {
  API api = API();
  bool _isLoading = false;
  String selectedValue = 'morning';
  String? selectedstartShift;
  String? selectedendShift;

  Future<void> _addshifts() async {
    if (selectedValue.isEmpty ||
        selectedstartShift == null ||
        selectedendShift == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter Shift type , Start Time and End Time')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the API method to save the city
      bool success = await api.addshift(
          selectedValue, selectedstartShift!, selectedendShift!);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shifts added successfully')),
        );
        selectedValue;
        selectedstartShift = null;
        selectedendShift = null;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Shifts')),
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.99,
                height: 57,
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
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Distributes evenly
                  children: [
                    Radio<String>(
                      value: 'morning',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                    ),
                    Text('Morning'),
                    Radio<String>(
                      value: 'evening',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                    ),
                    Text('Evening'),
                    Radio<String>(
                      value: 'night',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                    ),
                    Text('Night'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              child: InkWell(
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    final now = DateTime.now();
                    final dt = DateTime(now.year, now.month, now.day,
                        pickedTime.hour, pickedTime.minute);
                    setState(() {
                      selectedstartShift = DateFormat('HH:mm:ss').format(dt);
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedstartShift ?? 'Select Start Time',
                      style: TextStyle(
                        color: selectedstartShift == null
                            ? Colors.grey
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.access_time, color: Colors.teal),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              child: InkWell(
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    final now = DateTime.now();
                    final dt = DateTime(now.year, now.month, now.day,
                        pickedTime.hour, pickedTime.minute);
                    setState(() {
                      selectedendShift = DateFormat('HH:mm:ss').format(dt);
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedendShift ?? 'Select End Time',
                      style: TextStyle(
                        color: selectedendShift == null
                            ? Colors.grey
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.access_time, color: Colors.teal),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(50),
                  elevation: 5,
                ),
                onPressed: () {
                  setState(() {
                    _addshifts();
                  });
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
