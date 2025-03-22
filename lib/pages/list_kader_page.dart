import 'package:e_assesment_kader_app/pages/sign_up_kader_page.dart';
import 'package:e_assesment_kader_app/providers/kader_provider.dart';
import 'package:e_assesment_kader_app/static/kader_result_state.dart';
import 'package:e_assesment_kader_app/style/colors/app_colors.dart';
import 'package:e_assesment_kader_app/widgets/kader_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/preferences_provider.dart';

class ListKaderPage extends StatefulWidget {
  const ListKaderPage({super.key});

  @override
  State<ListKaderPage> createState() => _ListKaderPageState();
}

class _ListKaderPageState extends State<ListKaderPage> {
  @override
  void initState() {
    super.initState();

    final prefProvider = context.read<PreferencesProvider>();
    final kaderProvider = context.read<KaderProvider>();

    Future.microtask(() {
      if (prefProvider.userToken != null) {
        kaderProvider.fetchKaderList(prefProvider.userToken!);
      } else {
        print("Token tidak ditemukan, tidak dapat mengambil data kader.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Daftar Kader", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 255, 255, 255), Color(0xFFF5F5F5)],
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari Nama Kader",
                      prefixIcon:
                          Icon(Icons.search, color: AppColors.green400.color),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: AppColors.grey300.color,
                            width: 1,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: AppColors.green400.color,
                            width: 1,
                          )),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: AppColors.green400.color,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpKaderPage()),
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<KaderProvider>(
                builder: (context, provider, child) {
                  final state = provider.resultState;

                  if (state is KaderListLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is KaderListErrorState) {
                    return Center(
                      child: Text(
                        "Error: ${provider.message}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    final kaderList = provider.kaders;
                    if (kaderList == null || kaderList.isEmpty) {
                      return const Center(
                        child: Text("Tidak ada data kader.",
                            style: TextStyle(color: Colors.black54)),
                      );
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: kaderList.length,
                      itemBuilder: (context, index) {
                        final kader = kaderList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: KaderItem(user: kader),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
