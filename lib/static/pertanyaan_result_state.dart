import 'package:e_assesment_kader_app/data/models/pertanyaan_model.dart';

sealed class QuestionListResultState {}

class QuestionListNoneState extends QuestionListResultState {}

class QuestionListLoadingState extends QuestionListResultState {}

class QuestionListErrorState extends QuestionListResultState {
  final String error;

  QuestionListErrorState(this.error);
}

class QuestionListLoadedState extends QuestionListResultState {
  final List<PertanyaanModel>? data;

  QuestionListLoadedState(this.data);
}
