import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_arduino/screens/Person%20Counting/person_counting_screen.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_arduino/models/UUIDs.dart';

import 'package:flutter_arduino/models/bluetooth_device.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:xunil_blue_connect/utils/status.dart';
import 'package:xunil_blue_connect/xunil_blue_connect.dart';

class BluetoothDiscoveryScreen extends StatefulWidget {
  const BluetoothDiscoveryScreen({super.key});

  @override
  State<BluetoothDiscoveryScreen> createState() =>
      _BluetoothDiscoveryScreenState();
}

class _BluetoothDiscoveryScreenState extends State<BluetoothDiscoveryScreen> {
  bool _isBluetoothAvailable = false;
  List<BluetoothDeviceModel>? devices = [];
  bool isLoading = false;
  List<BluetoothDeviceModel>? pairedDevices = [];
  BluetoothConnection? connection;
  //call the class
  XunilBlueConnect blueConnect = XunilBlueConnect();

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _startDiscovery();
  }

  Future<void> _startDiscovery() async {
    if (await Permission.bluetoothScan.isGranted) {
      await blueConnect.startDiscovery();
      setState(() {
        isLoading = true;
      });
      Timer(const Duration(seconds: 13), () async {
        await blueConnect.stopDiscovery();
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  _checkPermission() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    bottomsheetForUUIDS(List<UUIDS>? uuids) {
      return showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.white,
        builder: (data) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: uuids?.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  style: ListTileStyle.list,
                  title: Text(
                    uuids![index].name!.toString(),
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    uuids[index].shortDescription!.toString(),
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  trailing: Text(
                    uuids[index].uuid!.toString(),
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Connect a device'),
            actions: [
              IconButton(
                  onPressed: _startDiscovery, icon: const Icon(Icons.refresh))
            ],
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12)),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Bluetooth",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        FutureBuilder<bool>(
                            future: blueConnect.isBluetoothAvailable(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                final isBTOn = snapshot.data as bool;
                                return CupertinoSwitch(
                                    value: isBTOn,
                                    onChanged: ((value) async {
                                      if (value == true) {
                                        await FlutterBluetoothSerial.instance
                                            .requestEnable();
                                      } else {
                                        await FlutterBluetoothSerial.instance
                                            .requestDisable();
                                      }
                                      setState(() {});
                                    }));
                              }
                              return const SizedBox();
                            })),
                      ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        var devices = await blueConnect.getPairedDevices();

                        print(devices);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                          color: Colors.white60,
                        ),
                        child: const Text(
                          'Get paired devices',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Available Devices",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                if (isLoading)
                  const LinearProgressIndicator(color: Colors.orangeAccent),
                StreamBuilder(
                  stream: blueConnect.listenStatus,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var STATUS = jsonDecode(snapshot.data as String);

                      //for status pairing
                      switch (STATUS['STATUS_PAIRING']) {
                        case PairedStatus.PAIRED:
                          print(PairedStatus.PAIRED);
                          break;
                        case PairedStatus.PAIRING:
                          print(PairedStatus.PAIRING);
                          break;
                        case PairedStatus.PAIRED_NONE:
                          print(PairedStatus.PAIRED_NONE);
                          break;
                        case PairedStatus.UNKNOWN_PAIRED:
                          print(PairedStatus.UNKNOWN_PAIRED);
                          break;
                      }

                      //for status connecting
                      switch (STATUS['STATUS_CONNECTING']) {
                        case ConnectingStatus.STATE_CONNECTED:
                          print(STATUS['MAC_ADDRESS']);
                          print(ConnectingStatus.STATE_CONNECTED);
                          break;
                        case ConnectingStatus.STATE_DISCONNECTED:
                          print(STATUS['MAC_ADDRESS']);
                          print(ConnectingStatus.STATE_DISCONNECTED);
                          break;
                      }

                      //for status discovery
                      switch (STATUS['STATUS_DISCOVERY']) {
                        case DiscoveryStatus.STARTED:
                          print(DiscoveryStatus.STARTED);
                          break;
                        case DiscoveryStatus.FINISHED:
                          print(DiscoveryStatus.FINISHED);
                          break;
                      }
                    }
                    return const SizedBox();
                  },
                ),
                StreamBuilder(
                  stream: blueConnect.listenDeviceResults,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var device = BluetoothDeviceModel.fromJson(
                          jsonDecode(snapshot.data as String));

                      bool isEmpty = devices!
                          .where(
                            (localAddress) =>
                                localAddress.address == device.address,
                          )
                          .isEmpty;

                      if (isEmpty) {
                        devices?.add(device);
                      }

                      return devices!.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: devices?.length,
                                padding: const EdgeInsets.all(10.0),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                      onLongPress: () {
                                        bottomsheetForUUIDS(
                                            devices![index].uuids);
                                      },
                                      onTap: () async {
                                        try {
                                          final navigator =
                                              Navigator.of(context);
                                          final scaffoldMessenger =
                                              ScaffoldMessenger.of(context);

                                          if (connection == null) {
                                            connection =
                                                await BluetoothConnection
                                                    .toAddress(devices![index]
                                                        .address!);

                                            const snackBar = SnackBar(
                                              content:
                                                  Text('Bluetooth Connected'),
                                            );
                                            scaffoldMessenger
                                                .showSnackBar(snackBar);

                                            navigator.pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return PersonCountingScreeen(
                                                    connection: connection!);
                                              }),
                                            );
                                          }
                                          if (connection!.isConnected) {
                                            const snackBar = SnackBar(
                                              content:
                                                  Text('Bluetooth Connected'),
                                            );
                                            scaffoldMessenger
                                                .showSnackBar(snackBar);

                                            navigator.pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return PersonCountingScreeen(
                                                    connection: connection!);
                                              }),
                                            );
                                          }
                                        } catch (e) {
                                          print(
                                              'Error Connected to the device');
                                        }
                                      },
                                      title: Text(
                                          "${devices![index].name!} (${devices![index].aliasName!})"),
                                      subtitle: Text(devices![index].address!),
                                      trailing: IconButton(
                                        onPressed: (() async {
                                          final scaffoldMessenger =
                                              ScaffoldMessenger.of(context);
                                          if (connection != null &&
                                              connection!.isConnected) {
                                            const snackBar = SnackBar(
                                              content: Text(
                                                  'Bluetooth disconnected'),
                                            );

                                            scaffoldMessenger
                                                .showSnackBar(snackBar);
                                            connection!.finish();
                                          }
                                        }),
                                        icon: const Icon(
                                            Icons.bluetooth_disabled),
                                      ));
                                },
                              ),
                            )
                          : const SizedBox(
                              child: Text("No Device available"),
                            );
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          )),
    );
  }
}
