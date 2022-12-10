import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class PersonCountingScreen extends StatefulWidget {
  BluetoothConnection connection;
  PersonCountingScreen({super.key, required this.connection});

  @override
  State<PersonCountingScreen> createState() => _PersonCountingScreenState();
}

class _PersonCountingScreenState extends State<PersonCountingScreen> {
  late BluetoothConnection connection;
  @override
  void initState() {
    super.initState();
    connection = widget.connection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // StreamBuilder<B>(
          //     stream: connection.output,
          //     builder: ((context, snapshot) {
          //       if (snapshot.hasData) {}
          //       return const Text("No Data Available");
          //     })),
        ],
      ),
    );
  }
}
