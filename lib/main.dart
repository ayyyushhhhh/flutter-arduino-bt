// import 'package:flutter/material.dart';
// import 'package:flutter_arduino/screens/Person%20Counting/bluetooth_list_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const BluetoothListScreen(),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_arduino/models/UUIDs.dart';
import 'package:flutter_arduino/models/bluetooth_device.dart';
import 'package:flutter_arduino/screens/Person%20Counting/bluetooth_list_screen.dart';
import 'package:xunil_blue_connect/xunil_blue_connect.dart';

import 'package:xunil_blue_connect/utils/status.dart';

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
      home: BluetoothListScreen(),
    );
  }
}
