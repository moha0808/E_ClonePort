import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cloneport/orderdetails.dart';
import 'package:e_cloneport/payment.dart';
import 'package:e_cloneport/profilepage.dart';
import 'package:e_cloneport/signinpage.dart';
import 'package:e_cloneport/userfeedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class homeicon extends StatefulWidget {
  const homeicon({super.key});

  @override
  State<homeicon> createState() => _homeiconState();
}

class _homeiconState extends State<homeicon> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Drawer(
      backgroundColor: Colors.black,
      child: Card(
        color: Colors.grey,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('Users').doc(user?.email).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('User data not found');
                  }

                  var userData = snapshot.data!.data() as Map<String, dynamic>;

                  return UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Color.fromARGB(255, 0, 1, 8)),
                    accountName: Text(
                      userData['username'] ?? '',
                      style: TextStyle(fontSize: 18),
                    ),
                    accountEmail: Text(user?.email ?? ''),
                    currentAccountPictureSize: Size.square(45),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage("images/profile.jpg"),
                      radius: 50,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30.0,),
            ListTile(
              title: Text("User Profile", style: TextStyle(color: Colors.black),),
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            SizedBox(height: 20.0,),
            ListTile(
              title: Text("Order Details", style: TextStyle(color: Colors.black),),
              leading: CircleAvatar(
                child: Icon(Icons.payment),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsPage()));
              },
            ),

            SizedBox(height: 20.0,),
            ListTile(
              title: Text("Payment History", style: TextStyle(color: Colors.black),),
              leading: CircleAvatar(
                child: Icon(Icons.payment),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentDetailsPage()));
              },
            ),

            SizedBox(height: 20.0,),
            ListTile(
              title: Text("Feedback", style: TextStyle(color: Colors.black),),
              leading: CircleAvatar(
                child: Icon(Icons.settings),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()));
              },
            ),
            SizedBox(height: 20.0,),
            ListTile(
              title: Text("Terms & Conditions", style: TextStyle(color: Colors.black),),
              leading: CircleAvatar(
                child: Icon(Icons.description),
              ),
              onTap: () {
                _showTermsConditionsDialog(context);
              },
            ),
            SizedBox(height: 20.0,),
            ElevatedButton.icon(
              onPressed: () {
                _showDeleteAccountDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 209, 62, 62),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadowColor: Colors.black,
              ),
              icon: Icon(Icons.delete, size: 30,color: Colors.black,),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 18,color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 180,),
          ],
        ),
      ),
    );
  }

  Future<void> _showTermsConditionsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms & Conditions'),
          content: SingleChildScrollView(
            child: Text(
              'Welcome to the Clone Port mobile application! By using our app, you agree to abide by these terms and conditions. The app is intended for personal use only, and you are responsible for maintaining the confidentiality of your account information. We respect your privacy and handle your personal information according to our Privacy Policy. While we strive to provide accurate information, we cannot guarantee the accuracy or reliability of the content. By using the app, you acknowledge that Xerox is not liable for any damages resulting from your use of the app. We may update these terms from time to time, so please check back periodically for any changes. If you have any questions or concerns, feel free to reach out to us. Thank you for using the clone Port app!',
              style: TextStyle(fontSize: 16),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account?'),
          content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteAccount();
                 Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>SignupPage ()),
                                );
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      await user?.delete();
      // Delete user data from Firestore
      await _firestore.collection('Users').doc(user?.email).delete();
      // Add additional clean-up logic if needed
      // ...

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      print('Error deleting account: $e');
    }
  }
}
