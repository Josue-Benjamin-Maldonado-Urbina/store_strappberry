import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido, Administrador',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para gestionar productos, usuarios, etc.
              },
              child: Text('Gestionar Productos'),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para gestionar pedidos, etc.
              },
              child: Text('Gestionar Pedidos'),
            ),
          ],
        ),
      ),
    );
  }
}
