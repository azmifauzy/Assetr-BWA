import 'package:assetr/config/api.dart';
import 'package:assetr/config/app_requests.dart';
import 'package:assetr/config/session.dart';
import 'package:assetr/data/models/user.dart';

class SourceUser {
  static Future<bool> login(String email, String password) async {
    String url = Api.login;
    Map? responseBody = await AppRequests.posts(url, {
      'email': email,
      'password': password,
    });
    if (responseBody == null) return false;

    if (responseBody['meta']['code'] == 200) {
      var mapUser = responseBody['data']['user'];
      Session.saveUser(User.fromJson(mapUser));
      return true;
    }

    return false;
  }

  static Future<bool> register(
      String name, String email, String password) async {
    String url = Api.register;
    Map? responseBody = await AppRequests.posts(url, {
      'name': name,
      'email': email,
      'password': password,
    });
    if (responseBody == null) return false;

    if (responseBody['meta']['code'] == 200) {
      var mapUser = responseBody['data'];
      Session.saveUser(User.fromJson(mapUser));
      return true;
    }

    return false;
  }
}
