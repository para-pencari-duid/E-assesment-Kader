import '../data/models/keterampilan_model.dart';

sealed class SubmodulListResultState {}

class SubmodulListNoneState extends SubmodulListResultState {}

class SubmodulListLoadingState extends SubmodulListResultState {}

class SubmodulListErrorState extends SubmodulListResultState {
  final String error;

  SubmodulListErrorState(this.error);
}

class SubmodulListLoadedState extends SubmodulListResultState {
  final List<KeterampilanModel>? data;

  SubmodulListLoadedState(this.data);
}
