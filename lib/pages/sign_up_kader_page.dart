import 'package:e_assesment_kader_app/data/models/puskesmas_model.dart';
import 'package:e_assesment_kader_app/data/models/user_model.dart';
import 'package:e_assesment_kader_app/providers/kader_provider.dart';
import 'package:e_assesment_kader_app/style/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/preferences_provider.dart';
import '../providers/puskesmas_provider.dart';
import '../static/puskesmas_result_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_textfield.dart';

class SignUpKaderPage extends StatefulWidget {
  const SignUpKaderPage({super.key});

  @override
  State<SignUpKaderPage> createState() => _SignUpKaderPageState();
}

class _SignUpKaderPageState extends State<SignUpKaderPage> {
  final _formKey = GlobalKey<FormState>();
  PuskesmasModel? _selectedPuskesmas;
  String? _selectedGender;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _umurController = TextEditingController();
  final TextEditingController _posyanduController = TextEditingController();
  final TextEditingController _lamaJadiKaderController =
      TextEditingController();
  final TextEditingController _pekerjaanNonKaderController =
      TextEditingController();
  String? _selectedEducation;
  String? _selectedInsentif;
  final TextEditingController _insentifController = TextEditingController();

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
    super.dispose();
    _fullNameController.dispose();
    _nikController.dispose();
    _umurController.dispose();
    _posyanduController.dispose();
    _lamaJadiKaderController.dispose();
    _pekerjaanNonKaderController.dispose();
    _insentifController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Daftar Akun Kader",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade400, Colors.blue.shade700],
            ),
          ),
          child: ListView(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextfield(
                        title: "Nama Lengkap",
                        textInputType: TextInputType.text,
                        controller: _fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nama tidak boleh kosong";
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return "Inputan hanya berisi huruf";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Consumer<PuskesmasProvider>(
                        builder: (context, provider, child) {
                          return switch (provider.resultState) {
                            PuskesmasListLoadingState() =>
                              Center(child: CircularProgressIndicator()),
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
                                validator: (value) => value == null
                                    ? "Puskesmas tidak boleh kosong"
                                    : null,
                              ),
                            PuskesmasListErrorState(error: var message) =>
                              Center(
                                child: Text(message),
                              ),
                            _ => const SizedBox(),
                          };
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown<String>(
                        title: "Jenis Kelamin",
                        items: ["L", "P"],
                        selectedValue: _selectedGender,
                        itemLabel: (value) =>
                            value == "L" ? "Laki-laki" : "Perempuan",
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: (value) => value == null
                            ? "Jenis kelamin tidak boleh kosong"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextfield(
                        title: "NIK",
                        textInputType: TextInputType.number,
                        controller: _nikController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "NIK tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextfield(
                        title: "Umur",
                        textInputType: TextInputType.number,
                        controller: _umurController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Umur tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextfield(
                        title: "Posyandu",
                        textInputType: TextInputType.name,
                        controller: _posyanduController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Posyandu tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown<String>(
                        title: "Tingkat Pendidikan",
                        items: [
                          "SD",
                          "SMP",
                          "SMA/SMK",
                          "DIPLOMA",
                          "SARJANA",
                          "MAGISTER",
                          "DOKTOR"
                        ],
                        selectedValue: _selectedEducation,
                        itemLabel: (value) => value,
                        onChanged: (value) {
                          setState(() {
                            _selectedEducation = value;
                          });
                        },
                        validator: (value) => value == null
                            ? "Tingkat pendidikan tidak boleh kosong"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextfield(
                        title: "Lama Menjadi Kader (dalam tahun)",
                        textInputType: TextInputType.number,
                        controller: _lamaJadiKaderController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Inputan tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextfield(
                        title: "Pekerjaan Selain Kader",
                        textInputType: TextInputType.name,
                        controller: _pekerjaanNonKaderController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Inputan tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown<String>(
                        title: "Apakah kader dapat insentif?",
                        items: ["Ya", "Tidak"], // Pilihan dropdown
                        selectedValue: _selectedInsentif,
                        itemLabel: (value) =>
                            value, // Langsung gunakan value sebagai label
                        onChanged: (value) {
                          setState(() {
                            _selectedInsentif = value;
                          });
                        },
                      ),
                      if (_selectedInsentif == "Ya") ...[
                        const SizedBox(height: 16),
                        CustomTextfield(
                          title: "Nominal Insentif",
                          textInputType: TextInputType.number,
                          controller: _insentifController,
                        ),
                      ],
                      const SizedBox(height: 24),
                      Consumer<KaderProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading == true) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return CustomButton(
                            title: "Daftar Kader",
                            onTap: () async {
                              final prefProvider =
                                  context.read<PreferencesProvider>();

                              if (_formKey.currentState!.validate()) {
                                final request = UserModel(
                                  puskesmasId:
                                      _selectedPuskesmas?.id.toString(),
                                  name: _fullNameController.text,
                                  nik: _nikController.text,
                                  kelamin: _selectedGender,
                                  lamaJadiKader: _lamaJadiKaderController.text,
                                  umur: _umurController.text.toString(),
                                  posyandu: _posyanduController.text,
                                  pekerjaanSelainKader:
                                      _pekerjaanNonKaderController.text,
                                  pendidikanTerakhir: _selectedEducation,
                                  dapatInsentifDariDesa: _selectedInsentif,
                                  insentifPerTahun: _insentifController.text,
                                );

                                final result = await provider.createKader(
                                    request, prefProvider.userToken!);

                                if (result.kader != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(result.message!),
                                      backgroundColor: AppColors.green500.color,
                                    ),
                                  );

                                  context.go('/kader');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Text(result.error ??
                                          "Registrasi kader gagal"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
