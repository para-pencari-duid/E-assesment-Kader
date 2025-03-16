import 'package:e_assesment_kader_app/data/models/puskesmas_model.dart';

sealed class PuskesmasListResultState {}

class PuskesmasListNoneState extends PuskesmasListResultState {}

class PuskesmasListLoadingState extends PuskesmasListResultState {}

class PuskesmasListErrorState extends PuskesmasListResultState {
  final String error;

  PuskesmasListErrorState(this.error);
}

class PuskesmasListLoadedState extends PuskesmasListResultState {
  final List<PuskesmasModel>? data;

  PuskesmasListLoadedState(this.data);
}
