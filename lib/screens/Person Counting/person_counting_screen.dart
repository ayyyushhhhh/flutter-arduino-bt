import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class PersonCountingScreeen extends StatefulWidget {
  final BluetoothConnection connection;
  PersonCountingScreeen({super.key, required this.connection});

  @override
  State<PersonCountingScreeen> createState() => _PersonCountingScreeenState();
}

class _PersonCountingScreeenState extends State<PersonCountingScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Uint8List>(
        stream: widget.connection.input,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final data = snapshot.data as Uint8List;
            print('Data incoming: ${ascii.decode(data)}');
            return Center(
              child: Text(
                ascii.decode(data),
              ),
            );
          }
          return const Center(
            child: Text("No data"),
          );
        }),
      ),
    );
  }
}
