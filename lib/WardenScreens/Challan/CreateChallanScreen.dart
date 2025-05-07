import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motorbikesafety/Model/Violation.dart';
import 'package:motorbikesafety/Model/ViolationDetails.dart';
import 'package:motorbikesafety/Model/ViolationFIne.dart';
import 'package:motorbikesafety/Model/ViolationHistory.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';

class CreateChallanScreen extends StatefulWidget {
  final ViolationHistory violationhistory;
  final int wardenId;

  const CreateChallanScreen(
      {super.key, required this.violationhistory, required this.wardenId});

  @override
  State<CreateChallanScreen> createState() => _CreateChallanScreenState();
}

class _CreateChallanScreenState extends State<CreateChallanScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();

  // Store selected violations
  Set<int> selectedViolations = {};

  double getTotalFine() {
    double sum = 0;
    for (var violation in violationrulelist) {
      if (selectedViolations.contains(violation.id)) {
        sum += violation.fines[0].fine;
      }
    }
    return sum;
  }

  API api = API();
  bool _isLoading = false;
  List<Violation> violationrulelist = [];

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
        autoSelectViolations();
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

  // Fetching cities from the API
  Future<void> _addchallanrecord() async {
    setState(() {
      _isLoading = true;
    });

    try {
      double fine = getTotalFine();
      String status = "Pending";
      List<int> v_lits = selectedViolations.toList();
      var response = await api.addchallan(
          widget.violationhistory.id,
          v_lits,
          cnicController.text,
          nameController.text,
          mobileController.text,
          vehicleController.text,
          widget.wardenId,
          fine,
          status);

      if (response.statusCode == 201) {
        cnicController.text = "";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Challan added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Challan')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error csacdas: $e')),
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
    vehicleController.text = widget.violationhistory.licenseplate;
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
                          "Create Challan",
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Violation ID: ${widget.violationhistory.id}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Warden ID: ${widget.wardenId}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              _buildTextField("Enter Name", nameController, Icons.abc),
              _buildTextField("Enter CNIC / License Number", cnicController,
                  Icons.perm_identity),
              _buildTextField(
                  "Enter Mobile Number", mobileController, Icons.numbers),
              const SizedBox(height: 8),

              // Violations Section Inside a Fixed Box with Scroll
              Text(
                "Violations & Fine:",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 200, // Fixed Height
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _buildViolationsList(),
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                  "Enter Vehicle Number", vehicleController, Icons.car_crash),
              const SizedBox(height: 10),
              Center(
                child: _buildFineBox(),
              ),

              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size.fromHeight(50),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // No rounding
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _addchallanrecord();
                    });
                  },
                  child: const Text(
                    'Issue Challan',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 14),

          prefixIcon: Icon(icon, color: Colors.teal),
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
    );
  }

  Widget _buildViolationsList() {
    if (violationrulelist.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "No Violation Rule Available",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
          ),
        ),
      );
    }

    return SizedBox(
      height: 300, // Adjust based on your UI needs
      child: ListView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // Prevents conflict with other scrollable views
        itemCount: violationrulelist.length,
        itemBuilder: (context, index) {
          Violation violationrule = violationrulelist[index];
          ViolationFine? fine =
              violationrule.fines.isNotEmpty ? violationrule.fines[0] : null;

          return CheckboxListTile(
            title: Text(
              "${violationrule.id} - ${violationrule.name} - ${fine?.fine}",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            value: selectedViolations.contains(violationrule.id),
            activeColor: Colors.red, // Highlight selected violations
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  selectedViolations.add(violationrule.id);
                } else {
                  selectedViolations.remove(violationrule.id);
                }
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildFineBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal, width: 1.5),
      ),
      child: Text(
        "Total Fine: ${getTotalFine()} PKR",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.red,
        ),
      ),
    );
  }

  void autoSelectViolations() {
    List<ViolationDetail> detectedViolation =
        widget.violationhistory.violationDetails;

    for (var item in detectedViolation) {
      for (var violationRule in violationrulelist) {
        if (item.violationName == violationRule.name) {
          selectedViolations.add(violationRule.id);
          break;
        }
      }
    }

    getTotalFine(); // Calculate total fine after selecting
    setState(() {}); // Refresh UI if needed
  }
}
