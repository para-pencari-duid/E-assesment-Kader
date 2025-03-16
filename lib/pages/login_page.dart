import 'package:e_assesment_kader_app/pages/sign_up_page.dart';
import 'package:e_assesment_kader_app/providers/preferences_provider.dart';
import 'package:e_assesment_kader_app/style/colors/app_colors.dart';
import 'package:e_assesment_kader_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../common/transitions.dart';
import '../data/models/user_model.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.only(top: 30),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Text(
                        "Selamat Datang di E-Assesment\nKader Posyandu",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.black87),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Kabupaten Temanggung",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black87),
                      ),
                    ],
                  ),
                )),
            Expanded(
              flex: 5,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.green400.color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 30),
                    CustomTextfield(
                      title: "Email",
                      textInputType: TextInputType.emailAddress,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextfield(
                      title: "Password",
                      textInputType: TextInputType.visiblePassword,
                      obsecureText: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 25),
                    Consumer2<UserProvider, PreferencesProvider>(
                      builder: (context, userProvider, prefProvider, child) {
                        if (userProvider.isLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return CustomButton(
                          title: "Masuk",
                          onTap: () async {
                            final data = UserModel(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            final result = await userProvider.loginUser(data);

                            if (result.users != null &&
                                result.users!.name != null) {
                              await prefProvider.saveUserToken(result.token!);
                              await prefProvider
                                  .saveUsername(result.users!.name!);

                              context.go('/');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(userProvider.message!)),
                              );
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun? ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        InkWell(
                            onTap: () {
                              print("KEPENCET");
                              context.goNamed('register');
                            },
                            child: Text(
                              "Daftar disini",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: AppColors.green700.color),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
