import 'package:assetr/config/app_colors.dart';
import 'package:assetr/config/session.dart';
import 'package:assetr/data/models/user.dart';
import 'package:assetr/presentation/pages/auth/login_page.dart';
import 'package:assetr/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('id_ID').then((value) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          primaryColor: AppColors.primaryColor,
          colorScheme: const ColorScheme.light().copyWith(
            primary: AppColors.primaryColor,
            secondary: AppColors.secondaryColor,
          ),
          appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white)),
      home: FutureBuilder(
          future: Session.getUser(),
          builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.data != null && snapshot.data!.id != null) {
              return const HomePage();
            }
            return const LoginPage();
          }),
    );
  }
}
