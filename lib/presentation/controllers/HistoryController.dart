import 'package:assetr/data/models/history.dart';
import 'package:assetr/data/sources/source_history.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _list = <History>[].obs;
  List<History> get list => _list.value;

  getList(userId) async {
    _loading.value = true;
    update();

    _list.value = await SourceHistory.histories(userId);
    update();

    _loading.value = false;
    update();
  }

  historySearch(userId, date) async {
    _loading.value = true;
    update();

    _list.value = await SourceHistory.historySearch(userId, date);
    update();

    _loading.value = false;
    update();
  }
}
