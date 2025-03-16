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
          title: Text("Detail Kader"),
        ),
        body: Consumer<ResultKaderProvider>(
          builder: (context, provider, child) {
            if (provider.resultState is ResultKaderLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (provider.resultState is ResultKaderErrorState) {
              return Center(
                child: Text(provider.result!.message!),
              );
            } else {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          provider.result?.kelamin == "L"
                              ? Image.asset(
                                  "assets/img_male.png",
                                  width: 80,
                                  height: 80,
                                )
                              : Image.asset(
                                  "assets/img_woman.png",
                                  width: 80,
                                  height: 80,
                                ),
                          const SizedBox(height: 10),
                          Text(
                            provider.result?.namaKader ?? "Nama tidak tersedia",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Puskesmas ${provider.result?.puskesmas?.nama ?? "-"}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Data Penilai",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.grey300.color, width: 2),
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
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Tipe: ${penilai.tipe}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Puskesmas: ${penilai.puskesmas}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(
                                      height: 15), // Beri jarak antar penilai
                                ],
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Hasil Penilaian",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    //tampilkan data di dalam list hasil_penilaian
                    ...(provider.result?.hasilPenilaian ?? [])
                        .map((kompetensi) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.grey300.color, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kompetensi: ${kompetensi.kompetensi}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 10),
                            //todo: tampilkan persentase setiap kompetensi
                            // if (kompetensi.keterampilan != null &&
                            //     kompetensi.keterampilan!.isNotEmpty)
                            //   Text(
                            //     "Total Persentase: ${kompetensi.keterampilan!.first.persentase}%",
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .bodyLarge!
                            //         .copyWith(
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //   ),
                            const SizedBox(height: 15),
                            // Mapping keterampilan dalam setiap kompetensi
                            ...(kompetensi.keterampilan ?? [])
                                .map((keterampilan) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
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
                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }
          },
        ));
  }
}
