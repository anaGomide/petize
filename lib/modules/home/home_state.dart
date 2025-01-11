import '../../shared/models/user_model.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final User user;
  HomeSuccess(this.user);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
