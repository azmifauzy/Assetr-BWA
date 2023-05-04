import 'package:assetr/config/app_colors.dart';
import 'package:assetr/config/app_formats.dart';
import 'package:assetr/data/models/history.dart';
import 'package:assetr/presentation/controllers/IncomeOutcomeController.dart';
import 'package:assetr/presentation/controllers/UserController.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class IncomeOutcomePage extends StatefulWidget {
  const IncomeOutcomePage({super.key, required this.type});
  final String type;

  @override
  State<IncomeOutcomePage> createState() => _IncomeOutcomePageState();
}

class _IncomeOutcomePageState extends State<IncomeOutcomePage> {
  final inoutController = Get.put(IncomeOutcomeController());
  final user = Get.put(UserController());
  final controllerSearch = TextEditingController();

  refresh() {
    inoutController.getList(user.data.id.toString(), widget.type);
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
            Text(widget.type),
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
                        inoutController.search(user.data.id.toString(),
                            widget.type, controllerSearch.text);
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
      body: GetBuilder<IncomeOutcomeController>(builder: (_) {
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
                margin: EdgeInsets.fromLTRB(
                    16, index == 0 ? 16 : 8, 16, index == 9 ? 16 : 8),
                child: Row(
                  children: [
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
                    PopupMenuButton(
                      itemBuilder: (context) => [],
                      onSelected: (value) {},
                    )
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
