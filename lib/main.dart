import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
