import 'dart:convert';

import 'package:assetr/config/app_colors.dart';
import 'package:assetr/config/app_formats.dart';
import 'package:assetr/presentation/controllers/DetailHistoryController.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class DetailHistoryPage extends StatefulWidget {
  const DetailHistoryPage({super.key, required this.id, required this.userId});

  final String id;
  final String userId;

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  final detailHistoryController = Get.put(DetailHistoryController());

  @override
  void initState() {
    detailHistoryController.getData(widget.userId, widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Obx(() {
          if (detailHistoryController.data.date == null) return DView.nothing();

          return Row(
            children: [
              Expanded(
                child: Text(detailHistoryController.data.date == null
                    ? ''
                    : AppFormats.date(detailHistoryController.data.date)),
              ),
              detailHistoryController.data.type == "Pemasukan"
                  ? Icon(
                      Icons.south_west,
                      color: Colors.green[800],
                    )
                  : Icon(
                      Icons.north_east,
                      color: Colors.red[800],
                    ),
              DView.spaceWidth()
            ],
          );
        }),
      ),
      body: GetBuilder<DetailHistoryController>(builder: (_) {
        if (_.data.id == "") return DView.nothing();
        List details = jsonDecode(_.data.details);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text("Total",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.primaryColor.withOpacity(0.6))),
            ),
            DView.spaceHeight(8),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Text(AppFormats.currency(_.data.total),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryColor)),
            ),
            DView.spaceHeight(20),
            Center(
              child: Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            DView.spaceHeight(20),
            Expanded(
              child: ListView.separated(
                itemCount: details.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  Map item = details[index];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          "${index + 1}.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                        DView.spaceWidth(8),
                        Expanded(
                            child: Text(item['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18))),
                        Text(AppFormats.currency(item['price']),
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18))
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }
}
