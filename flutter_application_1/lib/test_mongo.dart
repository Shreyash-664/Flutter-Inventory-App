import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  try {
    var db = await Db.create('mongodb://127.0.0.1:27017/nikita');
    await db.open();
    print('✅ Connected to MongoDB successfully!');
    await db.close();
  } catch (e) {
    print('❌ Connection failed: $e');
  }
}

// import 'package:flutter/material.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo;

// class AddProductPage extends StatefulWidget {
//   const AddProductPage({super.key});

//   @override
//   _AddProductPageState createState() => _AddProductPageState();
// }

// class _AddProductPageState extends State<AddProductPage> {
//   // MongoDB Connection String
//   final String mongoUri = "mongodb://localhost:27017/inventory"; // Change as needed
//   final String collectionName = "products"; // Collection name in MongoDB

//   // Controllers for form fields
//   final TextEditingController productIdController = TextEditingController();
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController quantityController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();

//   // Function to insert data into MongoDB
//   Future<void> addProductToDB() async {
//     try {
//       var db = await mongo.Db.create(mongoUri);
//       await db.open();
//       var collection = db.collection(collectionName);

//       // Create a document
//       var product = {
//         'product_id': int.parse(productIdController.text),
//         'name': productNameController.text,
//         'quantity': int.parse(quantityController.text),
//         'price': double.parse(priceController.text),
//       };

//       // Insert the document
//       await collection.insertOne(product);

//       // Close the database
//       await db.close();

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Product added successfully!')),
//       );

//       // Clear fields
//       productIdController.clear();
//       productNameController.clear();
//       quantityController.clear();
//       priceController.clear();
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to add product: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Product'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Column(
//         children: [
//           // Header Section
//           Container(
//             width: double.infinity,
//             height: 140,
//             padding: const EdgeInsets.all(12),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.blueAccent, Colors.deepPurple],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.add, size: 40, color: Colors.blueAccent),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'My Inventory',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 const Text(
//                   'ABC Shop',
//                   style: TextStyle(color: Colors.white70, fontSize: 14),
//                 ),
//               ],
//             ),
//           ),

//           // Form Section
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: productIdController,
//                     decoration: InputDecoration(
//                       labelText: 'Product ID',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 10),

//                   TextField(
//                     controller: productNameController,
//                     decoration: InputDecoration(
//                       labelText: 'Product Name',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   TextField(
//                     controller: quantityController,
//                     decoration: InputDecoration(
//                       labelText: 'Quantity',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 10),

//                   TextField(
//                     controller: priceController,
//                     decoration: InputDecoration(
//                       labelText: 'Price',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 20),

//                   ElevatedButton(
//                     onPressed: addProductToDB,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30, vertical: 15),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: const Text(
//                       'Add Product',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Footer Section
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//             child: Row(
//               children: [
//                 const Expanded(
//                   child: Text(
//                     'Inventory Management System by ABC',
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                   ),
//                 ),
//                 FloatingActionButton(
//                   onPressed: () {},
//                   backgroundColor: Colors.pinkAccent,
//                   child: const Icon(Icons.email),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'search_page.dart'; // Import the search page

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Homepage',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Store Inventory'),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(50.0),
//           child: Container(
//             color: Color.fromARGB(146, 68, 243, 255),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.home),
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Home button clicked!')),
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.search),
//                     onPressed: () {
//                       // Navigate to the SearchPage
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => SearchPage()),
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.account_circle),
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Account button clicked!')),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Center(
//         child: Text(
//           'Store Inventory Content Here',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const InventoryApp());
// }

// class InventoryApp extends StatelessWidget {
//   const InventoryApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: InventoryDashboard(),
//     );
//   }
// }

// class InventoryDashboard extends StatelessWidget {
//   const InventoryDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Inventory Management'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: SingleChildScrollView(
//         // Allow the entire body to scroll
//         child: Column(
//           children: [
//             // Reduced size and the box now scrolls with the content
//             Container(
//               width: double.infinity, // Full width
//               height: 150, // Set a height of 150
//               padding: const EdgeInsets.all(12), // Reduced padding
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.blueAccent, Colors.deepPurple],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment:
//                     MainAxisAlignment.center, // Center content vertically
//                 children: [
//                   const CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.white,
//                     child: Icon(Icons.inventory,
//                         size: 40, color: Colors.blueAccent),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'My Inventory',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const Text(
//                     'Your Name',
//                     style: TextStyle(color: Colors.white70, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//                 height: 20), // Add space between the container and grid
//             // Grid view below the container
//             GridView.count(
//               crossAxisCount: 2,
//               padding: const EdgeInsets.all(16),
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               shrinkWrap: true, // Allow GridView to shrink to fit content
//               physics:
//                   const NeverScrollableScrollPhysics(), // Disable GridView scrolling
//               children: [
//                 _buildGridTile(Icons.add, 'Add'),
//                 _buildGridTile(Icons.edit, 'Edit'),
//                 _buildGridTile(Icons.list, 'Products'),
//                 _buildGridTile(Icons.contacts, 'Contacts'),
//                 _buildGridTile(Icons.business, 'Suppliers'),
//                 _buildGridTile(Icons.people, 'Customers'),
//                 _buildGridTile(Icons.table_chart, 'Reports'),
//                 _buildGridTile(Icons.settings, 'Settings'),
//               ],
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: Colors.pinkAccent,
//         child: const Icon(Icons.email),
//       ),
//     );
//   }

//   Widget _buildGridTile(IconData icon, String title) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 4,
//       child: InkWell(
//         onTap: () {},
//         borderRadius: BorderRadius.circular(12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: Colors.blueAccent),
//             const SizedBox(height: 10),
//             Text(title,
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ),
//     );
//   }
// }