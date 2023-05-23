import 'dart:async';
import 'package:boardgm/model/dto/member_dto.dart';
import 'package:boardgm/model/member.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
part '../events/persons_event.dart';
part '../states/persons_state.dart';


class PersonBloc extends Bloc<PersonsEvent, PersonsState> {
  final PersonsRepository personRepository;
  PersonBloc({required this.personRepository}) : super(PersonsInitial());

  @override
  Stream<PersonsState> mapEventToState(
      PersonsEvent event,
      ) async* {
    if (event is RegistrationPerson) {
      yield PersonsLoading();
      try {
        await personRepository.registration(event.member);
        yield RegistrationSuccess();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is AuthorizationPerson) {
      yield PersonsLoading();
      try {
        await personRepository.authorization(event.member);
        yield AuthorizationSuccess();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is LoadOwnProfile) {
      yield PersonsLoading();
      try {
        Member member =  await personRepository.getOwnProfile();
        yield OwnProfileLoaded(member);
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is LoadProfile) {
      yield PersonsLoading();
      try {
        Member member =  await personRepository.getProfile(event.nickname);
        yield OwnProfileLoaded(member);
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is ExitProfile) {
      yield PersonsLoading();
      try {
        await personRepository.exitProfile();
        print("exit profile");
        yield ExitSuccess();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is UpdateProfile) {
      yield PersonsLoading();
      try {
        await personRepository.updatePerson(UpdatePersonRequest(event.member.name,
            event.member.login, event.member.city, event.member.age, event.member.sex, event.member.avatarId));
        yield UpdateProfileSuccess();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is WatchEvent) {
      yield WatchingEvent();
    } else if (event is JoinToEvent) {
      yield PersonsLoading();
      try {
        await personRepository.joinToEvent(event.eventId);
        yield JoinedToEvent();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is LeaveFromEvent) {
      yield PersonsLoading();
      try {
        await personRepository.leaveFromEvent(event.eventId);
        yield LeavingFromEvent();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is AllMembersOfEvent) {
      try {
        final members = await personRepository.getMembers(event.eventId);
        yield AllMembers(members);
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is ValidateSecretWordEvent) {
      try {
        final bool valid = await personRepository.validateSecretWord(event.nickNameAndSecretWord);
        yield ValidateSecretWordResult(valid);
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is ChangePasswordEvent) {
      try {
        await personRepository.changePassword(event.password, event.passwordRepeat, event.nickname);
        yield ChangePasswordSuccess();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is InitialEvent) {
      try {
        yield PersonsInitial();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    }
  }
}