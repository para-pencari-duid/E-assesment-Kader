import 'package:e_assesment_kader_app/data/models/keterampilan_model.dart';
import 'package:e_assesment_kader_app/data/responses/submodul_list_response.dart';
import 'package:flutter/foundation.dart';

import '../data/datasources/modul_service.dart';
import '../static/submodul_result_state.dart';

class SubmodulProvider extends ChangeNotifier {
  final ModulService _modulService;

  SubmodulProvider(this._modulService);

  SubmodulListResultState _resultState = SubmodulListNoneState();
  SubmodulListResultState get resultState => _resultState;

  List<KeterampilanModel>? _subModules = [];
  List<KeterampilanModel>? get subModules => _subModules;

  String? _message = "";
  String? get message => _message;

  Future<void> fetchSubmodulList(String token, int modulId) async {
    try {
      _resultState = SubmodulListLoadingState();
      notifyListeners();

      final SubmodulListResponse response =
          await _modulService.getSubmodulList(token, modulId);

      if (response.modulModel == null) {
        _message = response.message!;
        _resultState = SubmodulListErrorState(_message!);
        notifyListeners();
      } else {
        _subModules = response.modulModel?.keterampilans;
        _resultState = SubmodulListLoadedState(_subModules);
        notifyListeners();
      }
    } on Exception catch (e) {
      _message = "Data tidak ditemukan";
      _resultState = SubmodulListErrorState(e.toString());
      notifyListeners();
    }
  }
}
