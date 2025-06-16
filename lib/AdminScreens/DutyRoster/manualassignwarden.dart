import 'package:flutter/material.dart';

class manualAssignment extends StatefulWidget {
  const manualAssignment({super.key});

  @override
  _manualAssignmentState createState() => _manualAssignmentState();
}

class _manualAssignmentState extends State<manualAssignment> {
  String? selectedCity;
  String? selectedPlace;
  String? selectedWarden;
  String? selectedNaka;
  String? selectedShift;

  List<String> cities = ['Islamabad', 'Rawalpindi', 'Lahore'];
  Map<String, List<String>> placesByCity = {
    'Islamabad': ['I-8 Markaz', 'Blue Area', 'G-9'],
    'Rawalpindi': ['Saddar', 'Shamshabad', 'Committee Chowk'],
    'Lahore': ['Gulberg', 'Model Town', 'DHA']
  };

  List<String> wardens = ['Warden A', 'Warden B', 'Warden C'];
  List<String> nakas = ['Naka 1', 'Naka 2', 'Naka 3'];
  List<String> shifts = ['08:00:00', '16:00:00', '00:00:00'];

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
                          "Manual Assign",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Assign Officer to Naka",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDropdown(
              label: 'Select City',
              value: selectedCity,
              items: cities,
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                  selectedPlace = null; // Reset place when city changes
                });
              },
            ),
            SizedBox(height: 10),
            buildDropdown(
              label: 'Select Place',
              value: selectedPlace,
              items: selectedCity != null ? placesByCity[selectedCity]! : [],
              onChanged: (value) => setState(() => selectedPlace = value),
              enabled: selectedCity != null,
            ),
            SizedBox(height: 10),
            buildDropdown(
              label: 'Select Warden',
              value: selectedWarden,
              items: wardens,
              onChanged: (value) => setState(() => selectedWarden = value),
            ),
            SizedBox(height: 10),
            buildDropdown(
              label: 'Select Naka',
              value: selectedNaka,
              items: nakas,
              onChanged: (value) => setState(() => selectedNaka = value),
            ),
            SizedBox(height: 10),
            buildDropdown(
              label: 'Select Shift',
              value: selectedShift,
              items: shifts,
              onChanged: (value) => setState(() => selectedShift = value),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print('City: $selectedCity');
                  print('Place: $selectedPlace');
                  print('Warden: $selectedWarden');
                  print('Naka: $selectedNaka');
                  print('Shift: $selectedShift');
                },
                child: Text('Submit'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.teal, // Border color
              width: 1.5, // Border width
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.teal, // Border color when not focused
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.teal.shade700, // Darker shade when focused
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10, // Reduced height padding
          ), // Keeps background white
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            hint: Text(label),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: enabled ? onChanged : null,
          ),
        ),
      ),
    );
  }
}
