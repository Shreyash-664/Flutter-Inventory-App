import 'package:flutter/material.dart';
import 'mongo_connection.dart'; // Ensure this file has MongoDB connection logic.

class BillPage extends StatefulWidget {
  const BillPage({super.key});

  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  String productName = '';
  double productPrice = 0.0;
  List<Map<String, dynamic>> billItems = []; // Stores added products
  double totalBillAmount = 0.0;

  Future<void> fetchProductDetails() async {
    if (productIdController.text.isEmpty) return;

    try {
      var collection = await MongoDatabase.getCollection();
      int productId = int.parse(productIdController.text);
      var product = await collection.findOne({'product_id': productId});

      if (product != null) {
        setState(() {
          productName = product['name'];
          productPrice = product['price'].toDouble();
        });
      } else {
        setState(() {
          productName = '';
          productPrice = 0.0;
        });
        showSnackbar('❌ Product ID not found', isSuccess: false);
      }
    } catch (e) {
      showSnackbar('❌ Error: $e', isSuccess: false);
    }
  }

  void addToBill() {
    if (productIdController.text.isEmpty ||
        quantityController.text.isEmpty ||
        productName.isEmpty) {
      showSnackbar('⚠️ Please enter all details', isSuccess: false);
      return;
    }

    int quantity = int.parse(quantityController.text);
    setState(() {
      billItems.add({
        'id': productIdController.text,
        'name': productName,
        'quantity': quantity,
        'price': productPrice,
      });
      productIdController.clear();
      quantityController.clear();
      productName = '';
      productPrice = 0.0;
    });
  }

  Future<void> calculateTotalBill() async {
    var collection = await MongoDatabase.getCollection();

    for (var item in billItems) {
      int productId = int.parse(item['id']);
      int purchasedQuantity = item['quantity'];

      var product = await collection.findOne({'product_id': productId});
      if (product != null && product['quantity'] >= purchasedQuantity) {
        int updatedQuantity = product['quantity'] - purchasedQuantity;

        await collection.updateOne(
          {'product_id': productId},
          {
            '\$set': {'quantity': updatedQuantity}
          },
        );
      } else {
        showSnackbar('⚠️ Not enough stock for Product ID: $productId',
            isSuccess: false);
        return;
      }
    }

    setState(() {
      totalBillAmount = billItems.fold(
          0, (sum, item) => sum + (item['quantity'] * item['price']));
    });
    showSnackbar('✅ Bill generated & stock updated!', isSuccess: true);
  }

  void clearBill() {
    setState(() {
      billItems.clear();
      totalBillAmount = 0.0;
    });
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
        title: const Text('Billing Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: productIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Product ID',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => fetchProductDetails(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    controller: TextEditingController(text: productName),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                        text: productPrice > 0
                            ? '₹${productPrice.toStringAsFixed(2)}'
                            : ''),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: addToBill,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text('Add',
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: calculateTotalBill,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent),
                        child: const Text('Bill',
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: clearBill,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Clear',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Qty')),
                          DataColumn(label: Text('Price')),
                        ],
                        rows: billItems.map((item) {
                          return DataRow(cells: [
                            DataCell(Text(item['id'])),
                            DataCell(Text(item['name'])),
                            DataCell(Text(item['quantity'].toString())),
                            DataCell(Text('₹${item['price']}')),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                  Text('Total Bill: ₹${totalBillAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
