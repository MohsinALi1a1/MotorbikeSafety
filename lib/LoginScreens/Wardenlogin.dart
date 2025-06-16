import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motorbikesafety/AdminMain.dart';
import 'package:motorbikesafety/Service/ApiHandle.dart';
import 'package:motorbikesafety/WardenMain.dart';

class WardenLoginPage extends StatefulWidget {
  const WardenLoginPage({super.key});

  @override
  State<WardenLoginPage> createState() => _WardenLoginPageState();
}

class _WardenLoginPageState extends State<WardenLoginPage> {
  final TextEditingController _badgeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  API api = API();
  bool _isLoading = false;
  Future<void> _checkwardenlogin(String badge, String password) async {
    if (_isLoading) return;

    if (badge.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter Badge Number and Password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await api.wardenlogin(badge, password);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        int? wardenId = int.tryParse(responseData['WardenID'].toString());
        int? permissionType =
            int.tryParse(responseData['PermissionType'].toString());

        if (wardenId == null || permissionType == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid login data received')),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful')),
        );

        if (permissionType == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AdminMain(id: wardenId)),
          );
        } else if (permissionType == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Wardenmain(id: wardenId)),
          );
        }
      } else if (response.statusCode == 401) {
        Map<String, dynamic> responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Unauthorized')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login. Try again later.')),
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
      backgroundColor: Color(0xFFEDEDED),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/logo.png', // Replace with your own asset
                    height: 80,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 5),
                Text(
                  "Login to your account",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _badgeController,
                  decoration: InputDecoration(
                    labelText: 'Badge Number',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                    hintText: 'Enter Badge number',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.teal),
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
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                    hintText: 'Enter Password',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                    prefixIcon: Icon(Icons.password, color: Colors.teal),
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
                SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(value: false, onChanged: (val) {}),
                    Text("Remember me"),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _checkwardenlogin(
                        _badgeController.text, _passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF35A29F),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                  ),
                  child: Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: Text("Forgot your password?"),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don’t have an Account? "),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: Color(0xFF35A29F),
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
