import 'package:e_assesment_kader_app/data/datasources/modul_service.dart';
import 'package:flutter/foundation.dart';

import '../data/models/modul_model.dart';
import '../static/modul_result_state.dart';

class ModulProvider extends ChangeNotifier {
  final ModulService _modulService;

  ModulProvider(this._modulService);

  ModulListResultState _resultState = ModulListNoneState();
  ModulListResultState get resultState => _resultState;

  List<ModulModel>? _modules = [];
  List<ModulModel>? get modules => _modules;

  String? _message = "";
  String? get message => _message;

  Future<void> fetchModulList(String token) async {
    try {
      _resultState = ModulListLoadingState();
      notifyListeners();

      final List<ModulModel> response = await _modulService.getModulList(token);

      if (response.isEmpty) {
        _message = "Data tidak ditemukan";
        _resultState = ModulListErrorState(_message!);
        notifyListeners();
      } else {
        // Konversi response ke model yang akan digunakan
        _modules = response
            .map((item) =>
                ModulModel(id: item.id ?? 0, nama: item.nama ?? "Unknown"))
            .toList();

        _resultState = ModulListLoadedState(_modules);
        notifyListeners();
      }
    } on Exception catch (e) {
      _message = "Data tidak ditemukan";
      _resultState = ModulListErrorState(e.toString());
      notifyListeners();
    }
  }
}
