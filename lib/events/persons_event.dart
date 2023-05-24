part of '../bloc/person_bloc.dart';

@immutable
abstract class PersonEvent {}

class RegistrationPerson extends PersonEvent {
  final Member member;

  RegistrationPerson(this.member);

}

class AuthorizationPerson extends PersonEvent {
  final Member member;

  AuthorizationPerson(this.member);

}

class LoadPersonsByEvent extends PersonEvent {
}

class ExitProfile extends PersonEvent {}

class LoadOwnProfile extends PersonEvent {
}

class UpdateProfile extends PersonEvent {
  final Member member;

  UpdateProfile(this.member);
}

class LoadProfile extends PersonEvent {
  final String nickname;

  LoadProfile(this.nickname);
}

class WatchEvent extends PersonEvent {
  final int eventId;

  WatchEvent(this.eventId);
}

class JoinToEvent extends PersonEvent {
  final int? eventId;

  JoinToEvent({required this.eventId});
}

class LeaveFromEvent extends PersonEvent {
  final int? eventId;

  LeaveFromEvent(this.eventId);
}

class AllMembersOfEvent extends PersonEvent {
  final int eventId;

  AllMembersOfEvent(this.eventId);
}

class DeleteEvent extends PersonEvent {
  final int eventId;

  DeleteEvent(this.eventId);
}

class KickPerson extends PersonEvent {
  final String nickname;
  final int eventId;

  KickPerson(this.nickname, this.eventId);
}