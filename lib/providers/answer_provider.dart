import 'package:e_assesment_kader_app/data/responses/answers_post_response.dart';
import 'package:flutter/foundation.dart';

import '../data/datasources/modul_service.dart';
import '../data/responses/answers_post_request.dart';

class AnswerProvider extends ChangeNotifier {
  final ModulService _modulService;

  AnswerProvider(this._modulService);

  final List<Penilaian> _answers = [];
  List<Penilaian> get answers => _answers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _message = "";
  String? get message => _message;

  void addOrUpdateAnswer(int pertanyaanId, int nilai) {
    final index = _answers.indexWhere((a) => a.pertanyaanId == pertanyaanId);

    if (index != -1) {
      _answers[index] = Penilaian(pertanyaanId: pertanyaanId, nilai: nilai);
    } else {
      _answers.add(Penilaian(pertanyaanId: pertanyaanId, nilai: nilai));
    }

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

      _answers.clear();
      notifyListeners();
    } catch (e) {
      print("Gagal mengirim jawaban: $e");
    }
  }

  Future<AnswersPostResponse> remidi(String token, int kaderId) async {
    if (_answers.isEmpty) {
      print("Tidak ada jawaban untuk dikirim!");
    }

    _isLoading = true;
    _message = null;
    notifyListeners();

    final requestData = AnswersPostRequest(penilaian: _answers);

    try {
      final response =
          await _modulService.postRemidiAnswers(token, kaderId, requestData);

      if (response.penilai == null) {
        _isLoading = false;
        _message = response.message;
        notifyListeners();
        return response;
      } else {
        _isLoading = false;
        _message = response.message;

        _answers.clear();
        notifyListeners();
        return response;
      }
    } catch (e) {
      _isLoading = false;
      _message = 'An unexpected error occurred';
      notifyListeners();
      return AnswersPostResponse(
        message: e.toString(),
        kaderId: null,
        penilai: null,
      );
    }
  }

  void resetAnswers() {
    _answers.clear();
    notifyListeners();
  }
}
