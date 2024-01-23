import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../Bloc/bluetooth_bloc.dart';
import '../bluetooth_list_screen.dart';

class MorseCodeEncoderScreen extends StatefulWidget {
  final BluetoothConnection connection;
  const MorseCodeEncoderScreen({super.key, required this.connection});

  @override
  State<MorseCodeEncoderScreen> createState() => _MorseCodeEncoderScreenState();
}

class _MorseCodeEncoderScreenState extends State<MorseCodeEncoderScreen> {
  BluetoothConnection? _connection;
  final BluetoothBloc _btValBloc = BluetoothBloc();
  final TextEditingController textEditingController = TextEditingController();
  _sendPassword(String password) async {
    _connection?.output.add(Uint8List.fromList(utf8.encode(password)));
    await widget.connection.output.allSent;
  }

  void _onDataReceived(Uint8List data) {
    // print('Data incoming: ${ascii.decode(data)}');

    final value = ascii.decode(data);

    _btValBloc.updateValue(value);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                _sendPassword(
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
