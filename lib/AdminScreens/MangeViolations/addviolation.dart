import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Addviolation extends StatefulWidget {
  const Addviolation({super.key});

  @override
  State<Addviolation> createState() => _AddviolationState();
}

class _AddviolationState extends State<Addviolation> {
  API api = API();
  bool _isLoading = false;
  bool _isChecked = false;

  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _limitcontroller = TextEditingController();
  final TextEditingController _finecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();

  Future<void> _addviolation() async {
    int? limit;
    if (_namecontroller.text.isEmpty ||
        _finecontroller.text.isEmpty ||
        _descriptioncontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Fill All Require Fields')),
      );
      return;
    }
    if (_limitcontroller.text.isEmpty) {
      limit = -1;
    } else {
      limit = int.parse(_limitcontroller.text);
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the API method to save the city
      bool success = await api.addviolation(_namecontroller.text,
          _descriptioncontroller.text, limit!, int.parse(_finecontroller.text));
      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Violation added successfully')),
        );
        _namecontroller.clear();
        _limitcontroller.clear();
        _descriptioncontroller.clear();
        _finecontroller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Violation')),
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
                          "Violation Rule",
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _isChecked,
                  activeColor: Colors.blue, // Checkbox color when checked
                  checkColor: Colors.white, // Tick mark color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Rounded corners
                  ),
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                Text(
                  "Do You want to Set Limit?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            _isChecked
                ? TextField(
                    keyboardType: TextInputType.number, // Number keypad
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Restricts input to digits only
                    controller: _limitcontroller,
                    decoration: InputDecoration(
                      labelText: 'Enter Limit ',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      hintText: 'Enter the Limit ',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                      prefixIcon:
                          Icon(Icons.rule, color: Colors.teal, size: 18),
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
                onPressed: () {
                  _addviolation();
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
