import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_assesment_kader_app/data/models/puskesmas_model.dart';
import 'package:e_assesment_kader_app/data/models/user_model.dart';
import 'package:e_assesment_kader_app/pages/login_page.dart';
import 'package:e_assesment_kader_app/providers/puskesmas_provider.dart';
import 'package:e_assesment_kader_app/providers/user_provider.dart';
import 'package:e_assesment_kader_app/static/puskesmas_result_state.dart';
import 'package:e_assesment_kader_app/widgets/custom_button.dart';
import 'package:e_assesment_kader_app/widgets/custom_dropdown.dart';
import 'package:e_assesment_kader_app/widgets/custom_textfield.dart';
import 'package:e_assesment_kader_app/style/colors/app_colors.dart'; // Assuming you have a color file

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
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PuskesmasProvider>().fetchPuskesmasList());
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
        title: const Text("Daftar Akun Penilai" ) ,
        backgroundColor: AppColors.green700.color, // Use your primary color
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth > 600 ? 500 : double.infinity),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: constraints.maxWidth > 600 ? 4 : 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildForm(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm() {
    return ListView(
      shrinkWrap: true,
      children: [
        CustomTextfield(title: "Nama Lengkap", controller: _fullNameController),
        CustomTextfield(title: "Email", controller: _emailController),
        CustomTextfield(title: "Password", controller: _passwordController, obsecureText: true),
        CustomTextfield(title: "Konfirmasi Password", controller: _confirmPasswordController, obsecureText: true),
        Consumer<PuskesmasProvider>(
          builder: (context, provider, child) {
            if (provider.resultState is PuskesmasListLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.resultState is PuskesmasListLoadedState) {
              final puskesmasList = (provider.resultState as PuskesmasListLoadedState).data;
              return CustomDropdown<PuskesmasModel>(
                title: "Puskesmas",
                items: puskesmasList,
                selectedValue: _selectedPuskesmas,
                itemLabel: (puskesmas) => puskesmas.nama!,
                onChanged: (selected) => setState(() => _selectedPuskesmas = selected),
              );
            } else if (provider.resultState is PuskesmasListErrorState) {
              return Center(child: Text((provider.resultState as PuskesmasListErrorState).error));
            }
            return const SizedBox();
          },
        ),
        const SizedBox(height: 20),
        Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return Column(
              children: [
                if (userProvider.isLoading) const CircularProgressIndicator(),
                CustomButton(
                  title: "Daftar",
                  onTap: () async {
                    if (_passwordController.text != _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password tidak cocok")),
                      );
                      return;
                    }
                    
                    final data = UserModel(
                      puskesmasId: _selectedPuskesmas?.id.toString(),
                      name: _fullNameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      passwordConfirmation: _confirmPasswordController.text,
                    );

                    bool success = await userProvider.registerUser (data);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(userProvider.message ?? "Terjadi kesalahan")),
                    );

                    if (success) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}