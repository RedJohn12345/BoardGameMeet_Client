part of '../bloc/person_bloc.dart';

@immutable
abstract class PersonState {}

class PersonsInitial extends PersonState {}

class PersonsLoading extends PersonState {}

class PersonsFirstLoading extends PersonState {}

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

class EventForPersonLoaded extends PersonState {
  final List<Item> items;
  final Event event;
  EventForPersonLoaded(this.items, this.event);
}

class ItemsEdited extends PersonState {
}

class UpdateProfileSuccess extends PersonState {
}

class PersonsError extends PersonState {
  final String errorMessage;
  PersonsError({required this.errorMessage});

  String getErrorMessageWithoutException() {
    return errorMessage.substring(11, errorMessage.length);
  }
}

class EventNotFoundErrorForPerson extends PersonState {
  final String errorMessage;

  EventNotFoundErrorForPerson({required this.errorMessage});
}

class PersonNotFoundErrorForPerson extends PersonState {
  final String errorMessage;

  PersonNotFoundErrorForPerson({required this.errorMessage});
}

class KickPersonErrorForPerson extends PersonState {
  final String errorMessage;

  KickPersonErrorForPerson({required this.errorMessage});
}

class PersonInputError extends PersonState {
  final String errorMessage;

  PersonInputError({required this.errorMessage});
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

class AdminShowedEvent extends PersonState {
  final Event event;

  AdminShowedEvent(this.event);
}

class AddressLoadedEvent extends PersonState {
  final Point point;
  final String address;

  AddressLoadedEvent(this.point, this.address);
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

class PersonBanned extends PersonState {}