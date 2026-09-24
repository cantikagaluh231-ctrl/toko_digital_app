import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'toko_digital.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE master_products(
            id TEXT PRIMARY KEY,
            name TEXT,
            price REAL,
            description TEXT,
            imageUrl TEXT,
            category TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE local_cart(
            id TEXT PRIMARY KEY,
            product_id TEXT,
            name TEXT,
            price REAL,
            quantity INTEGER,
            imageUrl TEXT
          )
        ''');
      },
    );
  }

  // Operation CRUD Produk
  static Future<void> insertProduct(Product product) async {
    final db = await DBHelper.database;
    await db.insert('master_products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Product>> getProducts() async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('master_products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  // Operation CRUD Keranjang
  static Future<void> insertCartItem(CartItem item) async {
    final db = await DBHelper.database;
    await db.insert('local_cart', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<CartItem>> getCartItems() async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('local_cart');
    return List.generate(maps.length, (i) => CartItem.fromMap(maps[i]));
  }
}