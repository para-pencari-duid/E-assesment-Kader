import 'package:flutter/foundation.dart';

import '../data/datasources/modul_service.dart';
import '../data/responses/answers_post_request.dart';

class AnswerProvider extends ChangeNotifier {
  final ModulService _modulService;

  AnswerProvider(this._modulService);

  final List<Penilaian> _answers = [];
  List<Penilaian> get answers => _answers;

  void addOrUpdateAnswer(int pertanyaanId, int nilai) {
    final index = _answers.indexWhere((a) => a.pertanyaanId == pertanyaanId);

    if (index != -1) {
      _answers[index] = Penilaian(pertanyaanId: pertanyaanId, nilai: nilai);
    } else {
      _answers.add(Penilaian(pertanyaanId: pertanyaanId, nilai: nilai));
    }

    // Perbarui list dengan List.from agar Flutter mendeteksi perubahan
    notifyListeners();
  }

  // Menghapus jawaban tertentu (jika perlu)
  void removeAnswer(int pertanyaanId) {
    _answers.removeWhere((a) => a.pertanyaanId == pertanyaanId);
    notifyListeners();
  }

  // Mengirim data ke backend
  Future<void> submits(String token, int kaderId) async {
    if (_answers.isEmpty) {
      print("Tidak ada jawaban untuk dikirim!");
      return;
    }

    final requestData = AnswersPostRequest(penilaian: _answers);

    try {
      final response =
          await _modulService.postAnswers(token, kaderId, requestData);
      print("Jawaban berhasil dikirim: ${response.toJson()}");

      // Kosongkan daftar jawaban setelah berhasil submit
      _answers.clear();
      notifyListeners();
    } catch (e) {
      print("Gagal mengirim jawaban: $e");
    }
  }

  // Reset semua jawaban
  void resetAnswers() {
    _answers.clear();
    notifyListeners();
  }
}
