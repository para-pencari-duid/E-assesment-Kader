import 'package:e_assesment_kader_app/data/datasources/auth_service.dart';
import 'package:e_assesment_kader_app/data/models/puskesmas_model.dart';
import 'package:e_assesment_kader_app/static/puskesmas_result_state.dart';
import 'package:flutter/material.dart';

class PuskesmasProvider extends ChangeNotifier {
  final AuthService _authService;

  PuskesmasProvider(this._authService);

  PuskesmasListResultState _resultState = PuskesmasListNoneState();
  PuskesmasListResultState get resultState => _resultState;

  List<PuskesmasModel>? _puskesmases = [];
  List<PuskesmasModel>? get puskesmases => _puskesmases;

  String? _message = "";
  String? get message => _message;

  int? _totalData;
  int? get totalData => _totalData;

  Future<void> fetchPuskesmasList() async {
    try {
      _resultState = PuskesmasListLoadingState();
      notifyListeners();

      final response = await _authService.getPuskesmasList();

      if (response.data == null) {
        _message = "Data tidak ditemukan";
        _resultState = PuskesmasListErrorState(_message!);
        notifyListeners();
      } else {
        _totalData = response.total;
        _puskesmases = response.data;
        _resultState = PuskesmasListLoadedState(_puskesmases);
        notifyListeners();
      }
    } on Exception catch (e) {
      _message = "Data tidak ditemukan";
      _resultState = PuskesmasListErrorState(e.toString());
      notifyListeners();
    }
  }
}
