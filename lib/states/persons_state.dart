part of '../bloc/person_bloc.dart';

@immutable
abstract class PersonsState {}

class PersonsInitial extends PersonsState {}

class PersonsLoading extends PersonsState {}

class PersonsLoaded extends PersonsState {
  final List<Member> members;
  PersonsLoaded(this.members);
}

class RegistrationSuccess extends PersonsState {
}

class ExitSuccess extends PersonsState {
}

class AuthorizationSuccess extends PersonsState {
}

class UpdateProfileSuccess extends PersonsState {
}

class PersonsError extends PersonsState {
  final String errorMessage;
  PersonsError({required this.errorMessage});
}

class OwnProfileLoaded extends PersonsState {
  final Member member;
  OwnProfileLoaded(this.member);
}

class ProfileLoaded extends PersonsState {
  final Member member;
  ProfileLoaded(this.member);
}