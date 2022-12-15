import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_arduino/Bloc/bluetooth_bloc.dart';
import 'package:flutter_arduino/widgets/temperature_circle.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class TemperatureMonitor extends StatefulWidget {
  const TemperatureMonitor({super.key, required this.connection});
  final BluetoothConnection connection;

  @override
  State<TemperatureMonitor> createState() => _TemperatureMonitorState();
}

class _TemperatureMonitorState extends State<TemperatureMonitor> {
  BluetoothConnection? _connection;
  final BluetoothBloc _btValBloc = BluetoothBloc();
  @override
  void initState() {
    super.initState();
    _connection = widget.connection;
    try {
      _connection!.input!.listen(_onDataReceived).onDone(() {
        debugPrint('Disconnecting locally!');
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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                Positioned(
                  right: -350,
                  bottom: 150,
                  child: Transform.rotate(
                    angle: -3.14 / 12,
                    child: Image.asset(
                      "assets/images/thermostat.png",
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "Living Room",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w200),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Thermostat",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: screenHeight / 3,
                      width: screenWidth,
                      margin: EdgeInsets.zero,
                      child: StreamBuilder<String>(
                        stream: _btValBloc.btStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            final value = snapshot.data as String;

                            return CustomPaint(
                              painter: TemperaturePainter(
                                  sensorTemp: double.parse(value),
                                  extremeTemp: 45),
                              child: Center(
                                child: Text(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  value + "\u00B0" "C",
                                  style: const TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }
                          return CustomPaint(
                            painter: TemperaturePainter(
                                sensorTemp: 36, extremeTemp: 45),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
