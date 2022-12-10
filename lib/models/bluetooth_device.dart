import 'dart:convert';

import 'package:flutter_arduino/models/UUIDs.dart';

class BluetoothDeviceModel {
  final String? name;
  final String? aliasName;
  final String? address;
  final String? isPaired;
  final String? type;
  final List<UUIDS> uuids;

  BluetoothDeviceModel(
      {this.name,
      this.aliasName,
      this.address,
      this.isPaired,
      this.type,
      required this.uuids});

  factory BluetoothDeviceModel.fromJson(Map<String, dynamic> json) =>
      BluetoothDeviceModel(
        name: json["name"].toString(),
        aliasName: json["aliasName"].toString(),
        address: json["address"].toString(),
        type: json["type"].toString(),
        isPaired: json["isPaired"].toString(),
        uuids: jsonDecode(json["uuids"]).isNotEmpty
            ? List<UUIDS>.from(
                jsonDecode(json["uuids"]).map(
                  (element) => UUIDS.fromJson(element),
                ),
              )
            : List<UUIDS>.from([]),
      );
}
