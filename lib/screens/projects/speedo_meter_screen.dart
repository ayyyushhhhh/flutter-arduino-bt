import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_arduino/Bloc/bluetooth_bloc.dart';
import 'package:flutter_arduino/screens/bluetooth_list_screen.dart';
import 'package:flutter_arduino/widget/speedo_meter_widget.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SpeedoMeterScreen extends StatefulWidget {
  const SpeedoMeterScreen({super.key, required this.connection});
  final BluetoothConnection connection;

  @override
  State<SpeedoMeterScreen> createState() => _SpeedoMeterScreenState();
}

class _SpeedoMeterScreenState extends State<SpeedoMeterScreen> {
  BluetoothConnection? _connection;
  final BluetoothBloc _btValBloc = BluetoothBloc();
  @override
  void initState() {
    super.initState();
    _connection = widget.connection;
    try {
      _connection!.input!.listen(_onDataReceived).onDone(() {
        debugPrint('Disconnecting locally!');
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: ((context) {
          return const BluetoothDiscoveryScreen();
        })));
      });
    } catch (e) {
      debugPrint("Error Connecting");
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _btValBloc.dispose();
  }

  void _onDataReceived(Uint8List data) {
    final value = ascii.decode(data);
    _btValBloc.updateValue(value);
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
                onPressed: () {
                  if (widget.connection.isConnected) {
                    widget.connection.finish();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: ((context) {
                          return const BluetoothDiscoveryScreen();
                        }),
                      ),
                    );
                  }
                },
              ),
            ),
            StreamBuilder<String>(
              stream: _btValBloc.btStream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  final value = snapshot.data as String;
                  return Speedometer(
                    gaugeBegin: 0,
                    gaugeEnd: 50,
                    velocity: double.parse(value),
                    velocityUnit: "m/s",
                  );
                }
                return const Speedometer(
                  gaugeBegin: 0,
                  gaugeEnd: 50,
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