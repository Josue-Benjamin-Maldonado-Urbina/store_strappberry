import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showProductDetails(context, product);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              child: product['image'] != null && product['image'].isNotEmpty
                  ? Image.network(
                      product['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 50),
                    )
                  : const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Text('\$${product['price']}'),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (product['image'] != null && product['image'].isNotEmpty)
                Image.network(product['image'], errorBuilder:
                    (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 100);
                }),
              const SizedBox(height: 10),
              Text('Precio: \$${product['price']}'),
              const SizedBox(height: 10),
              Text('Descripción: ${product['description']}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
