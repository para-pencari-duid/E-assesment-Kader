import 'package:e_assesment_kader_app/data/datasources/kader_service.dart';
import 'package:e_assesment_kader_app/data/models/user_model.dart';
import 'package:e_assesment_kader_app/data/responses/kader_list_response.dart';
import 'package:e_assesment_kader_app/data/responses/kader_register_response.dart';
import 'package:flutter/foundation.dart';

import '../static/kader_result_state.dart';

class KaderProvider extends ChangeNotifier {
  final KaderService _kaderService;

  KaderProvider(this._kaderService);

  KaderListResultState _resultState = KaderListNoneState();
  KaderListResultState get resultState => _resultState;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<UserModel>? _kaders = [];
  List<UserModel>? get kaders => _kaders;

  KaderListResponse? _response;
  KaderListResponse? get response => _response;

  String? _message = "";
  String? get message => _message;

  int? pageItems = 1;
  int sizeItems = 10;

  Future<void> fetchKaderList(String token) async {
    _resultState = KaderListLoadingState();
    notifyListeners();

    try {
      final result = await _kaderService.getKaderList(token);

      if (result.data == null || result.data!.isEmpty) {
        _message = "Data tidak ditemukan";
        _resultState = KaderListErrorState(_message!);
        notifyListeners();
      } else {
        _kaders = result.data;
        _response = result;
        _resultState = KaderListLoadedState(_kaders);
        notifyListeners();
      }
    } on Exception catch (e) {
      _message = "Data tidak ditemukan";
      _resultState = KaderListErrorState(e.toString());
      notifyListeners();
    }
  }

  Future<void> fetchKaderListPaging(String token) async {
    try {
      if (pageItems == null) return;

      if (pageItems == 1) {
        _resultState = KaderListLoadingState();
        notifyListeners();
      }

      final result =
          await _kaderService.getKaderListPaging(token, pageItems!, sizeItems);

      if (result.data == null || result.data!.isEmpty) {
        if (pageItems == 1) {
          _message = "Data tidak ditemukan";
          _resultState = KaderListErrorState(_message!);
          notifyListeners();
        }
        pageItems = null;
      } else {
        _kaders!.addAll(result.data!);
        _response = result;
        _resultState = KaderListLoadedState(_kaders);
        notifyListeners();

        if (result.data!.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }
      }
    } on Exception catch (e) {
      _message = "Data tidak ditemukan";
      _resultState = KaderListErrorState(e.toString());
      notifyListeners();
    }
  }

  Future<RegisterKaderResponse> createKader(
      UserModel request, String token) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      final result = await _kaderService.postRegisterKader(request, token);

      if (result.message != "Kader registered successfully") {
        _isLoading = false;
        _message = result.error;
        notifyListeners();
        return result;
        // return false;
      } else {
        _isLoading = false;
        _message = result.message;
        notifyListeners();

        await fetchKaderList(token);
        return result;
        // return true;
      }
    } catch (e) {
      _message = e.toString();
      print("CREATE USER EXCEPTION: $_message");
      _isLoading = false;
      notifyListeners();
      throw Exception(e.toString());
      // return false;
    }
  }
}
