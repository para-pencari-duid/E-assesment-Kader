import 'package:e_assesment_kader_app/data/responses/result_kader_response.dart';

sealed class ResultKaderResultState {}

class ResultKaderNoneState extends ResultKaderResultState {}

class ResultKaderLoadingState extends ResultKaderResultState {}

class ResultKaderErrorState extends ResultKaderResultState {
  final String error;

  ResultKaderErrorState(this.error);
}

class ResultKaderLoadedState extends ResultKaderResultState {
  final ResultKaderResponse? data;

  ResultKaderLoadedState(this.data);
}
