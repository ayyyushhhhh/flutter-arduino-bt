import 'package:flutter/material.dart';
import 'package:flutter_arduino/screens/Person%20Counting/bluetooth_list_screen.dart';
import 'package:flutter_arduino/screens/Person%20Counting/person_counting_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BluetoothDiscoveryScreen(),
    );
  }
}
