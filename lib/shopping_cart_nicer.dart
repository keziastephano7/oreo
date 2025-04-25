import 'package:flutter/material.dart';

void main() => runApp(ShoppingApp());

class ShoppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
      ),
      home: ProductListPage(),
    );
  }
}

class Product {
  final String name;
  final String category;
  final double price;
  final String imageUrl;

  Product(
      {required this.name,
        required this.category,
        required this.price,
        required this.imageUrl});
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> allProducts = [
    Product(
        name: 'Shoes',
        category: 'Footwear',
        price: 59.99,
        imageUrl:
        'https://images.unsplash.com/photo-1605732440685-d0654d81aa30?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Product(
        name: 'T-Shirt',
        category: 'Clothing',
        price: 19.99,
        imageUrl:
        'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Product(
        name: 'Watch',
        category: 'Accessories',
        price: 120.0,
        imageUrl:
        'https://images.unsplash.com/photo-1615368144592-44708889c926?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Product(
        name: 'Backpack',
        category: 'Bags',
        price: 40.0,
        imageUrl:
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
  ];

  List<CartItem> cart = [];
  String searchQuery = '';

  void addToCart(Product product) {
    setState(() {
      final index =
      cart.indexWhere((item) => item.product.name == product.name);
      if (index != -1) {
        cart[index].quantity++;
      } else {
        cart.add(CartItem(product: product));
      }
    });
  }

  void goToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CartPage(cart: cart, onUpdateCart: updateCart)),
    );
  }

  void updateCart(List<CartItem> updatedCart) {
    setState(() {
      cart = updatedCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = allProducts
        .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: goToCartPage,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2 / 3,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      product.imageUrl,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text('\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.blue)),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => addToCart(product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Add to Cart'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final List<CartItem> cart;
  final Function(List<CartItem>) onUpdateCart;

  CartPage({required this.cart, required this.onUpdateCart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<CartItem> localCart;

  @override
  void initState() {
    super.initState();
    localCart = List.from(widget.cart);
  }

  double get total => localCart.fold(
      0, (sum, item) => sum + item.product.price * item.quantity);

  void removeItem(int index) {
    setState(() {
      localCart.removeAt(index);
    });
  }

  void updateQuantity(int index, int change) {
    setState(() {
      localCart[index].quantity += change;
      if (localCart[index].quantity <= 0) {
        localCart.removeAt(index);
      }
    });
  }

  void checkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          cartItems: localCart,
          total: total,
          onComplete: () {
            widget.onUpdateCart([]);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        actions: [
          TextButton(
            onPressed: checkout,
            child: Text('Checkout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: localCart.isEmpty
          ? Center(child: Text('Cart is empty'))
          : ListView.builder(
        itemCount: localCart.length,
        itemBuilder: (context, index) {
          final item = localCart[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(item.product.imageUrl, width: 50),
              ),
              title: Text(item.product.name),
              subtitle: Text('Quantity: ${item.quantity}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => updateQuantity(index, -1)),
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => updateQuantity(index, 1)),
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => removeItem(index)),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12),
        child: Text('Total: \$${total.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double total;
  final VoidCallback onComplete;

  CheckoutPage(
      {required this.cartItems, required this.total, required this.onComplete});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '', address = '';

  void confirmOrder() {
    if (_formKey.currentState!.validate()) {
      widget.onComplete();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Order Confirmed'),
          content: Text('Thank you for your purchase!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Total: \$${widget.total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                onChanged: (value) => name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) =>
                value!.isEmpty ? 'Enter your address' : null,
                onChanged: (value) => address = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: confirmOrder,
                child: Text('Confirm Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
