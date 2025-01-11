import '../../shared/models/repository_model.dart';
import '../../shared/models/user_model.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final User user;
  final List<Repository> repositories;

  ProfileSuccess(this.user, this.repositories);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
