import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'adminloginpage.dart';
import 'adminregistrationpage.dart';

class ASignupPage extends StatefulWidget {
  const ASignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<ASignupPage> {
  bool agreedToTerms = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String? gender;
  bool showPassword = false; // Track whether to show the password or not
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _register() async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // If registration is successful, store user data in Firestore
      if (userCredential.user != null) {
        await _firestore.collection('Admins').doc(userCredential.user!.email).set({
          'username': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'mobileNumber': _mobileNumberController.text.trim(),
          'gender': gender,
        });

        // Navigate to the next page or perform other actions
        // Navigator.push(context, MaterialPageRoute(builder: (context) => YourNextPage()));
      } else {
        // Handle any other cases if needed
        print("Registration failed");
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminRegistrationPage()),
      );
    } catch (e) {
      // Handle registration errors
      print("Error during registration: $e");
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/backlogin.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  color: Colors.black,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                height: MediaQuery.of(context).size.height - 50,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        const Text(
                          "WELCOME TO CLONE PORT!",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Create your Admin account",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )
                      ],
                    ),
                    Card(
                      color: Colors.white.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: "Admin Name",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                prefixIcon: Icon(Icons.person),
                                border: InputBorder.none,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: "Admin Email",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                prefixIcon: Icon(Icons.email),
                                border: InputBorder.none,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _mobileNumberController,
                              decoration: InputDecoration(
                                hintText: "Admin Mobile number",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                prefixIcon: Icon(Icons.phone),
                                border: InputBorder.none,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Gender: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Radio<String>(
                                  value: "Male",
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value;
                                    });
                                  },
                                ),
                                Text(
                                  "Male",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Radio<String>(
                                  value: "Female",
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value;
                                    });
                                  },
                                ),
                                Text(
                                  "Female",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                ),
                                border: InputBorder.none,
                              ),
                              obscureText: !showPassword,
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                prefixIcon: Icon(Icons.lock),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: agreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              agreedToTerms = value!;
                            });
                          },
                        ),
                        Text(
                          'I agree to the terms and conditions',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      child: ElevatedButton(
                        onPressed: agreedToTerms
                            ? () async {
                          await _register();
                        }
                            : null,
                        child: Text(
                          "Sign up",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.purple,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ALoginPage()),
                            );
                          },
                          child: Text("Login",
                              style: TextStyle(color: Colors.purple)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
