import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_car/data/user_repository.dart';

class AdminPage extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? product;

  const AdminPage({
    Key? key,
    required this.isEditing,
    this.product,
  }) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final UserRepository _userRepository = UserRepository();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Teléfonos';
  String? _imagePath;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.product != null) {
      _nameController.text = widget.product!['name'] ?? '';
      _priceController.text = widget.product!['price'].toString() ?? '';
      _descriptionController.text = widget.product!['description'] ?? '';
      _selectedCategory = widget.product!['category'] ?? 'Teléfonos';
      _imagePath = widget.product!['image'];
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveProduct() async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final description = _descriptionController.text.trim();

    if (name.isEmpty || price <= 0 || _selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    if (widget.isEditing && widget.product != null) {
      await _userRepository.updateProduct(
        widget.product!['id'],
        name,
        price,
        _selectedCategory,
        description,
        _imagePath,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto actualizado con éxito.')),
      );
    } else {
      await _userRepository.addProduct(
        name,
        price,
        _selectedCategory,
        description,
        _imagePath,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto añadido con éxito.')),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Editar producto' : 'Agregar producto',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF353C59),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EBF5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _imagePath != null
                    ? Image.file(
                        File(_imagePath!),
                        fit: BoxFit.cover,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 50,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Carga tu imagen',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                filled: true,
                fillColor: const Color(0xFFE8EBF5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Precio',
                filled: true,
                fillColor: const Color(0xFFE8EBF5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Categoría',
                filled: true,
                fillColor: const Color(0xFFE8EBF5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['Teléfonos', 'Computadoras', 'Ropa', 'Limpieza', 'Otros']
                  .map((category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Descripción',
                filled: true,
                fillColor: const Color(0xFFE8EBF5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF353C59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                widget.isEditing ? 'Actualizar producto' : 'Guardar producto',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
