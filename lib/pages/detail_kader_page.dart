import 'package:e_assesment_kader_app/providers/result_kader_provider.dart';
import 'package:e_assesment_kader_app/static/result_kader_state.dart';
import 'package:e_assesment_kader_app/style/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      } else {
        print("Token atau kaderId kosong, tidak memanggil API");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Kader",
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
        child: Consumer<ResultKaderProvider>(
          builder: (context, provider, child) {
            if (provider.resultState is ResultKaderLoadingState) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (provider.resultState is ResultKaderErrorState) {
              return Center(
                child: Text(
                  provider.result!.message!,
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                            ),
                            child: ClipOval(
                              child: provider.result?.kelamin == "L"
                                  ? Image.asset(
                                      "assets/img_male.png",
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "assets/img_woman.png",
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            provider.result?.namaKader ?? "Nama tidak tersedia",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Puskesmas-${provider.result?.puskesmas?.nama ?? "-"}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: const Color.fromARGB(179, 0, 0, 0),
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Klasifikasi Kader-${provider.result?.klasifikasi ?? "-"}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: const Color.fromARGB(179, 0, 0, 0),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Data Penilai",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...?provider.result?.detailPenilai?.map((penilai) =>
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nama: ${penilai.name}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),const SizedBox(height: 8),
                                  Text(
                                    "Tipe: ${penilai.tipe}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Puskesmas: ${penilai.puskesmas}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Hasil Penilaian",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ...(provider.result?.hasilPenilaian ?? []).map((kompetensi) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        margin: const EdgeInsets.only(bottom: 16),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kompetensi: ${kompetensi.kompetensi}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ...(kompetensi.keterampilan ?? []).map((keterampilan) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "- ${keterampilan.namaKeterampilan}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                    Text(
                                      keterampilan.status!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: keterampilan.status == "Lulus"
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}