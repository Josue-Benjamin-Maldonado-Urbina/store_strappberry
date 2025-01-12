import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// Inicializa la base de datos
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'store.db');

    return await openDatabase(
      path,
      version: 2, // Incrementa la versión si realizas cambios estructurales
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  /// Crea las tablas iniciales
  Future<void> _createTables(Database db, int version) async {
    // Tabla de usuarios
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      isAdmin INTEGER NOT NULL
    )
  ''');

    // Tabla de productos
    await db.execute('''
    CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      price REAL NOT NULL,
      category TEXT NOT NULL,
      description TEXT,
      image TEXT
    )
  ''');

    // Inserta el usuario administrador por defecto
    await db.insert('users', {
      'username': 'admin',
      'password': 'admin123',
      'isAdmin': 1, // Es administrador
    });
  }

  /// Maneja las migraciones cuando se actualiza la versión de la base de datos
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Crea una nueva tabla con la estructura correcta
      await db.execute('''
      CREATE TABLE products_new (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        image TEXT
      )
    ''');

      // Copia los datos de la tabla antigua a la nueva
      await db.execute('''
      INSERT INTO products_new (id, name, price, category, image)
      SELECT id, name, price, category, image
      FROM products
    ''');

      // Elimina la tabla antigua
      await db.execute('DROP TABLE products');

      // Renombra la tabla nueva a 'products'
      await db.execute('ALTER TABLE products_new RENAME TO products');
    }
    Future<Database> _initDB() async {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'store.db');

      return await openDatabase(
        path,
        version: 2, // Incrementa la versión si no lo has hecho antes
        onCreate: _createTables,
        onUpgrade: _onUpgrade,
      );
    }
  }
}
