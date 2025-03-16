import 'package:e_assesment_kader_app/data/models/puskesmas_model.dart';
import 'package:e_assesment_kader_app/data/models/user_model.dart';
import 'package:e_assesment_kader_app/pages/login_page.dart';
import 'package:e_assesment_kader_app/providers/puskesmas_provider.dart';
import 'package:e_assesment_kader_app/providers/user_provider.dart';
import 'package:e_assesment_kader_app/static/puskesmas_result_state.dart';
import 'package:e_assesment_kader_app/widgets/custom_button.dart';
import 'package:e_assesment_kader_app/widgets/custom_dropdown.dart';
import 'package:e_assesment_kader_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  PuskesmasModel? _selectedPuskesmas;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        context.read<PuskesmasProvider>().fetchPuskesmasList();
      },
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Akun Penilai"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        children: [
          CustomTextfield(
            title: "Nama Lengkap",
            controller: _fullNameController,
          ),
          CustomTextfield(
            title: "Email",
            controller: _emailController,
          ),
          CustomTextfield(
            title: "Password",
            controller: _passwordController,
            obsecureText: true,
          ),
          CustomTextfield(
            title: "Konfirmasi Password",
            controller: _confirmPasswordController,
            obsecureText: true,
          ),
          Consumer<PuskesmasProvider>(
            builder: (context, provider, child) {
              return switch (provider.resultState) {
                PuskesmasListLoadingState() => Center(
                    child: CircularProgressIndicator(),
                  ),
                PuskesmasListLoadedState(data: var puskesmasList) =>
                  CustomDropdown<PuskesmasModel>(
                    title: "Puskesmas",
                    items: puskesmasList,
                    selectedValue: _selectedPuskesmas,
                    itemLabel: (puskesmas) => puskesmas.nama!,
                    onChanged: (selected) {
                      setState(() {
                        _selectedPuskesmas = selected;
                      });
                    },
                  ),
                PuskesmasListErrorState(error: var message) => Center(
                    child: Text(message),
                  ),
                _ => const SizedBox(),
              };
            },
          ),
          const SizedBox(height: 20),
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return Column(
                children: [
                  if (userProvider.isLoading) CircularProgressIndicator(),
                  CustomButton(
                    title: "Daftar",
                    onTap: () async {
                      final data = UserModel(
                        puskesmasId: _selectedPuskesmas?.id.toString(),
                        name: _fullNameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        passwordConfirmation: _confirmPasswordController.text,
                      );

                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Password is not matches")));
                      }

                      bool success = await userProvider.registerUser(data);

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(userProvider.message!)),
                        );

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(userProvider.message!)),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
