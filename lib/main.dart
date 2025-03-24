import 'package:flutter/material.dart';
import 'package:intl/intl_standalone.dart'; // Add this import
import 'package:intl/date_symbol_data_local.dart'; // Add this import
import 'layout/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
    'id',
    null,
  ); // Initialize date formatting for the 'id' locale
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}