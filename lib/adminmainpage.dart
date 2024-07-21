import 'dart:io';
import 'package:e_cloneport/adminloginpage.dart';
import 'package:e_cloneport/adminprofiepage.dart';
import 'package:e_cloneport/ordercheck.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Amainpage extends StatelessWidget {
  TextEditingController _shopStatusController = TextEditingController(); // Added

  // Firebase Firestore instance
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empty Widget',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('ORDER CHECK'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.blue,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.person), // Profile icon
            onPressed: () {
              // Navigate to the profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminProfilePage()),
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout), // Three-dot icon
              onPressed: () {
                // Open a menu or navigate to another page
                // For simplicity, let's navigate to another page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ALoginPage()),
                );
              },
            ),
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmptyWidget(
                image: null,
                title: 'WELCOME BACK TO CLONE PORT',
                subTitle: 'Please check the Order',
                titleTextStyle: TextStyle(
                  fontSize: 22,
                  color: Color.fromARGB(255, 31, 150, 47),
                  fontWeight: FontWeight.bold,
                ),
                subtitleTextStyle: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 21, 226, 199),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                    Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderCheckPage()),
              );
                },
                icon: Icon(Icons.check),
                label: Text('ORDER CHECK'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showShopAvailabilityDialog(context);
          },
          child: Icon(Icons.chat_rounded),
        ),
      ),
    );
  }

  void _showShopAvailabilityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Shop Availability'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Shop Available'),
                leading: Radio(
                  value: 'Available',
                  groupValue: _shopStatusController.text,
                  onChanged: (value) {
                    _shopStatusController.text = value.toString();
                  },
                ),
              ),
              ListTile(
                title: Text('Shop Unavailable'),
                leading: Radio(
                  value: 'Unavailable',
                  groupValue: _shopStatusController.text,
                  onChanged: (value) {
                    _shopStatusController.text = value.toString();
                  },
                ),
              ),
              ListTile(
                title: Text('Some Problem'),
                leading: Radio(
                  value: 'Some Problem',
                  groupValue: _shopStatusController.text,
                  onChanged: (value) {
                    _shopStatusController.text = value.toString();
                  },
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Get the current user's authentication information
                String userEmail = _getUserEmail();

                // Check if the user is authenticated
                if (userEmail.isNotEmpty) {
                  // Use the user's authentication email as the document ID
                  await _firestore.collection('Admins').doc(userEmail).update({
                    'ShopStatus': _shopStatusController.text,
                  });

                  // Close the dialog
                  Navigator.pop(context);
                } else {
                  // Handle the case where user authentication email is empty
                  print('User authentication email is empty');
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Helper function to get the user's authentication email
  String _getUserEmail() {
    // Assuming you have a FirebaseAuth instance
    var user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      return user.email!;
    }
    return '';
  }
}
