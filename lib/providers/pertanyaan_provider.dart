import 'package:e_assesment_kader_app/data/models/pertanyaan_model.dart';
import 'package:flutter/foundation.dart';

import '../data/datasources/modul_service.dart';
import '../data/responses/question_list_response.dart';
import '../static/pertanyaan_result_state.dart';

class QuestionProvider extends ChangeNotifier {
  final ModulService _modulService;

  QuestionProvider(this._modulService);

  QuestionListResultState _resultState = QuestionListNoneState();
  QuestionListResultState get resultState => _resultState;

  List<PertanyaanModel>? _questiones = [];
  List<PertanyaanModel>? get questiones => _questiones;

  String? _message = "";
  String? get message => _message;

  Future<void> fetchQuestionList(String token, int submodulId) async {
    try {
      _resultState = QuestionListLoadingState();
      notifyListeners();

      final QuestionListResponse response =
          await _modulService.getQuestionList(token, submodulId);

      if (response.keterampilan == null) {
        _message = response.message!;
        _resultState = QuestionListErrorState(_message!);
        notifyListeners();
      } else {
        _questiones = response.keterampilan?.pertanyaans;

        _resultState = QuestionListLoadedState(_questiones);
        notifyListeners();
      }
    } on Exception catch (e) {
      _message = "Data tidak ditemukan";
      _resultState = QuestionListErrorState(e.toString());
      notifyListeners();
    }
  }
}
