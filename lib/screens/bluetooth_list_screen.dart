// import 'package:flutter/cupertino.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_arduino/screens/select_project_screen.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// import 'package:flutter_arduino/models/bluetooth_device.dart';
// import 'package:permission_handler/permission_handler.dart';

// class BluetoothDiscoveryScreen extends StatefulWidget {
//   const BluetoothDiscoveryScreen({super.key});

//   @override
//   State<BluetoothDiscoveryScreen> createState() =>
//       _BluetoothDiscoveryScreenState();
// }

// class _BluetoothDiscoveryScreenState extends State<BluetoothDiscoveryScreen> {
//   // bool _isBluetoothAvailable = false;
//   List<BluetoothDevice> pairedDevices = [];
//   bool isLoading = true;
//   BluetoothDeviceModel? selectedDevice;
//   final deviceslist = [];
//   BluetoothClassic? connection;
//   // late Stream<BluetoothDiscoveryResult> _resultStream;

//   //call the class

//   @override
//   void initState() {
//     super.initState();
//     _checkPermission();
//     // _resultStream = FlutterBluetoothSerial.instance.startDiscovery();
//   }

//   _checkPermission() async {
//     await [
//       Permission.bluetoothScan,
//       Permission.bluetooth,
//       Permission.bluetoothConnect,
//       Permission.bluetoothAdvertise,
//     ].request();
//   }

//   Future<void> getPairedDevices() async {
//     List<BluetoothDevice> devices =
//         await FlutterBluetoothSerial.instance.getBondedDevices();
//     pairedDevices = devices;
//   }

//   @override
//   Widget build(BuildContext context) {
//     getPairedDevices();
//     return SafeArea(
//       child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Connect a device'),
//             actions: [
//               IconButton(
//                 onPressed: () async {
//                   setState(() {});
//                 },
//                 icon: const Icon(Icons.refresh),
//               )
//             ],
//           ),
//           body: SizedBox(
//             height: MediaQuery.of(context).size.height * 0.85,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.all(10),
//                   padding: const EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                       color: Colors.white30,
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.black12)),
//                   child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: [
//                         const Text(
//                           "Bluetooth",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700, fontSize: 16),
//                         ),
//                         StatefulBuilder(
//                           builder: (BuildContext context,
//                               void Function(void Function()) setState) {
//                             return FutureBuilder<bool?>(
//                                 future:
//                                     FlutterBluetoothSerial.instance.isEnabled,
//                                 builder: ((context, snapshot) {
//                                   if (snapshot.hasData) {
//                                     final isBTOn = snapshot.data as bool;
//                                     return CupertinoSwitch(
//                                         value: isBTOn,
//                                         onChanged: ((value) async {
//                                           if (value == true) {
//                                             try {
//                                               await FlutterBluetoothSerial
//                                                   .instance
//                                                   .requestEnable();

//                                               // _resultStream =
//                                               //     FlutterBluetoothSerial
//                                               //         .instance
//                                               //         .startDiscovery();
//                                             } catch (e) {
//                                               debugPrint(e.toString());
//                                             }
//                                           } else {
//                                             await FlutterBluetoothSerial
//                                                 .instance
//                                                 .requestDisable();
//                                           }
//                                           setState(() {});
//                                         }));
//                                   }
//                                   return const SizedBox();
//                                 }));
//                           },
//                         ),
//                       ]),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: Align(
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       "Paired Devices",
//                       style:
//                           TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ),
//                 const LinearProgressIndicator(color: Colors.orangeAccent),
//                 if (pairedDevices.isEmpty)
//                   const Center(
//                     child: Text("No Paired Device found"),
//                   ),
//                 if (pairedDevices.isNotEmpty)
//                   Expanded(
//                       child: ListView.builder(
//                     itemCount: pairedDevices.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return ListTile(
//                         onTap: () async {
//                           final navigator = Navigator.of(context);
//                           // if (connection == null) {
//                           BluetoothClassic.toAddress(
//                                   deviceslist[index].device.address)
//                               .then((btconnection) {
//                             if (btconnection.isConnected) {
//                               navigator.push(
//                                 MaterialPageRoute(
//                                   builder: (BuildContext context) {
//                                     return SelectProjectScreen(
//                                         connection: btconnection);
//                                   },
//                                 ),
//                               );
//                             }
//                           }).catchError((error) {
//                             debugPrint(error);
//                           });
//                         },
//                         title: Text(deviceslist[index].device.name.toString()),
//                         subtitle: Text(deviceslist[index].device.address),
//                         trailing: IconButton(
//                           icon: const Icon(Icons.bluetooth_disabled),
//                           onPressed: () {
//                             if (connection != null && connection!.isConnected) {
//                               connection!.finish();
//                             }
//                           },
//                         ),
//                       );
//                     },
//                   ))
//                 // StreamBuilder<BluetoothDiscoveryResult>(
//                 //   stream: _resultStream,
//                 //   builder:
//                 //       (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                 //     if (snapshot.hasData) {
//                 //       final device = snapshot.data as BluetoothDiscoveryResult;

//                 //       if (!deviceslist.contains(device)) {
//                 //         deviceslist.add(device);
//                 //       }
//                 //       return Expanded(
//                 //         child: ListView.builder(
//                 //           itemCount: deviceslist.length,
//                 //           itemBuilder: (BuildContext context, int index) {
//                 //             return InkWell(
//                 //               onTap: () async {
//                 //                 final navigator = Navigator.of(context);
//                 //                 // if (connection == null) {
//                 //                 BluetoothClassic.toAddress(
//                 //                         deviceslist[index].device.address)
//                 //                     .then((btconnection) {
//                 //                   connection = btconnection;
//                 //                   navigator.push(
//                 //                     MaterialPageRoute(
//                 //                       builder: (BuildContext context) {
//                 //                         return SelectProjectScreen(
//                 //                             connection: connection!);
//                 //                       },
//                 //                     ),
//                 //                   );
//                 //                 }).catchError((error) {
//                 //                   debugPrint(error);
//                 //                 });
//                 //                 // }

//                 //                 // navigator.push(
//                 //                 //   MaterialPageRoute(
//                 //                 //     builder: (BuildContext context) {
//                 //                 //       return PersonCountingScreeen(
//                 //                 //           connection: connection!);
//                 //                 //     },
//                 //                 //   ),
//                 //                 // );
//                 //               },
//                 //               child: ListTile(
//                 //                 title: Text(
//                 //                     deviceslist[index].device.name.toString()),
//                 //                 subtitle:
//                 //                     Text(deviceslist[index].device.address),
//                 //                 trailing: IconButton(
//                 //                   icon: const Icon(Icons.bluetooth_disabled),
//                 //                   onPressed: () {
//                 //                     if (connection != null &&
//                 //                         connection!.isConnected) {
//                 //                       connection!.finish();
//                 //                     }
//                 //                   },
//                 //                 ),
//                 //               ),
//                 //             );
//                 //           },
//                 //         ),
//                 //       );
//                 //     }
//                 //     return const SizedBox();
//                 //   },
//                 // ),
//               ],
//             ),
//           )),
//     );
//   }
// }

import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arduino/screens/select_project_screen.dart';

class BluetoothDiscoveryScreen extends StatefulWidget {
  const BluetoothDiscoveryScreen({super.key});

  @override
  State<BluetoothDiscoveryScreen> createState() =>
      _BluetoothDiscoveryScreenState();
}

class _BluetoothDiscoveryScreenState extends State<BluetoothDiscoveryScreen> {
  final _bluetoothClassicPlugin = BluetoothClassic();

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    await _bluetoothClassicPlugin.initPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect a device'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Device>>(
              future: _bluetoothClassicPlugin.getPairedDevices(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  List<Device> devices = snapshot.data as List<Device>;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: devices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () async {
                          await _bluetoothClassicPlugin
                              .connect(devices[index].address,
                                  "00001101-0000-1000-8000-00805f9b34fb")
                              .then((value) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return SelectProjectScreen(
                                connection: _bluetoothClassicPlugin,
                              );
                            }));
                          });
                        },
                        title: Text(devices[index].name.toString()),
                        subtitle: Text(devices[index].address),
                      );
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
    );
  }
}
