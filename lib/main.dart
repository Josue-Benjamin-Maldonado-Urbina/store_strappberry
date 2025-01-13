import 'package:flutter/material.dart';
import 'package:shopping_car/presentation/pages/admin_page.dart';
import 'package:shopping_car/presentation/pages/customer_page.dart';
import 'package:shopping_car/presentation/pages/product_list_page.dart';
import 'package:shopping_car/presentation/pages/register_page.dart';
import 'presentation/pages/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StrApp Store',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/admin': (context) => ProductListPage(),
        '/customer': (context) => const CustomerPage(username: 'jUAN',),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
