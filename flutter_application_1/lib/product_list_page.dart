import 'package:flutter/material.dart';
import 'mongo_connection.dart'; // Ensure this file handles your MongoDB connection

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      var collection = await MongoDatabase.getCollection();
      var productList = await collection.find().toList();

      setState(() {
        products = productList
            .map((product) => Map<String, dynamic>.from(product))
            .toList();
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Function to show product details in a pop-up dialog
  void showProductDetails(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product['name'] ?? 'No Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📌 Product ID: ${product['product_id']}"),
              Text("📦 Quantity: ${product['quantity']}"),
              Text("💰 Price: \₹ ${product['price']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    onTap: () => showProductDetails(
                        context, product), // ✅ Show pop-up on tap
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(product['product_id'].toString()),
                    ),
                    title: Text(product['name'] ?? 'No Name'),
                    subtitle: Text(
                        'Qty: ${product['quantity']} | Price: \₹${product['price']}'),
                  ),
                );
              },
            ),
    );
  }
}
