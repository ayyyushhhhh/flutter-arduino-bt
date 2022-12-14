import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arduino/Bloc/bluetooth_bloc.dart';
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

  final BluetoothBloc _btValBloc = BluetoothBloc();
  @override
  void initState() {
    super.initState();

    try {
      _connection = widget.connection;
      _connection!.input!.listen(_onDataReceived).onDone(() {
        debugPrint('Disconnecting locally!');
      });
    } catch (e) {
      debugPrint("Error Connecting");
      debugPrint(e.toString());
    }
  }

  void _onDataReceived(Uint8List data) {
    // print('Data incoming: ${ascii.decode(data)}');

    final value = ascii.decode(data);
    _btValBloc.updateValue(value);
  }

  @override
  void dispose() {
    super.dispose();
    _btValBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      // appBar: AppBar(
      //   title: const Text("Person Counting Screen"),
      //   actions: [

      //     // IconButton(
      //     //   iconSize: 40,
      //     //   onPressed: () async {
      //     //     widget.connection.output
      //     //         .add(Uint8List.fromList(utf8.encode("Hi")));
      //     //     await widget.connection.output.allSent;
      //     //   },
      //     //   icon: const Icon(Icons.add),
      //     // ),
      //   ],
      // ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onLongPress: () {
                    if (widget.connection.isConnected) {
                      widget.connection.finish();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: ((context) {
                        return const BluetoothDiscoveryScreen();
                      })));
                    }
                  },
                  child: const Icon(
                    Icons.bluetooth_disabled,
                    size: 30,
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.deepOrangeAccent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(color: Colors.black, blurRadius: 20),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text("Total Attendees Today",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                  Center(
                    child: StreamBuilder<String>(
                      stream: _btValBloc.btStream,
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          final value = snapshot.data;
                          return Text(
                            value.toString(),
                            style: const TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          );
                        }
                        return const Text(
                          "0",
                          style: TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
