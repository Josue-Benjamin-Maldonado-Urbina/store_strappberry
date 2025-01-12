import 'database_helper.dart';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Registra un nuevo usuario en la base de datos.
  /// [isAdmin] debe ser `true` para usuarios administradores.
  Future<int> registerUser(String username, String password, bool isAdmin) async {
    final db = await _dbHelper.database;

    // Inserta el usuario en la tabla 'users'
    return await db.insert('users', {
      'username': username,
      'password': password,
      'isAdmin': isAdmin ? 1 : 0, // 1 para admin, 0 para cliente
    });
  }

  /// Verifica las credenciales de inicio de sesión.
  /// Devuelve un mapa con los datos del usuario si las credenciales son correctas.
  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
  final db = await _dbHelper.database;

  // Realiza la consulta para buscar el usuario
  final result = await db.query(
    'users',
    where: 'username = ? AND password = ?',
    whereArgs: [username, password],
  );

  // Imprime el resultado para depuración
  print('Resultado de la consulta: $result');

  return result.isNotEmpty ? result.first : null;
}

  /// Lista todos los usuarios registrados en la base de datos.
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await _dbHelper.database;

    // Consulta SQL para obtener todos los usuarios
    return await db.query('users');
  }

  /// Elimina un usuario específico basado en su ID.
  Future<int> deleteUser(int userId) async {
    final db = await _dbHelper.database;

    // Elimina el usuario de la tabla 'users'
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Actualiza la información de un usuario.
  Future<int> updateUser(int userId, String username, String password, bool isAdmin) async {
    final db = await _dbHelper.database;

    // Actualiza los datos del usuario
    return await db.update(
      'users',
      {
        'username': username,
        'password': password,
        'isAdmin': isAdmin ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}

void printAllUsers() async {
  final db = await DatabaseHelper().database;
  final users = await db.query('users');

  for (var user in users) {
    print('Usuario: $user');
  }
}
