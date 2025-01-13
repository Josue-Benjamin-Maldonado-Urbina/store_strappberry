import 'database_helper.dart';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  static const String usersTable = 'users';
  static const String productsTable = 'products';

  /// Registra un nuevo usuario en la base de datos.
  Future<int?> registerUser(String username, String password, bool isAdmin) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert(usersTable, {
        'username': username,
        'password': password,
        'isAdmin': isAdmin ? 1 : 0,
      });
    } catch (e) {
      print('Error al registrar usuario: $e');
      return null;
    }
  }

  /// Verifica las credenciales de inicio de sesión.
  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        usersTable,
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );
      print('Resultado de la consulta de login: $result');
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Error en loginUser: $e');
      return null;
    }
  }

  /// Lista todos los usuarios registrados.
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final db = await _dbHelper.database;
      return await db.query(usersTable);
    } catch (e) {
      print('Error al obtener usuarios: $e');
      return [];
    }
  }

  /// Elimina un usuario específico basado en su ID.
  Future<int?> deleteUser(int userId) async {
    try {
      final db = await _dbHelper.database;
      return await db.delete(
        usersTable,
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print('Error al eliminar usuario: $e');
      return null;
    }
  }

  /// Actualiza la información de un usuario.
  Future<int?> updateUser(int userId, String username, String password, bool isAdmin) async {
    try {
      final db = await _dbHelper.database;
      return await db.update(
        usersTable,
        {
          'username': username,
          'password': password,
          'isAdmin': isAdmin ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print('Error al actualizar usuario: $e');
      return null;
    }
  }

  /// Agrega un producto a la base de datos.
  Future<int?> addProduct(String name, double price, String category, String description, String? image) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert(productsTable, {
        'name': name,
        'price': price,
        'category': category,
        'description': description,
        'image': image,
      });
    } catch (e) {
      print('Error al agregar producto: $e');
      return null;
    }
  }

  /// Obtiene todos los productos.
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final db = await _dbHelper.database;
      return await db.query(productsTable);
    } catch (e) {
      print('Error al obtener productos: $e');
      return [];
    }
  }

  /// Elimina un producto por su ID.
  Future<int?> deleteProduct(int productId) async {
    try {
      final db = await _dbHelper.database;
      return await db.delete(
        productsTable,
        where: 'id = ?',
        whereArgs: [productId],
      );
    } catch (e) {
      print('Error al eliminar producto: $e');
      return null;
    }
  }

  /// Actualiza un producto existente.
  Future<int?> updateProduct(int productId, String name, double price, String category, String description, String? image) async {
    try {
      final db = await _dbHelper.database;
      return await db.update(
        productsTable,
        {
          'name': name,
          'price': price,
          'category': category,
          'description': description,
          'image': image,
        },
        where: 'id = ?',
        whereArgs: [productId],
      );
    } catch (e) {
      print('Error al actualizar producto: $e');
      return null;
    }
  }

  /// Imprime todos los usuarios para depuración.
  Future<void> printAllUsers() async {
    try {
      final db = await _dbHelper.database;
      final users = await db.query(usersTable);
      for (var user in users) {
        print('Usuario: $user');
      }
    } catch (e) {
      print('Error al imprimir usuarios: $e');
    }
  }

  /// Imprime todos los productos para depuración.
  Future<void> printAllProducts() async {
    try {
      final db = await _dbHelper.database;
      final products = await db.query(productsTable);
      for (var product in products) {
        print('Producto: $product');
      }
    } catch (e) {
      print('Error al imprimir productos: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    try {
      final db = await _dbHelper.database;
      return await db.query('products');
    } catch (e) {
      print('Error al obtener productos: $e');
      return [];
    }
  }

  
}
