import 'package:e_cloneport/admin%20payment%20page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRegistrationPage extends StatefulWidget {
  const AdminRegistrationPage({Key? key}) : super(key: key);

  @override
  _AdminRegistrationPageState createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _shopNameController = TextEditingController();
  TextEditingController _shopAddressController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _gpayNumberController = TextEditingController();
  TextEditingController _bankAccountController = TextEditingController();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _ifscDetailsController = TextEditingController();
  TextEditingController _prizesController = TextEditingController();
  String? _gender;
  bool _agreedToTerms = false;

  // Firebase Firestore instance
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Registration'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _shopNameController,
                decoration: InputDecoration(labelText: 'Shop Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _shopAddressController,
                decoration: InputDecoration(labelText: 'Shop Address'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _contactNumberController,
                decoration: InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _gpayNumberController,
                decoration: InputDecoration(labelText: 'Google Pay Number'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _bankAccountController,
                decoration: InputDecoration(labelText: 'Bank Account Details'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _bankNameController,
                decoration: InputDecoration(labelText: 'Bank Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _accountNumberController,
                decoration: InputDecoration(labelText: 'Account Number'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _ifscDetailsController,
                decoration: InputDecoration(labelText: 'IFSC Details'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _prizesController,
                decoration: InputDecoration(labelText: 'Prizes'),
              ),
              SizedBox(height: 10),
              Text('Gender'),
              Row(
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreedToTerms = value!;
                        if (value!) {
                          _showTermsAndConditionsDialog(context);
                        }
                      });
                    },
                  ),
                  Text('Agree to terms and conditions'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Validate data before proceeding
                  if (_nameController.text.isEmpty ||
                      _ageController.text.isEmpty ||
                      _addressController.text.isEmpty ||
                      _shopNameController.text.isEmpty ||
                      _shopAddressController.text.isEmpty ||
                      _contactNumberController.text.isEmpty ||
                      _gpayNumberController.text.isEmpty ||
                      _bankAccountController.text.isEmpty ||
                      _bankNameController.text.isEmpty ||
                      _accountNumberController.text.isEmpty ||
                      _ifscDetailsController.text.isEmpty ||
                      _prizesController.text.isEmpty ||
                      _gender == null ||
                      !_agreedToTerms) {
                    // Show an error message or toast indicating missing information
                    return;
                  }

                  // Store data in Firebase Firestore
                  try {
                    // Get the current user's authentication information
                    String userEmail = _getUserEmail();

                    // Check if the user is authenticated
                    if (userEmail.isNotEmpty) {
                      // Use the user's authentication email as the document ID
                      String registerId = generateRegisterId();
                      await _firestore.collection('Admins').doc(userEmail).set({
                        'Name': _nameController.text,
                        'Age': int.parse(_ageController.text),
                        'Address': _addressController.text,
                        'ShopName': _shopNameController.text,
                        'ShopAddress': _shopAddressController.text,
                        'ContactNumber': _contactNumberController.text,
                        'GPayNumber': _gpayNumberController.text,
                        'BankAccountDetails': {
                          'BankName': _bankNameController.text,
                          'AccountNumber': _accountNumberController.text,
                          'IFSCDetails': _ifscDetailsController.text,
                        },
                        'Prizes': _prizesController.text,
                        'Gender': _gender,
                        'RegisterId': registerId,
                      });

                      // Display register ID in alert dialog
                      _showRegisterIdDialog(registerId);
                    } else {
                      // Handle the case where user authentication email is empty
                      print('User authentication email is empty');
                    }
                  } catch (e) {
                    // Handle Firestore error
                    print('Error storing data: $e');
                  }
                },
                child: Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
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

  void _showTermsAndConditionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms and Conditions'),
          content: SingleChildScrollView(
            child: Text(
              // Your terms and conditions text here
              'By accessing and using our app, you agree to comply with the following terms and conditions. Our app facilitates document processing and provides daily updates on shop status. Users are expected to use the app responsibly and refrain from misuse. We emphasize that users are solely responsible for their actions within the app. Any misuse or violation of these terms may result in account suspension or termination. Your cooperation in adhering to these terms ensures a positive experience for all users',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showRegisterIdDialog(String registerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Successful'),
          content: Text('Your registration ID is: $registerId'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String generateRegisterId() {
    // Generate a unique register ID based on current timestamp or any other logic
    // For simplicity, you can use a combination of static prefix and current timestamp
    String prefix = 'Cl'; // Prefix for admin registration IDs
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return '$prefix$timestamp';
  }
}
