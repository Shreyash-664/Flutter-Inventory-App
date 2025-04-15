import 'package:flutter/material.dart';
import 'mongo_connection.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    MongoDatabase.connect(); // ✅ Ensure MongoDB connection is established once
  }

  void showSnackbar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  void showProductExistsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duplicate Product ID'),
        content: const Text('A product with this ID already exists.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> addProductToDB() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      var collection = await MongoDatabase.getCollection();
      int productId = int.parse(productIdController.text);
      int quantity = int.parse(quantityController.text);
      double price = double.parse(priceController.text);

      var product = {
        'product_id': productId,
        'name': productNameController.text,
        'quantity': quantity,
        'price': price,
      };

      var existingProduct = await collection.findOne({'product_id': productId});
      if (existingProduct != null) {
        showProductExistsDialog();
      } else {
        var result = await collection.insertOne(product);
        showSnackbar(
            result.isSuccess
                ? '✅ Product added successfully!'
                : '❌ Failed to add product!',
            isSuccess: result.isSuccess);

        // Clear inputs after successful action
        productIdController.clear();
        productNameController.clear();
        quantityController.clear();
        priceController.clear();
      }
    } catch (e) {
      showSnackbar('❌ Error: $e', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildTextField(productIdController, 'Product ID', true),
                    const SizedBox(height: 10),
                    buildTextField(
                        productNameController, 'Product Name', false),
                    const SizedBox(height: 10),
                    buildTextField(quantityController, 'Quantity', true),
                    const SizedBox(height: 10),
                    buildTextField(priceController, 'Price', true),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: addProductToDB,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Add Product',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            child: Icon(Icons.add, size: 40, color: Colors.blueAccent),
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

  Widget buildTextField(
      TextEditingController controller, String label, bool isNumeric) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        if (isNumeric && double.tryParse(value) == null) {
          return 'Invalid number format';
        }
        return null;
      },
    );
  }
}
