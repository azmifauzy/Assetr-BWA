import 'package:assetr/config/app_colors.dart';
import 'package:assetr/config/app_formats.dart';
import 'package:assetr/data/models/history.dart';
import 'package:assetr/data/sources/source_history.dart';
import 'package:assetr/presentation/controllers/HistoryController.dart';
import 'package:assetr/presentation/controllers/IncomeOutcomeController.dart';
import 'package:assetr/presentation/controllers/UserController.dart';
import 'package:assetr/presentation/pages/history/detail_history_page.dart';
import 'package:assetr/presentation/pages/history/update_history_page.dart';
import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final historyController = Get.put(HistoryController());
  final user = Get.put(UserController());
  final controllerSearch = TextEditingController();

  refresh() {
    historyController.getList(user.data.id.toString());
  }

  delete(History history) async {
    bool? isDelete = await DInfo.dialogConfirmation(
        context, 'Hapus', 'Yakin ingin menghapus data?',
        textNo: 'Batal', textYes: 'Ya');

    if (isDelete!) {
      bool success = await SourceHistory.delete(history.id.toString());
      if (success) {
        refresh();
      }
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Text("Riwayat"),
            Expanded(
                child: Container(
              height: 40,
              margin: const EdgeInsets.all(16),
              child: TextField(
                controller: controllerSearch,
                onTap: () async {
                  DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023, 01, 01),
                      lastDate: DateTime(DateTime.now().year + 1));
                  if (result != null) {
                    controllerSearch.text =
                        DateFormat('yyyy-MM-dd').format(result);
                  }
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    hintText: '2023-05-03',
                    hintStyle: const TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                      onPressed: () {
                        historyController.historySearch(
                            user.data.id.toString(), controllerSearch.text);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    fillColor: AppColors.chartColor.withOpacity(0.5)),
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(color: Colors.white),
              ),
            ))
          ],
        ),
      ),
      body: GetBuilder<HistoryController>(builder: (_) {
        if (_.loading) return DView.loadingCircle();
        if (_.list.isEmpty) return DView.empty('Kosong');
        return RefreshIndicator(
          onRefresh: () async => refresh(),
          child: ListView.builder(
            itemCount: _.list.length,
            itemBuilder: (context, index) {
              History history = _.list[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                    index == _.list.length ? 16 : 8),
                child: InkWell(
                  onTap: () {
                    Get.to(() => DetailHistoryPage(
                          userId: user.data.id.toString(),
                          id: history.id.toString(),
                        ));
                  },
                  child: Row(
                    children: [
                      DView.spaceWidth(),
                      history.type == "Pemasukan"
                          ? const Icon(
                              Icons.south_west,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.north_east,
                              color: Colors.red,
                            ),
                      DView.spaceWidth(),
                      Text(
                        AppFormats.date(history.date),
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Expanded(
                          child: Text(
                        AppFormats.currency(history.total.toString()),
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        textAlign: TextAlign.end,
                      )),
                      IconButton(
                          onPressed: () => delete(history),
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
