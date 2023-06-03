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
class InitialEvent extends PersonEvent {}

class ChangePasswordEvent extends PersonEvent {
  final String password;
  final String passwordRepeat;
  final String nickname;

  ChangePasswordEvent(this.password, this.passwordRepeat, this.nickname);
}

class ValidateSecretWordEvent extends PersonEvent {
  final NickNameAndSecretWord nickNameAndSecretWord;

  ValidateSecretWordEvent(this.nickNameAndSecretWord);

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

class LoadEventForPerson extends PersonEvent {
  final int eventId;

  LoadEventForPerson(this.eventId);
}

class EditItems extends PersonEvent {
  final int eventId;
  final List<Item> items;

  EditItems(this.eventId, this.items);
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

class BanPerson extends PersonEvent {
  final String nickname;
  BanPerson(this.nickname);
}

class MarkItem extends PersonEvent {
  final int eventId;
  final Item item;

  MarkItem(this.eventId, this.item);
}