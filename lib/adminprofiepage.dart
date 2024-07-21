import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProfilePage extends StatefulWidget {
  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  late String _userEmail;
  Map<String, dynamic>? _adminData; // Make _adminData nullable
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;
  late TextEditingController _shopNameController;
  late TextEditingController _shopAddressController;
  late TextEditingController _contactNumberController;
  late TextEditingController _gPayNumberController;
  late TextEditingController _bankNameController;
  late TextEditingController _accountNumberController;
  late TextEditingController _ifscDetailsController;
  late TextEditingController _prizesController;
  late TextEditingController _genderController;
  late TextEditingController _registerIDController; // Add controller for RegisterID

  @override
  void initState() {
    super.initState();
    _getUserData();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _addressController = TextEditingController();
    _shopNameController = TextEditingController();
    _shopAddressController = TextEditingController();
    _contactNumberController = TextEditingController();
    _gPayNumberController = TextEditingController();
    _bankNameController = TextEditingController();
    _accountNumberController = TextEditingController();
    _ifscDetailsController = TextEditingController();
    _prizesController = TextEditingController();
    _genderController = TextEditingController();
    _registerIDController = TextEditingController(); // Initialize RegisterID controller
  }

  void _getUserData() {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      setState(() {
        _userEmail = user.email!;
      });
      _fetchAdminData();
    }
  }

  void _fetchAdminData() async {
    try {
      var docSnapshot =
          await FirebaseFirestore.instance.collection('Admins').doc(_userEmail).get();

      if (docSnapshot.exists) {
        setState(() {
          _adminData = docSnapshot.data() as Map<String, dynamic>;
          _nameController.text = _adminData?['Name'] ?? '';
          _ageController.text = _adminData?['Age'].toString() ?? '';
          _addressController.text = _adminData?['Address'] ?? '';
          _shopNameController.text = _adminData?['ShopName'] ?? '';
          _shopAddressController.text = _adminData?['ShopAddress'] ?? '';
          _contactNumberController.text = _adminData?['ContactNumber'] ?? '';
          _gPayNumberController.text = _adminData?['GPayNumber'] ?? '';
          _bankNameController.text = _adminData?['BankAccountDetails']['BankName'] ?? '';
          _accountNumberController.text = _adminData?['BankAccountDetails']['AccountNumber'] ?? '';
          _ifscDetailsController.text = _adminData?['BankAccountDetails']['IFSCDetails'] ?? '';
          _prizesController.text = _adminData?['Prizes'] ?? '';
          _genderController.text = _adminData?['Gender'] ?? '';
          _registerIDController.text = _adminData?['RegisterId'] ?? ''; // Assign RegisterID value
        });
      }
    } catch (e) {
      print('Error fetching admin data: $e');
    }
  }

  void _updateAdminData() async {
    try {
      await FirebaseFirestore.instance.collection('Admins').doc(_userEmail).update({
        'Name': _nameController.text,
        'Age': int.parse(_ageController.text),
        'Address': _addressController.text,
        'ShopName': _shopNameController.text,
        'ShopAddress': _shopAddressController.text,
        'ContactNumber': _contactNumberController.text,
        'GPayNumber': _gPayNumberController.text,
        'BankAccountDetails': {
          'BankName': _bankNameController.text,
          'AccountNumber': _accountNumberController.text,
          'IFSCDetails': _ifscDetailsController.text,
        },
        'Prizes': _prizesController.text,
        'Gender': _genderController.text,
        'RegisterId': _registerIDController.text, // Update RegisterID
      });

      _fetchAdminData();
      Navigator.pop(context);
    } catch (e) {
      print('Error updating admin data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    nameController: _nameController,
                    ageController: _ageController,
                    addressController: _addressController,
                    shopNameController: _shopNameController,
                    shopAddressController: _shopAddressController,
                    contactNumberController: _contactNumberController,
                    gPayNumberController: _gPayNumberController,
                    bankNameController: _bankNameController,
                    accountNumberController: _accountNumberController,
                    ifscDetailsController: _ifscDetailsController,
                    prizesController: _prizesController,
                    genderController: _genderController,
                    registerIDController: _registerIDController, // Pass RegisterID controller
                    onSave: _updateAdminData,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _adminData != null
            ? SingleChildScrollView(
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildDetail('Name :', _adminData?['Name']),
                        buildDetail('Age :', _adminData?['Age'].toString()),
                        buildDetail('Address :', _adminData?['Address']),
                        buildDetail('Shop Name :', _adminData?['ShopName']),
                        buildDetail('Shop Address :', _adminData?['ShopAddress']),
                        buildDetail('Contact Number :', _adminData?['ContactNumber']),
                        buildDetail('GPay Number :', _adminData?['GPayNumber']),
                        buildDetail('Bank Name :', _adminData?['BankAccountDetails']['BankName']),
                        buildDetail('Account Number :', _adminData?['BankAccountDetails']['AccountNumber']),
                        buildDetail('IFSC Details :', _adminData?['BankAccountDetails']['IFSCDetails']),
                        buildDetail('Prizes :', _adminData?['Prizes']),
                        buildDetail('Gender :', _adminData?['Gender']),
                        buildDetail('RegisterId :', _adminData?['RegisterId']), // Display RegisterID
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget buildDetail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController addressController;
  final TextEditingController shopNameController;
  final TextEditingController shopAddressController;
  final TextEditingController contactNumberController;
  final TextEditingController gPayNumberController;
  final TextEditingController bankNameController;
  final TextEditingController accountNumberController;
  final TextEditingController ifscDetailsController;
  final TextEditingController prizesController;
  final TextEditingController genderController;
  final TextEditingController registerIDController; // Add controller for RegisterID
  final VoidCallback onSave;

  const EditProfilePage({
    Key? key,
    required this.nameController,
    required this.ageController,
    required this.addressController,
    required this.shopNameController,
    required this.shopAddressController,
    required this.contactNumberController,
    required this.gPayNumberController,
    required this.bankNameController,
    required this.accountNumberController,
    required this.ifscDetailsController,
    required this.prizesController,
    required this.genderController,
    required this.registerIDController, // Accept RegisterID controller
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.save_sharp),
            onPressed: onSave,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: shopNameController,
              decoration: InputDecoration(labelText: 'Shop Name'),
            ),
            TextField(
              controller: shopAddressController,
              decoration: InputDecoration(labelText: 'Shop Address'),
            ),
            TextField(
              controller: contactNumberController,
              decoration: InputDecoration(labelText: 'Contact Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: gPayNumberController,
              decoration: InputDecoration(labelText: 'GPay Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: accountNumberController,
              decoration: InputDecoration(labelText: 'Account Number'),
            ),
            TextField(
              controller: prizesController,
              decoration: InputDecoration(labelText: 'Prizes'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: registerIDController, // Bind to RegisterID controller
              decoration: InputDecoration(labelText: 'Register ID'), // Add RegisterID field
            ),
            // Add more TextFields for other fields...
          ],
        ),
      ),
    );
  }
}
