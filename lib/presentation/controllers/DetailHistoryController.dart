import 'dart:convert';

import 'package:assetr/data/models/history.dart';
import 'package:assetr/data/sources/source_history.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailHistoryController extends GetxController {
  // final _date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  // String get date => _date.value;
  // setDate(n) => _date.value = n;

  // final _type = 'Pemasukan'.obs;
  // String get type => _type.value;
  // setType(n) => _type.value = n;

  // final _items = [].obs;
  // List get items => _items.value;
  // addItem(n) {
  //   _items.value.add(n);
  //   count();
  // }

  // deleteItem(i) {
  //   _items.value.removeAt(i);
  //   count();
  // }

  // final _total = 0.0.obs;
  // double get total => _total.value;
  // setTotal(n) => _total.value = n;

  // count() {
  //   _total.value = items.map((e) => e['price']).toList().fold(0.0,
  //       (previousValue, element) {
  //     return double.parse(previousValue.toString()) + double.parse(element);
  //   });
  //   update();
  // }

  final _data = History(
          id: "",
          userId: "",
          type: "",
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          total: "0",
          details: "",
          createdAt: "",
          updatedAt: "")
      .obs;

  History get data => _data.value;

  getData(userId, id) async {
    History? history = await SourceHistory.whereId(userId, id);
    _data.value = history ?? data;
    update();
  }
}
