import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'adminmainpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Razorpay razorpay;

  @override
  void initState() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
    super.initState();
  }

  TextEditingController amountController = TextEditingController();

  void errorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
      backgroundColor: Colors.red,
    ));
  }

  void successHandler(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.paymentId!),
      backgroundColor: Colors.green,
    ));

    // Store payment details and extra fields in Firebase Firestore
    await storePaymentDetails(response.paymentId!);

    // Navigate to the admin main page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Amainpage()),
    );
  }

  void externalWalletHandler(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.walletName!),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> storePaymentDetails(String paymentId) async {
    try {
      // Get the current user's authentication information
      String userEmail = _getUserEmail();

      // Check if the user is authenticated
      if (userEmail.isNotEmpty) {
        // Use the user's authentication email as the document ID
        await FirebaseFirestore.instance.collection('Admins').doc(userEmail).set({
          'PaymentDetails': {
            'Amount': num.parse(amountController.text),
            'PaymentId': paymentId,
          },
          // Add extra fields as needed
          'ExtraField1': 'Value1',
          'ExtraField2': 'Value2',
          // ...
        }, SetOptions(merge: true));

        print('Payment details stored in Firestore');
      } else {
        // Handle the case where user authentication email is empty
        print('User authentication email is empty');
      }
    } catch (e) {
      // Handle Firestore error
      print('Error storing payment details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Process"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.teal,
      body: Column(
        children: [
          Container(
            color: Colors.teal, // Background color for the entire screen
            child: Card(
              color: Colors.white10, // Background color for the card
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        hintText: "Amount",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      openCheckout();
                      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Amainpage()),
            );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        "Pay now",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Image widget below the card
          Image.asset(
            'images/in1.png',
            height: 300, // Adjust the height as needed
            width: double.infinity, // Take full width
            fit: BoxFit.fill, // Adjust the fit based on your requirement
          ),
        ],
      ),
    );
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_jhZcx2FoTUIseG",
      "amount": num.parse(amountController.text) * 100,
      "name": "Cloneport",
      "description": "This is the test payment",
      "timeout": "180",
      "currency": "INR",
      "prefill": {
        "contact": "6383634491",
        "email": "mohanasundars909@gmail.com",
      }
    };
    razorpay.open(options);
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
