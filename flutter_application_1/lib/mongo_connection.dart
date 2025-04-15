import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static final MongoDatabase _instance = MongoDatabase._internal();
  static Db? _db;
  static DbCollection? _collection;

  factory MongoDatabase() => _instance;

  MongoDatabase._internal();

  static Future<void> connect() async {
    if (_db != null && _db!.isConnected) return; // Prevent multiple connections

    try {
      String mongoUrl =
          'mongodb://10.0.2.2:27017/nikita'; // ✅ Use 10.0.2.2 for Android emulator
      _db = Db(mongoUrl);
      await _db!.open();
      _collection = _db!.collection('products');
      print('✅ MongoDB Connected!');
    } catch (e) {
      print('❌ Connection Error: $e');
    }
  }

  static Future<DbCollection> getCollection() async {
    if (_db == null || _collection == null || !_db!.isConnected) {
      print('⚠️ Database not connected. Reconnecting...');
      await connect();
    }
    return _collection!;
  }

  static Future<void> close() async {
    await _db?.close();
    _db = null;
    _collection = null;
    print('🔌 MongoDB Connection Closed.');
  }
}
