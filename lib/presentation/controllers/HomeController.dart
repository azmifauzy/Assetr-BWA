import 'package:assetr/data/sources/source_history.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final _spentToday = 0.0.obs;
  double get spentToday => _spentToday.value;

  final _todayPercent = "0".obs;
  String get todayPercent => _todayPercent.value;

  final _percentIncome = '0'.obs;
  String get percentIncome => _percentIncome.value;

  final _monthPercent = "0".obs;
  String get monthPercent => _monthPercent.value;

  final _differentMonth = 0.0.obs;
  double get differentMonth => _differentMonth.value;

  final _monthIncome = 0.0.obs;
  double get monthIncome => _monthIncome.value;

  final _monthOutcome = 0.0.obs;
  double get monthOutcome => _monthOutcome.value;

  final _labelsMonthSummary = <String>["Pengeluaran", "Pemasukan"].obs;
  List<String> get labelsMonthSummary => _labelsMonthSummary.value;

  final _valuesMonthSummary = <int>[].obs;
  List<int> get valuesMonthSummary => _valuesMonthSummary.value;

  final _valuesPastSevenDays = <double>[].obs;
  List<double> get valuesPastSevenDays => _valuesPastSevenDays.value;

  final _keysPastSevenDays = <String>[].obs;
  List<String> get keysPastSevenDays => _keysPastSevenDays.value;

  getAnalytics(String userId) async {
    Map data = await SourceHistory.getHistory(userId);

    // Spent Today
    _spentToday.value = data["spent_today"].toDouble();

    // Today Percentage
    double yesterday = data["spent_yesterday"].toDouble();
    double different = (spentToday - yesterday).abs();
    bool isSame = spentToday.isEqual(yesterday);
    bool isPlus = spentToday.isGreaterThan(yesterday);
    double byYesterday = yesterday == 0 ? 1 : yesterday;
    double percent = (different / byYesterday) * 100;

    _todayPercent.value = isSame
        ? '100% Sama dengan kemarin.'
        : isPlus
            ? '+${percent.toStringAsFixed(1)}% dibanding kemarin.'
            : '-${percent.toStringAsFixed(1)}% dibanding kemarin.';

    // Values Month Summary
    _monthIncome.value = data["month_summary"]["incomeThisMonth"].toDouble();
    _monthOutcome.value = data["month_summary"]["spentThisMonth"].toDouble();

    _differentMonth.value = (monthIncome - monthOutcome).abs();
    bool isSameMonth = monthIncome.isEqual(monthOutcome);
    bool isPlusMonth = monthIncome.isGreaterThan(monthOutcome);
    double byOutcome = monthOutcome == 0 ? 1 : monthOutcome;
    double percentMonth = (differentMonth / byOutcome) * 100;
    _percentIncome.value = percentMonth.toStringAsFixed(1);
    _monthPercent.value = isSameMonth
        ? 'Pemasukan\n100% sama\ndengan Pengeluaran.'
        : isPlus
            ? 'Pemasukan\nlebih besar ${percentMonth.toStringAsFixed(1)}%\ndari Pengeluaran.'
            : 'Pemasukan\nlebih kecil ${percentMonth.toStringAsFixed(1)}%\ndari Pengeluaran.';

    print(monthIncome);
    print(monthOutcome);

    // Values Past Seven Days
    _valuesPastSevenDays.value = data["past_seven_days"]["values"]
        .map((e) => e.toDouble())
        .toList()
        .cast<double>();
    // Keys Past Seven Days
    _keysPastSevenDays.value = data["past_seven_days"]["keys"]
        .map((e) => e.toString())
        .toList()
        .cast<String>();
  }
}
