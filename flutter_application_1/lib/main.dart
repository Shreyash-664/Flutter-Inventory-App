import 'package:flutter/material.dart';
import 'add_product_page.dart';
import 'update_product_page.dart';
import 'bill_page.dart';
import 'delete_product_page.dart';
import 'product_list_page.dart';
import 'contact_us_page.dart'; // Import the new Contact Us page

void main() {
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InventoryDashboard(),
    );
  }
}

class InventoryDashboard extends StatelessWidget {
  const InventoryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
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
                  child:
                      Icon(Icons.inventory, size: 40, color: Colors.blueAccent),
                ),
                const SizedBox(height: 8),
                const Text(
                  'My Inventory',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'ABC Shop',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  _buildGridTile(Icons.receipt_long, 'Bill', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BillPage()),
                    );
                  }),
                  _buildGridTile(Icons.add, 'Add', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddProductPage()),
                    );
                  }),
                  _buildGridTile(Icons.edit, 'Update', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UpdateProductPage()),
                    );
                  }),
                  _buildGridTile(Icons.list, 'Products', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductListPage()),
                    );
                  }),
                  _buildGridTile(Icons.delete, 'Delete', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DeleteProductPage()),
                    );
                  }),
                  _buildGridTile(Icons.settings, 'Settings', () {}),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Inventory Management System by ABC',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactUsPage()),
                    );
                  },
                  backgroundColor: Colors.pinkAccent,
                  child: const Icon(Icons.email),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 35, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
