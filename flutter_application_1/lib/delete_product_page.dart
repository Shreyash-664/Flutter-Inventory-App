import 'package:flutter/material.dart';
import 'mongo_connection.dart';

class DeleteProductPage extends StatefulWidget {
  const DeleteProductPage({super.key});

  @override
  _DeleteProductPageState createState() => _DeleteProductPageState();
}

class _DeleteProductPageState extends State<DeleteProductPage> {
  final TextEditingController productIdController = TextEditingController();
  Map<String, dynamic>? productDetails;

  void showSnackbar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> viewProduct() async {
    try {
      var collection = await MongoDatabase.getCollection();
      int productId = int.parse(productIdController.text);
      var product = await collection.findOne({'product_id': productId});

      setState(() {
        productDetails = product;
      });

      if (product == null) {
        showSnackbar('❌ Product not found!', isSuccess: false);
      }
    } catch (e) {
      showSnackbar('❌ Error: $e', isSuccess: false);
    }
  }

  Future<void> deleteProduct() async {
    try {
      var collection = await MongoDatabase.getCollection();
      int productId = int.parse(productIdController.text);
      var product = await collection.findOne({'product_id': productId});

      if (product != null) {
        bool confirmDelete = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content:
                Text('Are you sure you want to delete ${product['name']}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        if (confirmDelete == true) {
          await collection.deleteOne({'product_id': productId});
          showSnackbar('✅ Product deleted successfully!');
          productIdController.clear();
          setState(() {
            productDetails = null;
          });
        }
      } else {
        showSnackbar('❌ Product not found!', isSuccess: false);
      }
    } catch (e) {
      showSnackbar('❌ Error: $e', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Product'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 140,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.delete, size: 40, color: Colors.blueAccent),
                ),
                const SizedBox(height: 8),
                const Text('My Inventory',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const Text('ABC Shop',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: productIdController,
                    decoration: const InputDecoration(
                      labelText: 'Product ID',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: viewProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('View',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: deleteProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Delete',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (productDetails != null)
                    Card(
                      elevation: 3,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Product: ${productDetails!['name']}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Quantity: ${productDetails!['quantity']}'),
                            Text('Price: \₹${productDetails!['price']}'),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
