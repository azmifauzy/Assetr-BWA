import 'package:assetr/config/api.dart';
import 'package:assetr/config/app_requests.dart';
import 'package:assetr/data/models/history.dart';
import 'package:d_info/d_info.dart';

class SourceHistory {
  static Future<Map> getHistory(String userId) async {
    String url = Api.analytics;
    Map? responseBody = await AppRequests.posts(url, {'id': userId});
    if (responseBody == null) return {};

    if (responseBody['meta']['code'] != 200) return {};

    return responseBody['data'];
  }

  static Future<bool> add(String idUser, String date, String type,
      String details, String total) async {
    String url = Api.addHistory;
    Map? responseBody = await AppRequests.posts(url, {
      'user_id': idUser,
      'date': date,
      'type': type,
      'details': details,
      'total': total,
    });

    if (responseBody!['meta']['code'] != 200) return false;

    if (responseBody['meta']['code'] == 200) {
      DInfo.dialogSuccess('Berhasil Tambah History');
      DInfo.closeDialog();
    } else {
      if (responseBody['message'] == 'date') {
        DInfo.dialogError(
            'History dengan tanggal tersebut sudah pernah dibuat');
      } else {
        DInfo.dialogError('Gagal Tambah History');
      }
      DInfo.closeDialog();
    }

    return responseBody['meta']['code'] == 200 ? true : false;
  }

  static Future<List<History>> incomeOutcome(String userId, String type) async {
    String url = Api.history + '/show';
    Map? responseBody =
        await AppRequests.posts(url, {'id': userId, 'type': type});
    if (responseBody == null) return [];

    if (responseBody['meta']['code'] != 200) return [];

    List list = responseBody['data']['data'];
    return list.map((e) => History.fromJson(e)).toList();
  }

  static Future<List<History>> incomeOutcomeSearch(
      String userId, String type, String date) async {
    String url = Api.history + '/show';
    Map? responseBody = await AppRequests.posts(
        url, {'id': userId, 'type': type, 'date': date});
    if (responseBody == null) return [];

    if (responseBody['meta']['code'] != 200) return [];

    List list = responseBody['data']['data'];
    return list.map((e) => History.fromJson(e)).toList();
  }
}
