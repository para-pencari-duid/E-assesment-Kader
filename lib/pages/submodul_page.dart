import 'package:e_assesment_kader_app/data/models/keterampilan_model.dart';
import 'package:e_assesment_kader_app/data/responses/result_kader_response.dart';
import 'package:e_assesment_kader_app/pages/question_list_page.dart';
import 'package:e_assesment_kader_app/providers/result_kader_provider.dart';
import 'package:e_assesment_kader_app/providers/submodul_provider.dart';
import 'package:e_assesment_kader_app/static/submodul_result_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/preferences_provider.dart';
import '../style/colors/app_colors.dart';

class SubmodulPage extends StatefulWidget {
  final int kaderId;
  final int modulId;

  const SubmodulPage({required this.kaderId, required this.modulId, super.key});

  @override
  State<SubmodulPage> createState() => _SubmodulPageState();
}

class _SubmodulPageState extends State<SubmodulPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<SubmodulProvider>();
      final prefProvider = context.read<PreferencesProvider>();
      final resultProvider = context.read<ResultKaderProvider>();

      if (prefProvider.userToken != null) {
        provider.fetchSubmodulList(prefProvider.userToken!, widget.modulId);
        resultProvider.getResultKader(
            prefProvider.userToken!, widget.kaderId.toString());
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
          "Daftar Submodul",
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
        child: Consumer2<SubmodulProvider, ResultKaderProvider>(
          builder: (context, provider, resultProvider, child) {
            if (provider.resultState is SubmodulListLoadingState) {
              return Center(
                child: CircularProgressIndicator(color: const Color.fromARGB(255, 255, 55, 55)),
              );
            }

            if (provider.resultState is SubmodulListErrorState) {
              return Center(
                child: Text(
                  provider.message!,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final submodulList = provider.subModules;

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: submodulList?.length,
              itemBuilder: (context, index) {
                final submodul = submodulList?[index];
                final rProvider = context.watch<ResultKaderProvider>();

                final dataKeterampilan =
                    rProvider.getDataKeterampilan(submodul?.nama ?? "");

                final keterampilan = rProvider
                    .getKeterampilanSudahTerisi(submodul?.nama ?? "");

                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 61, 194, 255),
                    borderRadius: BorderRadius.circular(12),
                    
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SubmodulItem(
                    index: index + 1,
                    kaderId: widget.kaderId,
                    data: submodul!,
                    dataKeterampilan: dataKeterampilan,
                    keterampilan: keterampilan,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class SubmodulItem extends StatelessWidget {
  final int index;
  final int kaderId;
  final KeterampilanModel data;
  final Keterampilan? dataKeterampilan;
  final KeterampilanSudahTerisi? keterampilan;

  const SubmodulItem(
      {required this.index,
      required this.kaderId,
      required this.data,
      this.dataKeterampilan,
      this.keterampilan,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, preferencesProvider, child) {
        String? currentUsername = preferencesProvider.username;
        print("PENILAI 1 CURRENT NAME: $currentUsername");

        bool penilai1 = keterampilan?.penilai1 ?? false;
        bool penilai2 = keterampilan?.penilai2 ?? false;

        String? penilai1Name;
        if (dataKeterampilan?.detailPenilaian != null &&
            dataKeterampilan!.detailPenilaian!.isNotEmpty) {
          penilai1Name = dataKeterampilan!.detailPenilaian!.first.penilai?.name;
        } else {
          print("DETAIL PENILAIAN KOSONG atau NULL");
        }

        print("PENILAI 1 NAME: $penilai1Name");

        bool isAlreadyAssessed = penilai1Name == currentUsername;

        print("IS ALREADY ASSERT: $isAlreadyAssessed");

        Color checklistColor = Colors.transparent;
        if (penilai1 && penilai2) {
          checklistColor = Colors.green;
        } else if (penilai1) {
          checklistColor = Colors.blue;
        }

        bool isDisabled = penilai1 && penilai2 || isAlreadyAssessed;
        return InkWell(
          onTap: isDisabled
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 1),
                    content:
                        Text("Submodul sudah diisi atau Anda sudah menilai"),
                  ));
                }
              : () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionListPage(
                            kaderId: kaderId, submodulId: data.id!),
                      ));
                },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDisabled ? Colors.grey.shade200 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/img_exam.png",
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Submodul $index",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        data.nama ?? "-",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.check_circle,
                  color: checklistColor,
                  size: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}