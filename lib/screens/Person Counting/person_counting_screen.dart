import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arduino/screens/Person%20Counting/bluetooth_list_screen.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class PersonCountingScreeen extends StatefulWidget {
  final BluetoothConnection connection;
  const PersonCountingScreeen({super.key, required this.connection});

  @override
  State<PersonCountingScreeen> createState() => _PersonCountingScreeenState();
}

class _PersonCountingScreeenState extends State<PersonCountingScreeen> {
  BluetoothConnection? _connection;
  final _data = [];

  @override
  void initState() {
    super.initState();
    try {
      // _connection = widget.connection;
      // _connection!.input!.listen(_onDataReceived).onDone(() {
      //   print('Disconnecting locally!');

      //   if (mounted) {
      //     setState(() {});
      //   }
      // });
    } catch (e) {}
  }

  void _onDataReceived(Uint8List data) {
    print('Data incoming: ${ascii.decode(data)}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Person Counting Screen"),
        actions: [
          IconButton(
              onPressed: () {
                if (widget.connection.isConnected) {
                  widget.connection.finish();
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: ((context) {
                    return const BluetoothDiscoveryScreen();
                  })));
                }
              },
              icon: const Icon(
                Icons.bluetooth_disabled,
              ))
        ],
      ),
      body: Column(
        children: [
          IconButton(
            iconSize: 40,
            onPressed: () async {
              widget.connection.output
                  .add(Uint8List.fromList(utf8.encode("Hi")));
              await widget.connection.output.allSent;
            },
            icon: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 10,
          ),
          // StreamBuilder<Uint8List>(
          //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //     if (snapshot.hasData) {
          //       final data = snapshot.data as Uint8List;

          //       return Text(ascii.decode(data));
          //     }
          //     return Text("No data");
          //   },
          // )
          // ],
        ],
      ),
    );
  }
}
