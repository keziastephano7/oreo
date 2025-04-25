import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures proper initialization for async calls
  runApp(MyApp());
}

class Product {
  final int? id;
  final String name;
  final double price;

  Product({this.id, required this.name, required this.price});

  // Convert a Product into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  // Extract a Product from a Map.
  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: map['price'] as double,
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  // Get the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'shopping.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL)',
        );
      },
      version: 1,
    );
  }

  // Insert a product
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  // Fetch all products
  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Update a product
  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Delete a product
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ShoppingPage(),
    );
  }
}

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _dbHelper = DatabaseHelper();

  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Load products from the database
  Future<void> _loadProducts() async {
    try {
      List<Product> products = await _dbHelper.getProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      print("Error loading products: $e");
    }
  }

  // Add a new product
  void _addProduct() async {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text);

    if (name.isNotEmpty && price != null) {
      final newProduct = Product(name: name, price: price);
      await _dbHelper.insertProduct(newProduct);
      _nameController.clear();
      _priceController.clear();
      _loadProducts();
    }
  }

  // Delete a product
  void _deleteProduct(int id) async {
    await _dbHelper.deleteProduct(id);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopping App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Product Price'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _products.isEmpty
                  ? Center(
                child: Text('No products available.'),
              )
                  : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteProduct(product.id!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// dependencies:
// flutter:
// sdk: flutter
// fl_chart: ^0.66.2
//
// # The following adds the Cupertino Icons font to your application.
// # Use with the CupertinoIcons class for iOS style icons.
// cupertino_icons: ^1.0.8
// sqflite: ^2.2.0
// path: ^1.8.3
//
// dev_dependencies:
// sqflite_common_ffi: ^2.0.0
// flutter_test:
// sdk: flutter
