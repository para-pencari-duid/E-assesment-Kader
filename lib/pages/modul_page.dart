import 'package:e_assesment_kader_app/data/models/modul_model.dart';
import 'package:e_assesment_kader_app/pages/submodul_page.dart';
import 'package:e_assesment_kader_app/providers/modul_provider.dart';
import 'package:e_assesment_kader_app/static/modul_result_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/preferences_provider.dart';

class ModulPage extends StatefulWidget {
  final int kaderId;

  const ModulPage({required this.kaderId, super.key});

  @override
  State<ModulPage> createState() => _ModulPageState();
}

class _ModulPageState extends State<ModulPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        final prefProvider = context.read<PreferencesProvider>();
        final kaderProvider = context.read<ModulProvider>();

        // Pastikan token tidak null sebelum melakukan request
        if (prefProvider.userToken != null) {
          kaderProvider.fetchModulList(prefProvider.userToken!);
        } else {
          print("Token tidak ditemukan, tidak dapat mengambil data kader.");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Modul"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Pilih modul untuk assesment",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Consumer<ModulProvider>(
                builder: (context, provider, child) {
                  if (provider.resultState is ModulListLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.resultState is ModulListErrorState) {
                    return Text(
                        "Error terjadi. Harap coba beberapa saat lagi.");
                  }

                  final modulList = provider.modules;

                  return Expanded(
                    child: Wrap(
                      spacing: 16, // Jarak antar item horizontal
                      runSpacing: 16, // Jarak antar item vertikal
                      alignment: WrapAlignment.center,
                      children: modulList?.map((modul) {
                            return ModulItem(
                                kaderId: widget.kaderId, data: modul);
                          }).toList() ??
                          [],
                    ),
                  );
                },
              )
              // Expanded(
              //   child: Wrap(
              //     spacing: 16, // Jarak antar item horizontal
              //     runSpacing: 16, // Jarak antar item vertikal
              //     alignment: WrapAlignment.center,
              //     children: modulList.map((modul) {
              //       return ModulItem(title: modul);
              //     }).toList(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModulItem extends StatelessWidget {
  final int kaderId;
  final ModulModel data;

  const ModulItem({super.key, required this.data, required this.kaderId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmodulPage(
                kaderId: kaderId,
                modulId: data.id!,
              ),
            ));
      },
      child: Container(
        width: 150,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.primaries[data.hashCode % Colors.primaries.length]
              .shade200, // Warna random berdasarkan hash
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img_mother.png",
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                data.nama ?? "-",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
