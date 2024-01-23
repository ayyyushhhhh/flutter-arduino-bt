import 'dart:convert';

import 'package:flutter_arduino/models/buddy_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrencesHelper {
  static SharedPreferences? preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static void saveFriend(BuddyModel buddyModel) {
    preferences!.setString("buddy", jsonEncode(buddyModel));
  }

  static BuddyModel? getFriend() {
    final friendString = preferences!.getString("buddy");

    if (friendString == null) {
      return null;
    }

    BuddyModel friend = BuddyModel.fromMap(
        jsonDecode(jsonDecode(friendString)) as Map<String, dynamic>);
    return friend;
  }
}
