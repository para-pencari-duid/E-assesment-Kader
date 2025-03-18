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
        title: Text(
          "Daftar Modul",
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
            colors: [const Color.fromARGB(255, 255, 255, 255), const Color.fromARGB(255, 255, 255, 255)],
          ),
        ),
        child: Column(
          children: [
            const Text(
              "Pilih modul untuk assesment",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<ModulProvider>(
                builder: (context, provider, child) {
                  if (provider.resultState is ModulListLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (provider.resultState is ModulListErrorState) {
                    return Center(
                      child: Text(
                        "Error terjadi. Harap coba beberapa saat lagi.",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final modulList = provider.modules;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _calculateCrossAxisCount(context),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: modulList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final modul = modulList![index];
                      return ModulItem(kaderId: widget.kaderId, data: modul);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 4;
    } else if (width > 800) {
      return 3;
    } else if (width > 600) {
      return 2;
    } else {
      return 1;
    }
  }
}

class ModulItem extends StatelessWidget {
  final int kaderId;
  final ModulModel data;

  const ModulItem({super.key, required this.data, required this.kaderId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubmodulPage(
              kaderId: kaderId,
              modulId: data.id!,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img_mother.png",
              width: 60,
              height: 60,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                data.nama ?? "-",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}