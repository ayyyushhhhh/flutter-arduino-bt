import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_arduino/Bloc/bluetooth_bloc.dart';
import 'package:flutter_arduino/screens/bluetooth_list_screen.dart';
import 'package:flutter_arduino/widgets/concentric_container.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Doorlock extends StatefulWidget {
  final BluetoothConnection connection;
  const Doorlock({super.key, required this.connection});

  @override
  State<Doorlock> createState() => _DoorlockState();
}

class _DoorlockState extends State<Doorlock> {
  BluetoothConnection? _connection;

  final BluetoothBloc _btValBloc = BluetoothBloc();

  // Text editing controllers
  final TextEditingController _firstBox = TextEditingController();
  final TextEditingController _secondBox = TextEditingController();
  final TextEditingController _thirdBox = TextEditingController();
  final TextEditingController _forthBox = TextEditingController();

  _sendPassword(String password) async {
    _connection?.output.add(Uint8List.fromList(utf8.encode(password)));
    await widget.connection.output.allSent;
  }

  @override
  void initState() {
    super.initState();
    _connection = widget.connection;
    try {
      _connection!.input!.listen(_onDataReceived).onDone(() {
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
    // print('Data incoming: ${ascii.decode(data)}');

    final value = ascii.decode(data);

    _btValBloc.updateValue(value);
  }

  SizedBox _textFieldOTP(
      {required bool first,
      last,
      required TextEditingController editingController,
      required BuildContext context}) {
    return SizedBox(
      height: 70,
      width: 70,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: editingController,
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 2, color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  _showPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Enter Password",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _textFieldOTP(
                        first: true,
                        last: false,
                        editingController: _firstBox,
                        context: context),
                    _textFieldOTP(
                        first: false,
                        last: false,
                        editingController: _secondBox,
                        context: context),
                    _textFieldOTP(
                        first: false,
                        last: false,
                        editingController: _thirdBox,
                        context: context),
                    _textFieldOTP(
                        first: false,
                        last: true,
                        editingController: _forthBox,
                        context: context),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      String password = _firstBox.text +
                          _secondBox.text +
                          _thirdBox.text +
                          _forthBox.text;
                      _sendPassword(password);
                      _firstBox.clear();
                      _secondBox.clear();
                      _thirdBox.clear();
                      _forthBox.clear();
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueAccent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        'UNLOCK',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: ((context) {
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
            height: screenHeight / 3,
            width: screenWidth,
            margin: EdgeInsets.zero,
            child: CustomPaint(
                painter: ConcentricContainer(),
                child: StreamBuilder(
                  stream: _btValBloc.btStream,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data as String;
                      if (data == "1") {
                        return Center(
                          child: Center(
                            child: Image.asset(
                              "assets/images/unlock.png",
                              height: screenHeight / 7,
                            ),
                          ),
                        );
                      } else if (data == "0") {
                        return Center(
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                _showPasswordDialog(context);
                              },
                              child: Image.asset(
                                "assets/images/open-lock.png",
                                height: screenHeight / 7,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    return Center(
                      child: InkWell(
                        onTap: () {
                          _showPasswordDialog(context);
                        },
                        child: Center(
                          child: Image.asset(
                            "assets/images/open-lock.png",
                            height: screenHeight / 7,
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<String>(
            stream: _btValBloc.btStream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                final value = snapshot.data as String;
                if (value == "1") {
                  return const Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        "Door is Unlocked",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Welcome!",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w200),
                      ),
                    ],
                  );
                } else if (value == "0") {
                  return const Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        "Door is Locked",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Tap to Unlock",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w200),
                      ),
                    ],
                  );
                }
              }
              return const Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    "Door is Locked",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Tap to Unlock",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
