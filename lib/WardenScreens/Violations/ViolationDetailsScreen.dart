import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motorbikesafety/Model/ViolationHistory.dart';
import 'package:motorbikesafety/Model/ViolationImage.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';
import 'package:motorbikesafety/WardenScreens/Challan/CreateChallanScreen.dart';

class ViolationDetailsScreen extends StatefulWidget {
  final ViolationHistory violationhistory;
  final int wardenid;
  final int nakaid;
  const ViolationDetailsScreen(
      {super.key,
      required this.violationhistory,
      required this.wardenid,
      required this.nakaid});

  @override
  State<ViolationDetailsScreen> createState() => _ViolationDetailsScreenState();
}

class _ViolationDetailsScreenState extends State<ViolationDetailsScreen> {
  List<ViolationImage> imageData_list = [];
  // final List<String> imageslist = [
  //   'assets/image1.png',
  //   'assets/image2.png',
  //   'assets/image3.png',
  // ];
  API api = API();
  bool _isLoading = false;

  List<ViolationHistory> violationlist = [];

  Future<void> _getviolationhistoryfornakabyid(
      int chowkiid, int wardenid) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await api.getviolationhistorybynakaid(chowkiid, wardenid);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> violationmap = data['violation_histories'] ?? [];
        violationlist =
            violationmap.map((e) => ViolationHistory.fromMap(e)).toList();
        if (violationlist.isEmpty) {
        } else {
          ViolationHistory? matched;

          try {
            matched = violationlist
                .firstWhere((v) => v.id == widget.violationhistory.id);
          } catch (e) {
            matched = null;
          }
          if (matched != null) {
            widget.violationhistory.status = matched.status;
            setState(() {});

            // Add more fields as needed
          }
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

  Future<void> _fetchImages(int id) async {
    final url = '${API.baseurl}/get-images/$id'; // Replace with your server URL

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

  Future<bool> send_Notification_to_link_naka() async {
    print("Sending Notifications to Link Naka");

    try {
      var response = await api.send_notificationto_link_Naka(
        widget.nakaid,
        widget.violationhistory.licenseplate,
        3,
        widget.violationhistory.location,
        widget.violationhistory.id,
      );

      if (response.statusCode == 200) {
        List<dynamic> linknakalist = json.decode(response.body);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                linknakalist.isEmpty
                    ? 'No Link Notifications Found'
                    : 'Notifications Sent Successfully',
              ),
            ),
          );
        }
        return true;
      } else if (response.statusCode == 404) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No Link Naka Found')),
          );
        }
        return true;
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to Send Notifications to Link Naka')),
          );
        }
        return false;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getviolationhistoryfornakabyid(widget.nakaid, widget.wardenid);
    _fetchImages(widget.violationhistory.id);
  }

  final PageController _pageController = PageController();
  int currentIndex = 0;

  void _nextImage() {
    if (currentIndex < imageData_list.length - 1) {
      int targetIndex = currentIndex + 1;

      _pageController.animateToPage(
        targetIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() {
        currentIndex = targetIndex;
      });
    }
  }

  void _previousImage() {
    if (currentIndex > 0) {
      int targetIndex = currentIndex - 1;

      _pageController.animateToPage(
        targetIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() {
        currentIndex = targetIndex;
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
                              color: Colors.teal
                                  .shade900, // Darker arrow color for contrast
                              size: 30, // Larger size for the back arrow
                            ),
                            onPressed: () {
                              Navigator.pop(
                                  context,
                                  widget.violationhistory
                                      .status); // Go back to the previous screen
                            }),
                      ),
                    ),
                  ),
                  // Title and Subtitle Text Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Violation Detail",
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
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
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
                        widget.violationhistory.violationDatetime),
                    _buildRow(Icons.location_on, "Violation Location:",
                        widget.violationhistory.location),
                    _buildRow(Icons.directions_car, "Vehicle Number:",
                        widget.violationhistory.licenseplate),
                    _buildRow(Icons.motorcycle, "Vehicle Type:",
                        widget.violationhistory.vehicletype),
                    _buildRow(Icons.warning, "Status:",
                        widget.violationhistory.status),
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
                      children: widget.violationhistory.violationDetails
                          .map((detail) {
                        return _buildViolationChip(detail.violationName);
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Image.network(
                              "${API.baseurl}/uploads/${imageData_list[index].imagePath}",
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
            const SizedBox(height: 20),
            widget.violationhistory.status != "Issue"
                ? SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size.fromHeight(50),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // No rounding
                        ),
                      ),
                      onPressed: () async {
                        bool check = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateChallanScreen(
                              wardenId: widget.wardenid,
                              violationhistory: widget.violationhistory,
                            ),
                          ),
                        );
                        if (check) {
                          setState(() {
                            _getviolationhistoryfornakabyid(
                                widget.nakaid, widget.wardenid);
                          });
                        }
                      },
                      child: const Text(
                        "Create Challan",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(),
            const SizedBox(height: 20),
            widget.violationhistory.status != "Issue"
                ? SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size.fromHeight(50),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // No rounding
                        ),
                      ),
                      onPressed: () async {
                        bool check = await send_Notification_to_link_naka();
                        if (check) {
                          setState(() {
                            _getviolationhistoryfornakabyid(
                                widget.nakaid, widget.wardenid);
                          });
                        }
                      },
                      child: const Text(
                        "Notify Link Naka",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
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
              fontWeight: FontWeight.bold, // BOLD
              fontSize: 13, // Bigger Size
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, // BOLD
                fontSize: 11, // Smaller Size
                color: Colors.black87,
              ),
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
