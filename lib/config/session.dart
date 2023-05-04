import 'dart:convert';

import 'package:assetr/data/models/user.dart';
import 'package:assetr/presentation/controllers/UserController.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Future<bool> saveUser(User user) async {
    final pref = await SharedPreferences.getInstance();
    Map<String, dynamic> mapUser = user.toJson();
    String stringUser = jsonEncode(mapUser);
    bool result = await pref.setString('user', stringUser);

    if (result) {
      final cUser = Get.put(UserController());
      cUser.setData(user);
    }

    return result;
  }

  static Future<User> getUser() async {
    User user = User();
    final pref = await SharedPreferences.getInstance();
    String? stringUser = pref.getString('user');
    if (stringUser != null) {
      Map<String, dynamic> mapUser = jsonDecode(stringUser);
      user = User.fromJson(mapUser);
    }
    final cUser = Get.put(UserController());
    cUser.setData(user);
    return user;
  }

  static Future<bool> deleteUser() async {
    final pref = await SharedPreferences.getInstance();
    bool result = await pref.remove('user');
    final cUser = Get.put(UserController());
    cUser.setData(User());
    return result;
  }
}
