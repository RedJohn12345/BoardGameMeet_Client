part of '../bloc/person_bloc.dart';

@immutable
abstract class PersonState {}

class PersonsInitial extends PersonState {}

class PersonsLoading extends PersonState {}

class PersonsLoaded extends PersonState {
  final List<Member> members;
  PersonsLoaded(this.members);
}

class RegistrationSuccess extends PersonState {
}

class ExitSuccess extends PersonState {
}

class AuthorizationSuccess extends PersonState {
}

class ChangePasswordSuccess extends PersonState {
}

class UpdateProfileSuccess extends PersonState {
}

class PersonsError extends PersonState {
  final String errorMessage;
  PersonsError({required this.errorMessage});
}

class OwnProfileLoaded extends PersonState {
  final Member member;
  OwnProfileLoaded(this.member);
}

class ProfileLoaded extends PersonState {
  final Member member;
  final bool isMyProfile;
  ProfileLoaded(this.member, this.isMyProfile);
}

class WatchingEvent extends PersonState {}

class JoinedToEvent extends PersonState {
  final Event event;

  JoinedToEvent(this.event);
}

class LeavingFromEvent extends PersonState {}

class AllMembers extends PersonState {
  final List<MemberInEvent> members;

  AllMembers(this.members);
}

class ValidateSecretWordResult extends PersonState {
  final bool valid;

  ValidateSecretWordResult(this.valid);
}

class DeletingEvent extends PersonState {}

class KickingPerson extends PersonState {}