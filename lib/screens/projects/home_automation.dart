// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_arduino/screens/bluetooth_list_screen.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// class HomeAutomationScreen extends StatefulWidget {
//   final BluetoothClassic connection;
//   const HomeAutomationScreen({super.key, required this.connection});

//   @override
//   State<HomeAutomationScreen> createState() => _HomeAutomationScreenState();
// }

// class _HomeAutomationScreenState extends State<HomeAutomationScreen> {
//   BluetoothClassic? _connection;

//   bool light = false;
//   bool fan = false;

//   _sendCommand(String command) async {
//     _connection?.output.add(Uint8List.fromList(utf8.encode(command)));
//     await _connection!.output.allSent;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _connection = widget.connection;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.tealAccent,
//       body: Column(
//         // ignore: prefer_const_literals_to_create_immutables
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: InkWell(
//                     onLongPress: () {
//                       if (_connection!.isConnected) {
//                         _connection!.finish();
//                         Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(
//                             builder: ((context) {
//                               return const BluetoothDiscoveryScreen();
//                             }),
//                           ),
//                         );
//                       }
//                     },
//                     child: const Icon(
//                       Icons.bluetooth_disabled,
//                       color: Colors.blue,
//                       size: 40,
//                     ),
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Text(
//                     "Home Automation",
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                       fontSize: 40,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const Divider(
//                   height: 5,
//                   color: Colors.black,
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: StatefulBuilder(
//               builder: (BuildContext context,
//                   void Function(void Function()) setState) {
//                 return Column(
//                   children: [
//                     ListTile(
//                       tileColor: Colors.white70,
//                       title: const Text(
//                         "Light",
//                         style: TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                       shape: RoundedRectangleBorder(
//                         side: const BorderSide(color: Colors.black, width: 1),
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       leading: CircleAvatar(
//                         radius: 20,
//                         child: Image.asset(
//                           "assets/images/light.png",
//                           height: 30,
//                         ),
//                       ),
//                       trailing: CupertinoSwitch(
//                         value: light,
//                         onChanged: (value) {
//                           setState(() {
//                             if (value == true) {
//                               _sendCommand("LightOff");
//                             } else if (value == false) {
//                               _sendCommand("LightOn");
//                             }

//                             light = value;
//                           });
//                         },
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     ListTile(
//                       tileColor: Colors.white70,
//                       title: const Text(
//                         "Fan",
//                         style: TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                       shape: RoundedRectangleBorder(
//                         side: const BorderSide(color: Colors.black, width: 1),
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       leading: CircleAvatar(
//                         radius: 20,
//                         child: Image.asset(
//                           "assets/images/fan.png",
//                           height: 30,
//                         ),
//                       ),
//                       trailing: CupertinoSwitch(
//                         value: fan,
//                         onChanged: (value) {
//                           setState(() {
//                             if (value == true) {
//                               _sendCommand("FanOff");
//                             } else if (value == false) {
//                               _sendCommand("FanOn");
//                             }
//                             fan = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           const SizedBox(
//             height: 40,
//           ),
//         ],
//       ),
//     );
//   }
// }
