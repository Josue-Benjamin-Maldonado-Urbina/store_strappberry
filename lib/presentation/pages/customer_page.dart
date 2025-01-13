import 'dart:io';
import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'product_details_page.dart';
import 'package:shopping_car/data/user_repository.dart';

class CustomerPage extends StatefulWidget {
  final String username;

  const CustomerPage({super.key, required this.username});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final UserRepository _userRepository = UserRepository();
  late Future<List<Map<String, dynamic>>> _productsFuture;
  List<Map<String, dynamic>> _cartItems = [];
  List<Map<String, dynamic>> _favoriteItems = [];
  int _selectedIndex = 0;
  String _selectedCategory = 'Todos';
  final List<String> _categories = [
    'Todos',
    'Teléfonos',
    'Computadoras',
    'Ropa',
    'Limpieza',
    'Otros'
  ];

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
  }

  Future<List<Map<String, dynamic>>> _loadProducts() async {
    return await _userRepository.getProducts();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToCart(Map<String, dynamic> product) {
    final existingProduct = _cartItems.firstWhere(
      (item) => item['id'] == product['id'],
      orElse: () => {},
    );

    if (existingProduct.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'El producto "${product['name']}" ya ha sido añadido al carrito.'),
        ),
      );
    } else {
      setState(() {
        _cartItems.add({...product, 'count': 1});
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product['name']} añadido al carrito.')),
      );
    }
  }

  void _toggleFavorite(Map<String, dynamic> product) {
    setState(() {
      if (_favoriteItems.any((item) => item['id'] == product['id'])) {
        _favoriteItems.removeWhere((item) => item['id'] == product['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product['name']} eliminado de favoritos.')),
        );
      } else {
        _favoriteItems.add(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product['name']} añadido a favoritos.')),
        );
      }
    });
  }

  void _updateCart(List<Map<String, dynamic>> updatedCartItems) {
    setState(() {
      _cartItems = updatedCartItems;
    });
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final isFavorite =
        _favoriteItems.any((item) => item['id'] == product['id']);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              product: product,
              onAddToCart: _addToCart,
              onAddToFavorites: _toggleFavorite,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: product['image'] != null && product['image'].isNotEmpty
                      ? Image.file(
                          File(product['image']),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : const Icon(Icons.image_not_supported, size: 50),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\$${product['price'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () => _toggleFavorite(product),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: Text(
            'Hola, ${widget.username}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 8, right: 16),
          child: Text(
            '¿Vamos a comprar algo?',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(
                    child: Text('Error al cargar los productos.'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay productos.'));
              }

              final products = snapshot.data!;
              final filteredProducts = _selectedCategory == 'Todos'
                  ? products
                  : _selectedCategory == 'Otros'
                      ? products
                          .where((product) =>
                              !_categories.contains(product['category']))
                          .toList()
                      : products
                          .where((product) =>
                              product['category'] == _selectedCategory)
                          .toList();

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return _buildProductCard(product);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesPage() {
    return _favoriteItems.isEmpty
        ? const Center(
            child: Text(
              'No tienes productos en favoritos.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _favoriteItems.length,
            itemBuilder: (context, index) {
              final item = _favoriteItems[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: item['image'] != null
                      ? Image.file(
                          File(item['image']),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(item['name']),
                  subtitle: Text('\$${item['price'].toStringAsFixed(2)}'),
                ),
              );
            },
          );
  }

  Widget _buildUserPage() {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF353C59),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          },
          child: const Text(
            'Cerrar sesión',
            style: TextStyle(
              color: Color(0xFFF0F1F5),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_buildHomePage(), _buildFavoritesPage(), _buildUserPage()];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        cartItems: _cartItems,
                        onCartUpdated: _updateCart,
                      ),
                    ),
                  );
                },
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_cartItems.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuario',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
