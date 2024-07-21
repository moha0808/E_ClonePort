import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderCheckPage extends StatefulWidget {
  @override
  _OrderCheckPageState createState() => _OrderCheckPageState();
}

class _OrderCheckPageState extends State<OrderCheckPage> {
  late List<String> orderIDs = []; // List to store order IDs

  @override
  void initState() {
    super.initState();
    fetchOrderIDs();
  }

  Future<void> fetchOrderIDs() async {
    try {
      // Fetch order IDs from Firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      setState(() {
        // Extract order IDs from documents and store them in the list
        orderIDs = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error fetching order IDs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Check'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: orderIDs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderIDs.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('USER _ID: ${orderIDs[index]}'),
                    // Add onTap function to handle when a card is tapped
                    onTap: () {
                      // Navigate to a new page or show more details
                      // You can replace this with your own implementation
                      _showOrderDetails(orderIDs[index]);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showOrderDetails(String orderID) {
    // Implement function to show order details here
    // For example:
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order Details'),
          content: Text('USER_ID: $orderID'),
          actions: [
            TextButton(
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
}


