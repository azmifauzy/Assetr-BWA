import 'package:assetr/config/app_assets.dart';
import 'package:assetr/config/app_colors.dart';
import 'package:assetr/config/app_formats.dart';
import 'package:assetr/config/session.dart';
import 'package:assetr/presentation/controllers/HomeController.dart';
import 'package:assetr/presentation/controllers/UserController.dart';
import 'package:assetr/presentation/pages/auth/login_page.dart';
import 'package:assetr/presentation/pages/history/add_history_page.dart';
import 'package:assetr/presentation/pages/history/detail_history_page.dart';
import 'package:assetr/presentation/pages/history/history_page.dart';
import 'package:assetr/presentation/pages/history/income_outcome_page.dart';
import 'package:d_chart/d_chart.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = Get.put(UserController());
  final home = Get.put(HomeController());

  @override
  void initState() {
    home.getAnalytics(user.data.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Padding(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 30),
        child: Row(
          children: [
            Image.asset(AppAssets.profile),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hai,",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Obx(() {
                    return Text(
                      user.data.name ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                ],
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Builder(builder: (ctx) {
              return Material(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.chartColor,
                child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Scaffold.of(ctx).openEndDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.menu,
                        color: AppColors.primaryColor,
                      ),
                    )),
              );
            })
          ],
        ),
      );
    }

    Widget cardToday() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Text(
              home.spentToday != 0
                  ? "Pengeluaran Hari Ini"
                  : "Pengeluaran Kemarin",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            );
          }),
          DView.spaceHeight(),
          Material(
            borderRadius: BorderRadius.circular(12),
            elevation: 4,
            color: AppColors.primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
                  child: Obx(() {
                    return Text(
                        AppFormats.currency(home.spentToday != 0
                            ? home.spentToday.toString()
                            : home.spentYesterday.toString()),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryColor));
                  }),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 30),
                  child: Obx(() {
                    return Text(
                      home.todayPercent,
                      style: TextStyle(
                          color: AppColors.backgroundColor, fontSize: 16),
                    );
                  }),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => DetailHistoryPage(
                          userId: user.data.id.toString(),
                          id: home.todayDataId.toString(),
                        ));
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          "Selengkapnya",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: AppColors.primaryColor,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }

    Widget barChart() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pengeluaran Minggu Ini",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Obx(() {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: DChartBar(
                data: [
                  {
                    'id': 'Bar',
                    'data':
                        List.generate(home.keysPastSevenDays.length, (index) {
                      return {
                        'domain': home.keysPastSevenDays[index],
                        'measure': home.valuesPastSevenDays[index]
                      };
                    }),
                  },
                ],
                domainLabelPaddingToAxisLine: 16,
                axisLineTick: 2,
                axisLinePointTick: 2,
                axisLinePointWidth: 10,
                axisLineColor: AppColors.primaryColor,
                measureLabelPaddingToAxisLine: 16,
                barColor: (barData, index, id) => AppColors.primaryColor,
                showBarValue: true,
              ),
            );
          }),
        ],
      );
    }

    Widget donutChart() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Perbandingan Bulan Ini",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                child: Obx(() {
                  return Stack(
                    children: [
                      DChartPie(
                        data: [
                          {'domain': 'Pemasukan', 'measure': home.monthIncome},
                          {
                            'domain': 'Pengeluaran',
                            'measure': home.monthOutcome
                          },
                          if (home.monthIncome == 0 && home.monthOutcome == 0)
                            {'domain': 'Nol', 'measure': 1},
                        ],
                        fillColor: (pieData, index) {
                          switch (pieData['domain']) {
                            case "Pemasukan":
                              return AppColors.primaryColor;
                              break;
                            case "Pengeluaran":
                              return AppColors.chartColor;
                              break;
                            default:
                              return AppColors.backgroundColor.withOpacity(0.5);
                          }
                        },
                        donutWidth: 20,
                        labelColor: Colors.white,
                      ),
                      Obx(() {
                        return Center(
                            child: Text(
                          "${home.percentIncome}%",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: AppColors.primaryColor),
                        ));
                      }),
                    ],
                  );
                }),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 16,
                        width: 16,
                        color: AppColors.primaryColor,
                      ),
                      DView.spaceWidth(8),
                      const Text("Pemasukan")
                    ],
                  ),
                  DView.spaceHeight(8),
                  Row(
                    children: [
                      Container(
                        height: 16,
                        width: 16,
                        color: AppColors.backgroundColor,
                      ),
                      DView.spaceWidth(8),
                      const Text("Pengeluaran")
                    ],
                  ),
                  DView.spaceHeight(20),
                  Obx(() {
                    return Text(home.monthPercent);
                  }),
                  DView.spaceHeight(10),
                  const Text("Atau setara : "),
                  Obx(() {
                    return Text(
                      AppFormats.currency(home.differentMonth.toString()),
                      style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    );
                  })
                ],
              )
            ],
          ),
        ],
      );
    }

    Widget drawer() {
      return Drawer(
        child: ListView(
          children: [
            // drawer header
            DrawerHeader(
                margin: const EdgeInsets.only(bottom: 0),
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(AppAssets.profile),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.data.name ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                              DView.spaceHeight(3),
                              Obx(() {
                                return Text(
                                  user.data.email ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                  overflow: TextOverflow.ellipsis,
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            ListTile(
              onTap: () {
                Get.to(() => AddHistoryPage())?.then((value) {
                  if (value ?? false) {
                    home.getAnalytics(user.data.id.toString());
                  }
                });
              },
              leading: const Icon(Icons.add),
              horizontalTitleGap: 0,
              title: const Text("Tambah Baru"),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () {
                Get.to(() => const IncomeOutcomePage(
                      type: 'Pemasukan',
                    ));
              },
              leading: const Icon(Icons.south_west),
              horizontalTitleGap: 0,
              title: const Text("Pemasukan"),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () {
                Get.to(() => const IncomeOutcomePage(
                      type: 'Pengeluaran',
                    ));
              },
              leading: const Icon(Icons.north_east),
              horizontalTitleGap: 0,
              title: const Text("Pengeluaran"),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () {
                Get.to(() => const HistoryPage());
              },
              leading: const Icon(Icons.history),
              horizontalTitleGap: 0,
              title: const Text("Riwayat"),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () {
                Session.deleteUser();
                Get.off(() => const LoginPage());
              },
              leading: const Icon(Icons.logout),
              horizontalTitleGap: 0,
              title: const Text("Keluar"),
              trailing: const Icon(Icons.navigate_next),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      endDrawer: drawer(),
      body: Column(
        children: [
          header(),
          Expanded(
              child: ListView(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
            children: [
              cardToday(),
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
              barChart(),
              DView.spaceHeight(30),
              donutChart()
            ],
          ))
        ],
      ),
    );
  }
}
