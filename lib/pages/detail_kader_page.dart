import 'package:e_assesment_kader_app/static/result_kader_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/result_kader_provider.dart';
import '../providers/preferences_provider.dart';

class DetailKaderPage extends StatefulWidget {
  final String kaderId;
  const DetailKaderPage({required this.kaderId, super.key});

  @override
  State<DetailKaderPage> createState() => _DetailKaderPageState();
}

class _DetailKaderPageState extends State<DetailKaderPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<ResultKaderProvider>();
      final prefProvider = context.read<PreferencesProvider>();

      if (prefProvider.userToken != null && widget.kaderId.isNotEmpty) {
        provider.getResultKader(prefProvider.userToken!, widget.kaderId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Kader", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<ResultKaderProvider>(
        builder: (context, provider, child) {
          if (provider.resultState is ResultKaderLoadingState) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          } else if (provider.resultState is ResultKaderErrorState) {
            return Center(
              child: Text(provider.result!.message!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.teal,
                          child: ClipOval(
                            child: provider.result?.kelamin == "L"
                                ? Image.asset("assets/img_male.png", fit: BoxFit.cover)
                                : Image.asset("assets/img_woman.png", fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(provider.result?.namaKader ?? "Tidak tersedia",
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade900,
                                )),
                        const SizedBox(height: 8),
                        Text("Puskesmas-${provider.result?.puskesmas?.nama ?? "-"}",
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text("Klasifikasi-${provider.result?.klasifikasi ?? "-"}",
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Data Penilai"),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: provider.result?.detailPenilai?.map((penilai) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Nama: ${penilai.name}", style: _boldTextStyle()),
                                  Text("Tipe: ${penilai.tipe}"),
                                  Text("Puskesmas: ${penilai.puskesmas}"),
                                ],
                              ),
                            );
                          }).toList() ??
                          [],
                    ),
                  ),
                  const SizedBox(height: 24),
_buildSectionTitle("Hasil Penilaian"),
...?(provider.result?.hasilPenilaian?.map((kompetensi) {
  return Column(
    children: [
      _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kompetensi: ${kompetensi.kompetensi}", style: _boldTextStyle()),
            ...kompetensi.keterampilan!.map((keterampilan) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("- ${keterampilan.namaKeterampilan}")),
                    Chip(
                      label: Text(keterampilan.status!),
                      backgroundColor: keterampilan.status == "Lulus" ? Colors.green : Colors.red,
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
      const SizedBox(height: 16), // Tambahkan jarak antar card
    ],
  );
}).toList() ?? []),

                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: _boldTextStyle().copyWith(fontSize: 18, color: Colors.teal.shade900)),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }

  TextStyle _boldTextStyle() {
    return const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  }
}
