import 'package:mongo_dart/mongo_dart.dart';

class DatabaseHelper {
  static var db, collection;
  static const String MONGO_URL = "mongodb://127.0.0.1:27017/inventory";
  static const String COLLECTION_NAME = "products";

  static Future<void> connect() async {
    db = await Db.create(MONGO_URL);
    await db.open();
    collection = db.collection(COLLECTION_NAME);
  }

  static Future<void> addProduct(
      String productId, String name, int quantity, double price) async {
    var newProduct = {
      "_id": productId,
      "name": name,
      "quantity": quantity,
      "price": price
    };

    await collection.insertOne(newProduct);
  }
}
