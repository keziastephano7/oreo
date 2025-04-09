import 'package:flutter/material.dart';

// Main entry point
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeData(
      primaryColor: Colors.teal,  // Primary color
      appBarTheme: AppBarTheme(
        color: Colors.teal,        // AppBar color
        foregroundColor: Colors.white,  // AppBar text color
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,  // Makes app responsive
    );

    return MaterialApp(
      theme: themeData,  // Applying the theme
      darkTheme: themeData,  // Dark theme option
      home: HomePage(),  // Home page
      debugShowCheckedModeBanner: false,  // Remove debug banner
    );
  }
}

// HomePage Widget
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const products = [
      {"name": "Clothes", "price": 49.99, "icon": Icons.checkroom},
      {"name": "Fruits", "price": 15.25, "icon": Icons.local_grocery_store},
      {"name": "Vegetables", "price": 10.00, "icon": Icons.grass},
      {"name": "Electronics", "price": 199.99, "icon": Icons.electrical_services},
      {"name": "Books", "price": 12.50, "icon": Icons.menu_book},
      {"name": "Toys", "price": 24.99, "icon": Icons.toys},
      {"name": "Shoes", "price": 59.99, "icon": Icons.directions_run},
      {"name": "Beauty Products", "price": 29.90, "icon": Icons.brush},
      {"name": "Fitness Gear", "price": 89.00, "icon": Icons.fitness_center},
      {"name": "Smartphones", "price": 499.99, "icon": Icons.phone_android},
      {"name": "Furniture", "price": 299.49, "icon": Icons.weekend},
      {"name": "Watches", "price": 149.99, "icon": Icons.watch},
    ];

    List<Map<String, Object>> cart = [];

    return Scaffold(
      appBar: AppBar(
        title: Text("ShopEase"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: [
            HeroFrame(),
            SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 0.8,
              children: products.map((product) {
                return InkWell(
                  onTap: () {
                    cart.add(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("✓ ${product["name"]} added to the cart!"),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  },
                  child: ProductCard(product: product),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(cart: cart),
                    ),
                  );
                },
                icon: Icon(Icons.shopping_cart_checkout),
                label: Text("Go to Cart"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// CartPage Widget
class CartPage extends StatelessWidget {
  final List<Map<String, Object>> cart;
  const CartPage({super.key, required this.cart});

  double getTotal() {
    return cart.fold(0.0, (total, item) {
      return total + (item['price'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Items You've Picked",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: cart.isEmpty
                        ? Center(
                      child: Text("Your cart is empty", style: TextStyle(fontSize: 16)),
                    )
                        : SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(Colors.teal.withOpacity(0.1)),
                        columns: const [
                          DataColumn(label: Text("Product")),
                          DataColumn(label: Text("Price")),
                        ],
                        rows: cart
                            .map((item) => DataRow(cells: [
                          DataCell(Text(item['name'].toString())),
                          DataCell(Text("\$${(item['price'] as double).toStringAsFixed(2)}")),
                        ]))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(thickness: 1.5),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Total: \$${getTotal().toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.teal[800]),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Checkout feature coming soon!"), backgroundColor: Colors.teal),
                  );
                },
                icon: Icon(Icons.shopping_bag),
                label: Text("Proceed to Checkout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// HeroFrame Widget
class HeroFrame extends StatelessWidget {
  const HeroFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 10,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 167, 215, 255),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage("images/bg.jpg"), // Make sure you have this image in the assets folder
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          "Welcome to ShopEase!\nFind the best deals and products just for you!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

// ProductCard Widget
class ProductCard extends StatelessWidget {
  final Map product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color.fromARGB(255, 255, 218, 106),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              product['icon'],
              size: 100,
              color: Colors.teal,
            ),
            SizedBox(height: 10),
            Text(
              product['name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 6),
            Text(
              "\$${product['price'].toStringAsFixed(2)}",
              style: TextStyle(color: Colors.green[700]),
            ),
          ],
        ),
      ),
    );
  }
}
