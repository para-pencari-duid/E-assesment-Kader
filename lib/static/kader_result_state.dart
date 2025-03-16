import 'package:e_assesment_kader_app/data/models/user_model.dart';

sealed class KaderListResultState {}

class KaderListNoneState extends KaderListResultState {}

class KaderListLoadingState extends KaderListResultState {}

class KaderListErrorState extends KaderListResultState {
  final String error;

  KaderListErrorState(this.error);
}

class KaderListLoadedState extends KaderListResultState {
  final List<UserModel>? data;

  KaderListLoadedState(this.data);
}
