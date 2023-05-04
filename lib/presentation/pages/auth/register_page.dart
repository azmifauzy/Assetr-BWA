import 'package:assetr/config/app_assets.dart';
import 'package:assetr/config/app_colors.dart';
import 'package:assetr/data/sources/source_user.dart';
import 'package:assetr/presentation/pages/auth/login_page.dart';
import 'package:assetr/presentation/pages/home_page.dart';
import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  handleLogin() async {
    if (formKey.currentState!.validate()) {
      bool result = await SourceUser.register(
          controllerName.text, controllerEmail.text, controllerPassword.text);
      if (result) {
        DInfo.dialogSuccess('Register Success');
        DInfo.closeDialog(actionAfterClose: () {
          Get.off(() => const HomePage());
        });
      } else {
        DInfo.dialogError('Register Failed');
        DInfo.closeDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DView.nothing(),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Image.asset(AppAssets.logo),
                        DView.spaceHeight(40),
                        TextFormField(
                          controller: controllerName,
                          validator: (value) =>
                              value == '' ? 'Tidak boleh kosong.' : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              fillColor:
                                  AppColors.primaryColor.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none),
                              hintText: "Fullname",
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16)),
                        ),
                        DView.spaceHeight(),
                        TextFormField(
                          controller: controllerEmail,
                          validator: (value) =>
                              value == '' ? 'Tidak boleh kosong.' : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              fillColor:
                                  AppColors.primaryColor.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none),
                              hintText: "Email Address",
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16)),
                        ),
                        DView.spaceHeight(),
                        TextFormField(
                          obscureText: true,
                          validator: (value) =>
                              value == '' ? 'Tidak boleh kosong.' : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(color: Colors.white),
                          controller: controllerPassword,
                          decoration: InputDecoration(
                              fillColor:
                                  AppColors.primaryColor.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none),
                              hintText: "Password",
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16)),
                        ),
                        DView.spaceHeight(30),
                        Container(
                          width: double.infinity,
                          child: Material(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () {
                                handleLogin();
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                child: Center(
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sudah Punya Akun?",
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.off(() => const LoginPage());
                        },
                        child: const Text(
                          " Login?",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
