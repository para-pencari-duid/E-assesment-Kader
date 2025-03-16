import '../data/models/modul_model.dart';

sealed class ModulListResultState {}

class ModulListNoneState extends ModulListResultState {}

class ModulListLoadingState extends ModulListResultState {}

class ModulListErrorState extends ModulListResultState {
  final String error;

  ModulListErrorState(this.error);
}

class ModulListLoadedState extends ModulListResultState {
  final List<ModulModel>? data;

  ModulListLoadedState(this.data);
}
