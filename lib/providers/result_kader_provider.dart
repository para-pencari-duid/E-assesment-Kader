import 'package:e_assesment_kader_app/data/datasources/kader_service.dart';
import 'package:e_assesment_kader_app/data/responses/result_kader_response.dart';
import 'package:e_assesment_kader_app/static/result_kader_state.dart';
import 'package:flutter/foundation.dart';

class ResultKaderProvider extends ChangeNotifier {
  final KaderService _kaderService;

  ResultKaderProvider(this._kaderService);

  ResultKaderResultState _resultState = ResultKaderNoneState();
  ResultKaderResultState get resultState => _resultState;

  String? _message = "";
  String? get message => _message;

  ResultKaderResponse? _result;
  ResultKaderResponse? get result => _result;

  // Getter untuk mendapatkan list keterampilan
  List<Keterampilan> get keterampilanList => (_result?.hasilPenilaian ?? [])
      .expand((penilaian) => penilaian.keterampilan ?? [])
      .cast<Keterampilan>() // Mengonversi ke List<Keterampilan>
      .toList();

  KeterampilanSudahTerisi? getKeterampilanSudahTerisi(String namaKeterampilan) {
    final keterampilan = keterampilanList.firstWhere(
      (k) =>
          k.namaKeterampilan?.toLowerCase() == namaKeterampilan.toLowerCase(),
      orElse: () => Keterampilan(keterampilanSudahTerisi: null),
    );

    return keterampilan.keterampilanSudahTerisi;
  }

  Keterampilan? getDataKeterampilan(String submodulNama) {
    if (_result == null || _result!.hasilPenilaian == null) {
      return null;
    }

    for (var hasil in _result!.hasilPenilaian!) {
      if (hasil.keterampilan != null) {
        for (var keterampilan in hasil.keterampilan!) {
          if (keterampilan.namaKeterampilan == submodulNama) {
            return keterampilan;
          }
        }
      }
    }
    return null;
  }

  Future<void> getResultKader(String token, String kaderId) async {
    try {
      _resultState = ResultKaderLoadingState();
      notifyListeners();

      final response = await _kaderService.getResultKader(token, kaderId);
      if (response.hasilPenilaian == null) {
        _message = "Data tidak ditemukan";
        print("RESPONSE KADER FAILED: $response");
        _resultState = ResultKaderErrorState(response.message!);
        notifyListeners();
      } else {
        _result = response;
        print("RESPONSE KADER SUCCESS: $_result");
        _resultState = ResultKaderLoadedState(response);
        notifyListeners();
      }
    } on Exception catch (e) {
      _message = "Data tidak ditemukan";
      _resultState = ResultKaderErrorState(e.toString());
      print("RESPONSE KADER SUCCESS: ${e.toString()}");
      notifyListeners();
    }
  }
}
