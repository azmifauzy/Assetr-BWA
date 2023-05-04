import 'package:assetr/data/models/history.dart';
import 'package:assetr/data/sources/source_history.dart';
import 'package:get/get.dart';

class IncomeOutcomeController extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _list = <History>[].obs;
  List<History> get list => _list.value;

  getList(userId, type) async {
    _loading.value = true;
    update();

    _list.value = await SourceHistory.incomeOutcome(userId, type);
    update();

    _loading.value = false;
    update();
  }

  search(userId, type, date) async {
    _loading.value = true;
    update();

    _list.value = await SourceHistory.incomeOutcomeSearch(userId, type, date);
    update();

    _loading.value = false;
    update();
  }
}
