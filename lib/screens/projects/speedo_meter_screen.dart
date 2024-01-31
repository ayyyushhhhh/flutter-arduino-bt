import 'dart:typed_data';

import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arduino/Bloc/bluetooth_bloc.dart';
// import 'package:flutter_arduino/Bloc/bluetooth_bloc.dart';
import 'package:flutter_arduino/screens/bluetooth_list_screen.dart';
import 'package:flutter_arduino/widget/speedo_meter_widget.dart';

class SpeedoMeterScreen extends StatefulWidget {
  const SpeedoMeterScreen({super.key, required this.connection});
  final BluetoothClassic connection;

  @override
  State<SpeedoMeterScreen> createState() => _SpeedoMeterScreenState();
}

class _SpeedoMeterScreenState extends State<SpeedoMeterScreen> {
  // BluetoothClassic? _connection;
  final BluetoothBloc _btValBloc = BluetoothBloc();
  @override
  void initState() {
    super.initState();
    // try {
    //   widget.connection.onDeviceDataReceived().listen((Uint8List data) {
    //     _onDataReceived(data);
    //   })
    //     ..onData((data) async {
    //       print(data);
    //       // print("error");
    //       // await disconnect();
    //     })
    //     ..onError((e) async {
    //       await disconnect();
    //     });
    // } catch (e) {
    //   debugPrint("Error Connecting");
    //   debugPrint(e.toString());
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _btValBloc.dispose();
  }

  // void _onDataReceived(Uint8List data) {
  //   String value = String.fromCharCodes(data);

  //   _btValBloc.updateValue(value);
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(
                  Icons.bluetooth_disabled_outlined,
                  size: 40,
                ),
                color: Colors.white,
                onPressed: () async {
                  await disconnect();
                },
              ),
            ),
            StreamBuilder<Uint8List>(
              stream: widget.connection.onDeviceDataReceived(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  final value = snapshot.data as Uint8List;

                  return Speedometer(
                    gaugeBegin: 0,
                    gaugeEnd: 20,
                    velocity: double.tryParse(
                          String.fromCharCodes(value),
                        ) ??
                        0.0,
                    velocityUnit: "m/s",
                  );
                }
                return const Speedometer(
                  gaugeBegin: 0,
                  gaugeEnd: 100,
                  velocity: 0,
                  velocityUnit: "m/s",
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
// const Speedometer(
//               gaugeBegin: 0,
//               gaugeEnd: 50,
//               velocity: 20,
//               velocityUnit: "m/s",
//             )