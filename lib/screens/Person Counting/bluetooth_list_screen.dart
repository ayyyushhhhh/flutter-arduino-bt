import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arduino/screens/Person%20Counting/person_counting_screen.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_arduino/models/UUIDs.dart';

import 'package:flutter_arduino/models/bluetooth_device.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:xunil_blue_connect/utils/status.dart';
import 'package:xunil_blue_connect/xunil_blue_connect.dart';

class BluetoothListScreen extends StatefulWidget {
  const BluetoothListScreen({super.key});

  @override
  State<BluetoothListScreen> createState() => _BluetoothListScreenState();
}

class _BluetoothListScreenState extends State<BluetoothListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Avaiable Devices'),
        ),
        body: const MainBody(),
      ),
    );
  }
}

class MainBody extends StatefulWidget {
  const MainBody({Key? key}) : super(key: key);

  @override
  State<MainBody> createState() => _BodyState();
}

class _BodyState extends State<MainBody> {
  bool _isBluetoothAvailable = false;
  List<BluetoothDeviceModel>? devices = [];
  bool isLoading = false;

  //call the class
  XunilBlueConnect blueConnect = XunilBlueConnect();

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  _checkPermission() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetooth,
      Permission.bluetoothConnect
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

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Bluetooth is ${_isBluetoothAvailable ? 'ON' : 'OFF'}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      _isBluetoothAvailable ? Colors.lightGreen : Colors.blue),
                ),
                onPressed: () async {
                  //call the function but as async
                  //but if function return null means the device doesn't support bluetooth
                  var isBlue = await blueConnect.isBluetoothAvailable();
                  setState(() {
                    _isBluetoothAvailable = isBlue;
                  });
                },
                child: const Text('Check Bluetooth'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
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
                },
                child: const Text('Start Discovery'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await blueConnect.stopDiscovery();
                  setState(() {
                    isLoading = false;
                  });
                },
                child: const Text('Stop Discovery'),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () async {
          //         //call the function but as async
          //         //bluetoothenable turn on
          //         await blueConnect.bluetoothSetEnable();
          //       },
          //       child: const Text('Set Bluetooth Enable'),
          //     ),
          //     ElevatedButton(
          //       onPressed: () async {
          //         //call the function but as async
          //         //bluetoothenable turn off
          //         await blueConnect.bluetoothSetDisable();
          //       },
          //       child: const Text('Set Bluetooth Disable'),
          //     )
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  var devices = await blueConnect.getPairedDevices();

                  print(devices);
                },
                child: const Text('Get paired devices'),
              )
            ],
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
                      (localAddress) => localAddress.address == device.address,
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
                                bottomsheetForUUIDS(devices![index].uuids);
                              },
                              onTap: () async {
                                try {
                                  // await blueConnect.connect(
                                  //   macAddress: devices![index].address!,
                                  // );
                                  final navigator = Navigator.of(context);
                                  BluetoothConnection connection =
                                      await BluetoothConnection.toAddress(
                                          devices![index].address!);
                                  print('Connected to the device');

                                  navigator.push(
                                    MaterialPageRoute(builder: (context) {
                                      return PersonCountingScreeen(
                                          connection: connection);
                                    }),
                                  );
                                } catch (e) {
                                  print('Error Connected to the device');
                                }
                              },
                              title: Text(
                                  "${devices![index].name!} (${devices![index].aliasName!})"),
                              subtitle: Text(devices![index].address!),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 30.0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.zero),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          devices![index].isPaired! == "PAIRED"
                                              ? Colors.lightGreen
                                              : Colors.blue,
                                        ),
                                      ),
                                      onPressed: () async {
                                        BluetoothConnection connection =
                                            await BluetoothConnection.toAddress(
                                                devices![index].address!);
                                        connection.input
                                            ?.listen((Uint8List data) {
                                          print(
                                              'Data incoming: ${ascii.decode(data)}');
                                          connection.output
                                              .add(data); // Sending data

                                          if (ascii
                                              .decode(data)
                                              .contains('!')) {
                                            connection
                                                .finish(); // Closing connection
                                            print(
                                                'Disconnecting by local host');
                                          }
                                        }).onDone(() {
                                          print(
                                              'Disconnected by remote request');
                                        });

                                        // await blueConnect.pair(
                                        //   macAddress: devices![index].address!,
                                        // );
                                      },
                                      child: Text(
                                        devices![index].isPaired! == "PAIRED"
                                            ? "C"
                                            : "P",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  if (devices![index].isPaired! == "PAIRED")
                                    SizedBox(
                                      width: 30.0,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.redAccent[400]),
                                        ),
                                        onPressed: () async {
                                          await blueConnect.disconnect();
                                        },
                                        child: const Text("D"),
                                      ),
                                    ),
                                  if (devices![index].isPaired! == "PAIRED")
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                  if (devices![index].isPaired! == "PAIRED")
                                    SizedBox(
                                      width: 30.0,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.blueGrey),
                                        ),
                                        onPressed: () async {
                                          await blueConnect.write(
                                            data:
                                                "World is something, like something, yeah i know",
                                            autoConnect: true,
                                          );
                                        },
                                        child: const Text("W"),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox();
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
