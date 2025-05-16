import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motorbikesafety/Model/Challan.dart';
import 'package:motorbikesafety/Model/ViolationHistory.dart';
import 'package:motorbikesafety/Model/ViolationImage.dart';
import 'package:motorbikesafety/WardenScreens/Challan/CreateChallanScreen.dart';

class ChallanDetailsScreen extends StatefulWidget {
  final Challan challanhistory;
  final int wardenid;
  const ChallanDetailsScreen(
      {super.key, required this.challanhistory, required this.wardenid});

  @override
  State<ChallanDetailsScreen> createState() => _ChallanDetailsScreenState();
}

class _ChallanDetailsScreenState extends State<ChallanDetailsScreen> {
  List<ViolationImage> imageData_list = [];

  Future<void> _fetchImages(int id) async {
    final url =
        'http://192.168.1.5:4321/get-images/$id'; // Replace with your server URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          List<dynamic> imageData = responseData['image_data'] ?? [];
          imageData_list =
              imageData.map((e) => ViolationImage.fromJson(e)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch violation images.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchImages(widget.challanhistory.violationHistoryId);
  }

  PageController _pageController = PageController();
  int currentIndex = 0;

  void _nextImage() {
    if (currentIndex < imageData_list.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousImage() {
    if (currentIndex > 0) {
      // Animate to the previous page before updating the index
      _pageController.animateToPage(
        currentIndex - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Update the current index after the animation
      setState(() {
        currentIndex--;
      });
    }
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
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 30.0), // Margin to position it well
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                                0.5), // Semi-transparent background
                            shape: BoxShape
                                .circle, // Circular background for the arrow
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45, // Soft shadow for depth
                                blurRadius: 6.0, // Shadow blur radius
                                offset:
                                    Offset(2, 2), // Shadow offset for realism
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
                    ),
                    // Title and Subtitle Text Content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Challan Detail",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25, // Larger title for prominence
                              fontWeight: FontWeight.bold,
                              letterSpacing:
                                  1.5, // Elegance with letter spacing
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildRow(Icons.calendar_today, "Violation Date:",
                            "${widget.challanhistory.challanDate}"),
                        _buildRow(Icons.numbers, "Challan ID:",
                            "${widget.challanhistory.id}"),
                        _buildRow(Icons.person, "Violator Name:",
                            "${widget.challanhistory.violatorName}"),
                        _buildRow(Icons.badge, "CNIC:",
                            "${widget.challanhistory.violatorCnic}"),
                        _buildRow(Icons.phone_android, "Mobile:",
                            "${widget.challanhistory.mobileNumber}"),
                        _buildRow(Icons.car_repair, "Vehicle Number:",
                            "${widget.challanhistory.vehicleNumber}"),
                        _buildRow(Icons.monetization_on, "Fine Amount:",
                            "Rs. ${widget.challanhistory.fineAmount}"),
                        _buildRow(Icons.verified_user, "Status:",
                            "${widget.challanhistory.status}"),
                        const Divider(thickness: 1, height: 20),
                        Text(
                          "Violations:",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: widget.challanhistory.challanDetails
                              .map((detail) {
                            return _buildViolationChip(
                                "${detail.violation} ${detail.fine}");
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 220, // Slightly increased for better space
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      if (imageData_list.length > 1 && currentIndex > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.black54),
                          onPressed: () {
                            setState(() {
                              _previousImage();
                            });
                          },
                        ),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: imageData_list.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                ),
                                child: Image.network(
                                  "http://127.0.0.1:4321/uploads/${imageData_list[index].imagePath}",
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                        child: Text("Image not found"));
                                  },
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (imageData_list.length > 1 &&
                          currentIndex < imageData_list.length - 1)
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: Colors.black54),
                          onPressed: _nextImage,
                        ),
                    ],
                  ),
                ),
                // const SizedBox(height: 20),
                // widget.challanhistory.status == "Pending"
                //     ? SizedBox(
                //         width: double.infinity,
                //         child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.teal,
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(8),
                //               side: BorderSide(color: Colors.teal.shade700),
                //             ),
                //           ),
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => CreateChallanScreen(
                //                   wardenId: widget.wardenid,
                //                   violationhistory: widget.challanhistory,
                //                 ),
                //               ),
                //             );
                //           },
                //           child: Text(
                //             "Create Challan",
                //             style: GoogleFonts.poppins(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //       )
                //     : SizedBox(),
              ],
            ),
          ),
        ));
  }

  Widget _buildRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViolationChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red[900]),
      ),
    );
  }
}
