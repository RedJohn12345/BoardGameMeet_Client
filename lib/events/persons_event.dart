part of '../bloc/person_bloc.dart';

@immutable
abstract class PersonsEvent {}

class RegistrationPerson extends PersonsEvent {
  final Member member;

  RegistrationPerson(this.member);

}

class AuthorizationPerson extends PersonsEvent {
  final Member member;

  AuthorizationPerson(this.member);

}

class LoadPersonsByEvent extends PersonsEvent {
}

class ExitProfile extends PersonsEvent {}

class LoadOwnProfile extends PersonsEvent {
}

class UpdateProfile extends PersonsEvent {
  final Member member;

  UpdateProfile(this.member);
}

class LoadProfile extends PersonsEvent {
  final String nickname;

  LoadProfile(this.nickname);
}

class WatchEvent extends PersonsEvent {}

class JoinToEvent extends PersonsEvent {
  final int? eventId;

  JoinToEvent({required this.eventId});
}

class LeaveFromEvent extends PersonsEvent {
  final int? eventId;

  LeaveFromEvent(this.eventId);
}