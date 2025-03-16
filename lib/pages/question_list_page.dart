import 'package:e_assesment_kader_app/data/models/pertanyaan_model.dart';
import 'package:e_assesment_kader_app/pages/modul_page.dart';
import 'package:e_assesment_kader_app/providers/pertanyaan_provider.dart';
import 'package:e_assesment_kader_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/responses/answers_post_request.dart';
import '../providers/answer_provider.dart';
import '../providers/preferences_provider.dart';
import '../static/pertanyaan_result_state.dart';

class QuestionListPage extends StatefulWidget {
  final int kaderId;
  final int submodulId;

  const QuestionListPage(
      {required this.kaderId, required this.submodulId, super.key});

  @override
  State<QuestionListPage> createState() => _SubmodulPageState();
}

class _SubmodulPageState extends State<QuestionListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<QuestionProvider>();
      final prefProvider = context.read<PreferencesProvider>();

      if (prefProvider.userToken != null) {
        provider.fetchQuestionList(prefProvider.userToken!, widget.submodulId);
      } else {
        print("Token atau kaderId kosong, tidak memanggil API");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Pertanyaan"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Consumer<QuestionProvider>(
            builder: (context, provider, child) {
              if (provider.resultState is QuestionListLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (provider.resultState is QuestionListErrorState) {
                return Center(
                  child: Text(provider.message!),
                );
              }

              final questionList = provider.questiones;
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: questionList?.length,
                itemBuilder: (context, index) {
                  final question = questionList?[index];

                  return QuestionItem(index: index + 1, data: question!);
                },
              );
            },
          ),
          const SizedBox(height: 15),
          //todo: Button Submit
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Consumer<AnswerProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: CustomButton(
            title: "Submit",
            onTap: () async {
              final prefProvider = context.read<PreferencesProvider>();
              final token = prefProvider.userToken;

              if (token == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Token tidak ditemukan!")),
                );
                return;
              }

              // Submit jawaban ke server
              await provider.submits(token, widget.kaderId);

              // Beri feedback ke pengguna
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Jawaban berhasil dikirim!")),
              );

              //navigasikan kembali halaman modul
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModulPage(kaderId: widget.kaderId),
                  ));
            },
          ),
        );
      },
    );
  }
}

class QuestionItem extends StatelessWidget {
  final int index;
  final PertanyaanModel data;

  const QuestionItem({required this.index, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final answerProvider = Provider.of<AnswerProvider>(context);

    // Cek apakah jawaban sudah ada di provider
    int? selectedValue = answerProvider.answers
        .firstWhere((a) => a.pertanyaanId == data.id,
            orElse: () => Penilaian(pertanyaanId: data.id, nilai: -1))
        .nilai;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Row(
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
                      "Pertanyaan $index",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      data.pertanyaan ?? "-",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 7),
          _buildRadioButtons(context, data.id!, selectedValue, answerProvider),
        ],
      ),
    );
  }

  // Widget untuk menampilkan radio button
  Widget _buildRadioButtons(BuildContext context, int questionId,
      int? selectedValue, AnswerProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RadioListTile<int>(
            title: Text("Sesuai"),
            value: 1,
            groupValue: selectedValue == -1 ? null : selectedValue,
            onChanged: (value) {
              provider.addOrUpdateAnswer(questionId, value!);
            },
          ),
        ),
        Expanded(
          child: RadioListTile<int>(
            title: Text("Tidak Sesuai"),
            value: 0,
            groupValue: selectedValue == -1 ? null : selectedValue,
            onChanged: (value) {
              provider.addOrUpdateAnswer(questionId, value!);
            },
          ),
        ),
      ],
    );
  }
}
