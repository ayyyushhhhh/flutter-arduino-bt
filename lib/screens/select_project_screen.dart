import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter/material.dart';

import 'package:flutter_arduino/screens/projects/morse_code_encoder_screen.dart';
import 'package:flutter_arduino/screens/projects/person_counting_screen.dart';
import 'package:flutter_arduino/screens/projects/door_lock_bt.dart';
import 'package:flutter_arduino/screens/projects/speedo_meter_screen.dart';

class SelectProjectScreen extends StatelessWidget {
  final BluetoothClassic connection;
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
                    return VisitorCounterScreen(connection: connection);
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
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(
          //         builder: (BuildContext context) {
          //           return TemperatureMonitor(connection: connection);
          //         },
          //       ),
          //     );
          //   },
          //   title: const Text("Temperature Monitor"),
          //   leading: const Icon(Icons.thermostat_auto),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(
          //         builder: (BuildContext context) {
          //           return HomeAutomationScreen(connection: connection);
          //         },
          //       ),
          //     );
          //   },
          //   title: const Text("Home Automation"),
          //   leading: const Icon(Icons.home),
          // ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MorseCodeEncoderScreen(connection: connection);
                  },
                ),
              );
            },
            title: const Text("Morse Encoder"),
            leading: const Icon(Icons.message),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SpeedoMeterScreen(connection: connection);
                  },
                ),
              );
            },
            title: const Text("Speedometer"),
            leading: const Icon(Icons.speed),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(
          //         builder: (BuildContext context) {
          //           return MorseCodeEncoderScreen(connection: connection);
          //         },
          //       ),
          //     );
          //   },
          //   title: const Text("Android Bot"),
          //   leading: const Icon(Icons.car_repair),
          // ),
        ],
      ),
    );
  }
}
