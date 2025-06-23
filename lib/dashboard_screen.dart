import 'package:flutter/material.dart';
import 'models.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Trading Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Trading Dashboard Coming Soon...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
