import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_arduino/screens/Person%20Counting/person_counting_screen.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothListScreen extends StatefulWidget {
  const BluetoothListScreen({super.key});

  @override
  State<BluetoothListScreen> createState() => _BluetoothListScreenState();
}

class _BluetoothListScreenState extends State<BluetoothListScreen> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;

  @override
  void initState() {
    super.initState();

    _startDiscovery();
    _btPermission();
  }

  _btPermission() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothAdvertise.request();
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() async {
    if (await Permission.bluetooth.isGranted) {
      _streamSubscription =
          FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
        setState(() {
          final existingIndex = results.indexWhere(
              (element) => element.device.address == r.device.address);
          if (existingIndex >= 0) {
            results[existingIndex] = r;
          } else {
            results.add(r);
          }
        });
      });

      _streamSubscription!.onDone(() {
        setState(() {
          isDiscovering = false;
        });
      });
    }
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Bluetooth"),
        actions: [
          IconButton(
              onPressed: () {
                _restartDiscovery();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: ListView.builder(
          itemCount: results.length,
          itemBuilder: ((context, index) {
            BluetoothDiscoveryResult result = results[index];
            final device = result.device;
            final address = device.address;
            return ListTile(
              onTap: () async {
                try {
                  BluetoothConnection connection =
                      await BluetoothConnection.toAddress(address);
                  print('Connected to the device');
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => PersonCountingScreen(
                            connection: connection,
                          )),
                    ),
                  );
                } catch (e) {
                  print('Cannot connect, exception occured');
                }
              },
              title: Text(
                device.name.toString(),
              ),
              subtitle: Text(address.toString()),
              leading: Image.asset("assets/images/bluetooth.png"),
            );
          })),
    );
  }
}
