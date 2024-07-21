import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'adminforgetpasswordpage.dart';
import 'adminmainpage.dart';
import 'adminregistrationpage.dart';
import 'adminsignuppage.dart';

class ALoginPage extends StatefulWidget {
  const ALoginPage({Key? key}) : super(key: key);

  @override
  _ALoginPageState createState() => _ALoginPageState();
}

class _ALoginPageState extends State<ALoginPage> {
  TextEditingController _adminNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/backlogin.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(),
                Card(
                  color: Colors.white.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _inputField(context),
                  ),
                ),
                _errorMessage.isNotEmpty ? Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ) : SizedBox(), // Display error message if not empty
                _forgotPassword(context),
                _signup(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          "Welcome Back Admin !",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        Text("Please check Your Order", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _adminNameController,
          decoration: InputDecoration(
            hintText: "Admin Email id",
            hintStyle: TextStyle(fontSize: 15, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.white.withOpacity(0.3),
            filled: true,
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            hintStyle: TextStyle(fontSize: 15, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.white.withOpacity(0.3),
            filled: true,
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
          ),
          obscureText: !_showPassword,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            String adminName = _adminNameController.text.trim();
            String password = _passwordController.text.trim();

            try {
              UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: adminName, // Using email for simplicity, modify it based on your authentication method
                password: password,
              );

              // If login is successful, navigate to the main page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Amainpage()),
              );
            } on FirebaseAuthException catch (e) {
              setState(() {
                _errorMessage = 'Wrong password provided. Please try again.';
              });
              // Handle other exceptions as needed
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: Colors.purple,
          ),
          child: const Text(
            "Login",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPassword()),
        );
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ", style: TextStyle(color: Colors.white)),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ASignupPage()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ],
    );
  }
}
