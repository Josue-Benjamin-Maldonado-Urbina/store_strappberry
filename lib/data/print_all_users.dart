import 'package:shopping_car/data/database_helper.dart';

void printAllUsers() async {
  final db = await DatabaseHelper().database;
  final users = await db.query('users');

  for (var user in users) {
    print('Usuario: $user');
  }
}
