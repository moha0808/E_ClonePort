import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderDetailsPage extends StatefulWidget {
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late String userEmail;
  late List<OrderData> orders = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    getUserEmail();
    fetchOrders();
  }

  Future<void> getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email!;
      });
    }
  }

  Future<void> fetchOrders() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmail)
          .collection('Orders')
          .get();

      setState(() {
        orders = querySnapshot.docs
            .map((doc) => OrderData.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
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
      body: orders.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return OrderCard(
                  order: orders[index],
                  onDelete: () => deleteOrder(index),
                );
              },
            ),
    );
  }

  Future<void> deleteOrder(int index) async {
    try {
      // Assuming you have a valid reference to the order document
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmail)
          .collection('Orders')
          .doc(orders[index].orderId)
          .delete();

      setState(() {
        orders.removeAt(index);
      });
    } catch (e) {
      print('Error deleting order: $e');
    }
  }
}

class OrderCard extends StatefulWidget {
  final OrderData order;
  final VoidCallback onDelete;

  const OrderCard({Key? key, required this.order, required this.onDelete})
      : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late bool printSuccess;
  late String printStatus;

  @override
  void initState() {
    super.initState();
    checkPrintStatus();
  }

  Future<void> checkPrintStatus() async {
    // Simulating print success or failure
    // Replace this logic with actual implementation
    bool isPrintSuccessful = true; // Change to false for failure

    setState(() {
      printSuccess = isPrintSuccessful;
      printStatus = isPrintSuccessful ? 'Print successful' : 'Print failed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ID: ${widget.order.orderId}'),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Printing Properties:'),
            Text('Paper Size: ${widget.order.paperSize}'),
            Text('Orientation: ${widget.order.orientation}'),
            Text('Color Mode: ${widget.order.colorMode}'),
            Text('Quality: ${widget.order.quality}'),
            Text('Copies: ${widget.order.copies}'),
            Text('Extra: ${widget.order.extraNeed}'),
            SizedBox(height: 10),
            Text('Print Status:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              printStatus,
              style: TextStyle(
                color: printSuccess ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderData {
  final String orderId;
  final String paperSize;
  final String orientation;
  final String colorMode;
  final String extraNeed;
  final int quality;
  final int copies;

  OrderData({
    required this.orderId,
    required this.paperSize,
    required this.orientation,
    required this.colorMode,
    required this.extraNeed,
    required this.quality,
    required this.copies,
  });

  factory OrderData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return OrderData(
      orderId: data?['OrderId'] ?? '',
      paperSize: data?['PaperSize'] ?? '',
      orientation: data?['Orientation'] ?? '',
      colorMode: data?['ColorMode'] ?? '',
      extraNeed: data?['ExtraNeed'] ?? '',
      quality: data?['Quality'] ?? 0,
      copies: data?['Copies'] ?? 0,
    );
  }
}


