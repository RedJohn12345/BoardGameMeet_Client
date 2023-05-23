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

class InitialEvent extends PersonsEvent {}

class ChangePasswordEvent extends PersonsEvent {
  final String password;
  final String passwordRepeat;
  final String nickname;

  ChangePasswordEvent(this.password, this.passwordRepeat, this.nickname);
}

class ValidateSecretWordEvent extends PersonsEvent {
  final NickNameAndSecretWord nickNameAndSecretWord;

  ValidateSecretWordEvent(this.nickNameAndSecretWord);

}

class JoinToEvent extends PersonsEvent {
  final int? eventId;

  JoinToEvent({required this.eventId});
}

class LeaveFromEvent extends PersonsEvent {
  final int? eventId;

  LeaveFromEvent(this.eventId);
}

class AllMembersOfEvent extends PersonsEvent {
  final int eventId;

  AllMembersOfEvent(this.eventId);
}