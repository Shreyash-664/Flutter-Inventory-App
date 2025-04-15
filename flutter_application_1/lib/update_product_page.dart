import 'package:flutter/material.dart';
import 'mongo_connection.dart';

class UpdateProductPage extends StatefulWidget {
  const UpdateProductPage({super.key});

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Future<void> fetchProductName() async {
    if (productIdController.text.isEmpty) return;
    try {
      var collection = await MongoDatabase.getCollection();
      int productId = int.parse(productIdController.text);
      var product = await collection.findOne({'product_id': productId});
      if (product != null) {
        setState(() {
          productNameController.text = product['name'];
        });
      } else {
        showSnackbar('❌ Product ID not found', isSuccess: false);
        productNameController.clear();
      }
    } catch (e) {
      showSnackbar('❌ Error: $e', isSuccess: false);
    }
  }

  Future<void> updateProduct() async {
    if (productIdController.text.isEmpty ||
        quantityController.text.isEmpty ||
        priceController.text.isEmpty) {
      showSnackbar('⚠️ Please fill all fields', isSuccess: false);
      return;
    }

    try {
      var collection = await MongoDatabase.getCollection();
      int productId = int.parse(productIdController.text);
      int newQuantity = int.parse(quantityController.text);
      double newPrice = double.parse(priceController.text);

      var product = await collection.findOne({'product_id': productId});
      if (product == null) {
        showSnackbar('❌ Product ID not found', isSuccess: false);
        return;
      }

      int updatedQuantity = product['quantity'] + newQuantity;
      await collection.updateOne(
        {'product_id': productId},
        {
          '\$set': {
            'quantity': updatedQuantity,
            'price': newPrice,
          }
        },
      );

      showSnackbar('✅ Product updated successfully!');

      // Clear inputs
      productIdController.clear();
      productNameController.clear();
      quantityController.clear();
      priceController.clear();
    } catch (e) {
      showSnackbar('❌ Error: $e', isSuccess: false);
    }
  }

  void showSnackbar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildHeader(), // ✅ Header Section
              const SizedBox(height: 20), // Spacing after header
              TextFormField(
                controller: productIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Product ID',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => fetchProductName(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: productNameController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Add Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'New Price',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Update Product',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Header Section (Added)
  Widget buildHeader() {
    return Container(
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
            child: Icon(Icons.edit, size: 40, color: Colors.blueAccent),
          ),
          const SizedBox(height: 8),
          const Text(
            'My Inventory',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            'ABC Shop',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
