import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void printDatabasePath() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'store.db');
  print('Ruta de la base de datos: $path');
}
