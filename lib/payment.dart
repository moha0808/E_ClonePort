import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentDetailsPage extends StatefulWidget {
  @override
  _PaymentDetailsPageState createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  late String userEmail;
  late List<PaymentData> payments = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userEmail = user.email!;
        await fetchPayments();
      } else {
        // Handle the case where user is not authenticated
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchPayments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmail)
          .collection('Payments')
          .get();

      setState(() {
        payments = querySnapshot.docs
            .map((doc) => PaymentData.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      print('Error fetching payments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
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
      body: payments.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                return PaymentCard(
                  payment: payments[index],
                );
              },
            ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final PaymentData payment;

  const PaymentCard({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment ID: ${payment.paymentId}'),
            SizedBox(height: 10),
            Text('Date: ${payment.date}'),
            Text('Amount: ${payment.amount}'),
            Text('Status: ${payment.payment_status}'),
          ],
        ),
      ),
    );
  }
}

class PaymentData {
  final String paymentId;
  final String date;
  final double amount;
  final String payment_status;

  PaymentData({
    required this.paymentId,
    required this.date,
    required this.amount,
    required this.payment_status,
  });

  factory PaymentData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return PaymentData(
      paymentId: doc.id,
      date: data?['date'] ?? '',
      amount: data?['amount'] ?? 0.0,
      payment_status: data?['payment_status'] ?? '',
    );
  }
}
