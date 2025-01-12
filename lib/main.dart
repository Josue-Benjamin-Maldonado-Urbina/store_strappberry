import 'package:flutter/material.dart';
import 'package:shopping_car/data/print_all_users.dart';
import 'package:shopping_car/presentation/pages/admin_page.dart';
import 'package:shopping_car/presentation/pages/pre.dart';
import 'package:shopping_car/presentation/pages/register_page.dart';
import 'presentation/pages/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  printAllUsers();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrApp Store',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/admin': (context) => AdminPage(),
        '/customer': (context) => Scaffold(body: Center(child: Text('Customer Page'))),
      },
    );
  }
}
