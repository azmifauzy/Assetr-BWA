import 'dart:convert';

import 'package:assetr/config/app_colors.dart';
import 'package:assetr/config/app_formats.dart';
import 'package:assetr/data/sources/source_history.dart';
import 'package:assetr/presentation/controllers/AddHistoryController.dart';
import 'package:assetr/presentation/controllers/UserController.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddHistoryPage extends StatelessWidget {
  final user = Get.put(UserController());
  final addHistoryController = Get.put(AddHistoryController());
  final controllerName = TextEditingController();
  final controllerPrice = TextEditingController();

  addHistory() async {
    bool success = await SourceHistory.add(
      user.data.id.toString(),
      addHistoryController.date,
      addHistoryController.type,
      jsonEncode(addHistoryController.items),
      addHistoryController.total.toString(),
    );
    if (success) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        Get.back(result: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft("Tambah Baru"),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Tanggal",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                return Text(addHistoryController.date);
              }),
              DView.spaceWidth(),
              ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? result = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023, 01, 01),
                        lastDate: DateTime(DateTime.now().year + 1));
                    if (result != null) {
                      addHistoryController
                          .setDate(DateFormat('yyyy-MM-dd').format(result));
                    }
                  },
                  icon: Icon(Icons.event),
                  label: Text("Pilih")),
            ],
          ),
          DView.spaceHeight(),
          const Text(
            "Tipe",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DView.spaceHeight(8),
          Obx(() {
            return DropdownButtonFormField(
              value: addHistoryController.type,
              items: ['Pemasukan', 'Pengeluaran'].map((e) {
                return DropdownMenuItem(
                  child: Text(e),
                  value: e,
                );
              }).toList(),
              onChanged: (value) {
                addHistoryController.setType(value);
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), isDense: true),
            );
          }),
          DView.spaceHeight(),
          DInput(
            controller: controllerName,
            hint: 'ex: Gaji, Omset',
            title: 'Judul',
          ),
          DView.spaceHeight(),
          DInput(
            controller: controllerPrice,
            hint: 'Nominal',
            title: 'Nominal',
            inputType: TextInputType.number,
          ),
          DView.spaceHeight(),
          ElevatedButton(
              onPressed: () {
                addHistoryController.addItem({
                  'name': controllerName.text,
                  'price': controllerPrice.text,
                });
                controllerName.clear();
                controllerPrice.clear();
              },
              child: Text("Tambah ke Items")),
          DView.spaceHeight(30),
          Center(
            child: Container(
              width: 80,
              height: 5,
              decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          DView.spaceHeight(30),
          const Text(
            "Items",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DView.spaceHeight(8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey)),
            child: GetBuilder<AddHistoryController>(builder: (_) {
              return Wrap(
                runSpacing: 8,
                spacing: 8,
                children: List.generate(_.items.length, (index) {
                  return Chip(
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(side: BorderSide()),
                    label: Text(_.items[index]['name']),
                    deleteIcon: const Icon(Icons.clear),
                    onDeleted: () => _.deleteItem(index),
                  );
                }),
              );
            }),
          ),
          DView.spaceHeight(),
          Row(
            children: [
              const Text(
                "Total : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DView.spaceWidth(),
              Obx(() {
                return Text(
                    AppFormats.currency(addHistoryController.total.toString()),
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor));
              })
            ],
          ),
          DView.spaceHeight(30),
          Material(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => addHistory(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Simpan",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
