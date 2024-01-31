import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_arduino/screens/bluetooth_list_screen.dart';

class VisitorCounterScreen extends StatefulWidget {
  final BluetoothClassic connection;
  const VisitorCounterScreen({super.key, required this.connection});

  @override
  State<VisitorCounterScreen> createState() => _VisitorCounterScreenState();
}

class _VisitorCounterScreenState extends State<VisitorCounterScreen> {
  // final BluetoothBloc _btValBloc = BluetoothBloc();
  @override
  void initState() {
    super.initState();

    // widget.connection.onDeviceDataReceived().listen((data) {
    //   _onDataReceived(data);
    // }).onError((error) async {
    //   await disconnect();
    // });
  }

  Future disconnect() async {
    final navigator = Navigator.of(context);

    await widget.connection.disconnect();
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: ((context) {
          return const BluetoothDiscoveryScreen();
        }),
      ),
      (route) => false,
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _btValBloc.dispose();
  // }

  // void _onDataReceived(Uint8List data) {
  //   String value = String.fromCharCodes(data);
  //   _btValBloc.updateValue(value);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onLongPress: () async {
                    await disconnect();
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
                    child: StreamBuilder<Uint8List>(
                      stream: widget.connection.onDeviceDataReceived(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          final value = snapshot.data as Uint8List;
                          return Text(
                            String.fromCharCodes(value),
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
