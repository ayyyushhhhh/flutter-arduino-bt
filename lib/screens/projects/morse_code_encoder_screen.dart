import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter/material.dart';

import '../../Bloc/bluetooth_bloc.dart';
import '../bluetooth_list_screen.dart';

class MorseCodeEncoderScreen extends StatefulWidget {
  final BluetoothClassic connection;
  const MorseCodeEncoderScreen({super.key, required this.connection});

  @override
  State<MorseCodeEncoderScreen> createState() => _MorseCodeEncoderScreenState();
}

class _MorseCodeEncoderScreenState extends State<MorseCodeEncoderScreen> {
  final BluetoothBloc _btValBloc = BluetoothBloc();
  final TextEditingController textEditingController = TextEditingController();
  _sendData(String data) async {
    await widget.connection.write(data);
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

  void _onDataReceived(Uint8List data) {
    // print('Data incoming: ${ascii.decode(data)}');

    final value = ascii.decode(data);

    _btValBloc.updateValue(value);
  }

  @override
  void initState() {
    super.initState();

    // _connection = widget.connection;
    try {
      widget.connection.onDeviceDataReceived().listen((Uint8List data) {
        _onDataReceived(data);
      });
    } catch (e) {
      debugPrint("Error Connecting");
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {
                  disconnect();
                },
                icon: const Icon(Icons.bluetooth_disabled),
              ),
            ),
            const Center(
              child: Text(
                "Text to Morse Convertor",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: TextField(
                maxLength: 10,
                controller: textEditingController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  fillColor: const Color(0xFFEBEBEB),
                  filled: true,
                  hintText: "Enter your text",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _sendData(
                  textEditingController.text,
                );
                textEditingController.clear();
              },
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: const Center(
                    child: Text(
                  "Convert",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
