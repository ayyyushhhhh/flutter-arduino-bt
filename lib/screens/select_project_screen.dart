import 'package:flutter/material.dart';
import 'package:flutter_arduino/screens/projects/person_counting_screen.dart';
import 'package:flutter_arduino/screens/projects/door_lock_bt.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SelectProjectScreen extends StatelessWidget {
  final BluetoothConnection connection;
  const SelectProjectScreen({super.key, required this.connection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Project"),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return PersonCountingScreeen(connection: connection);
                  },
                ),
              );
            },
            title: const Text("Visitor Counter"),
            leading: const Icon(Icons.person),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Doorlock(connection: connection);
                  },
                ),
              );
            },
            title: const Text("BT Lock"),
            leading: const Icon(Icons.lock),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Doorlock(connection: connection);
                  },
                ),
              );
            },
            title: const Text("Temperature Monitor"),
            leading: const Icon(Icons.thermostat_auto),
          ),
        ],
      ),
    );
  }
}
