import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditUserProfilePage extends StatefulWidget {
  final Map<String, String> wardenDetails;

  const EditUserProfilePage({super.key, required this.wardenDetails});

  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController badgeController;
  late TextEditingController cnicController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController cityController;
  File? _image;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.wardenDetails["name"]);
    badgeController =
        TextEditingController(text: widget.wardenDetails["badge_number"]);
    cnicController = TextEditingController(text: widget.wardenDetails["cnic"]);
    emailController =
        TextEditingController(text: widget.wardenDetails["email"]);
    mobileController =
        TextEditingController(text: widget.wardenDetails["mobile_number"]);
    cityController = TextEditingController(text: widget.wardenDetails["city"]);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Save logic here, e.g., update in database
      Navigator.pop(context, {
        "name": nameController.text,
        "badge_number": badgeController.text,
        "cnic": cnicController.text,
        "email": emailController.text,
        "mobile_number": mobileController.text,
        "city": cityController.text,
        "image_url":
            _image != null ? _image!.path : widget.wardenDetails["image_url"],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : NetworkImage(widget.wardenDetails["image_url"]!)
                            as ImageProvider,
                    child:
                        Icon(Icons.camera_alt, color: Colors.white70, size: 30),
                  ),
                ),
                SizedBox(height: 20),

                // Editable Form Fields
                _buildTextField(nameController, "Name", Icons.person),
                _buildTextField(badgeController, "Badge Number", Icons.badge),
                _buildTextField(cnicController, "CNIC", Icons.credit_card),
                _buildTextField(emailController, "Email", Icons.email),
                _buildTextField(mobileController, "Mobile Number", Icons.phone),
                _buildTextField(cityController, "City", Icons.location_city),

                SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text("Save",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Please enter $label" : null,
      ),
    );
  }
}
