import 'dart:io';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(List<Map<String, dynamic>>) onCartUpdated;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onCartUpdated,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> _cartItemsWithCount;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _cartItemsWithCount = widget.cartItems
        .map((item) => {...item, 'count': item['count'] ?? 1})
        .toList();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _calculateTotal() {
    return _cartItemsWithCount.fold(
      0.0,
      (total, item) => total + (item['price'] * item['count']),
    );
  }

  void _incrementCount(int index) {
    setState(() {
      _cartItemsWithCount[index]['count']++;
    });
    widget.onCartUpdated(_cartItemsWithCount);
  }

  void _decrementCount(int index) {
    setState(() {
      if (_cartItemsWithCount[index]['count'] > 1) {
        _cartItemsWithCount[index]['count']--;
      } else {
        _cartItemsWithCount.removeAt(index);
      }
    });
    widget.onCartUpdated(_cartItemsWithCount);
  }

  Future<void> _handlePurchase() async {
    await _animationController.forward();

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _cartItemsWithCount.clear();
    });
    widget.onCartUpdated([]);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi carrito'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _cartItemsWithCount.isEmpty
                ? const Center(
                    child: Text(
                      'Tu carrito está vacío.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _cartItemsWithCount.length,
                    itemBuilder: (context, index) {
                      final item = _cartItemsWithCount[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                if (item['image'] != null)
                                  Image.file(
                                    File(item['image']),
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )
                                else
                                  const Icon(
                                    Icons.image_not_supported,
                                    size: 70,
                                  ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '\$${item['price'].toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => _decrementCount(index),
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Text(
                                      '${item['count']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      onPressed: () => _incrementCount(index),
                                      icon: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_calculateTotal().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cartItemsWithCount.isEmpty
                        ? null
                        : _handlePurchase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF353C59),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 + _animationController.value * 0.1,
                          child: child,
                        );
                      },
                      child: const Text(
                        'Comprar ahora',
                        style: TextStyle(
                          color: Color(0xFFF0F1F5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
