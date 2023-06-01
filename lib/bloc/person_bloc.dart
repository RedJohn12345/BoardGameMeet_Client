import 'dart:async';
import 'package:boardgm/apiclient/events_api_client.dart';
import 'package:boardgm/model/dto/member_dto.dart';
import 'package:boardgm/model/member.dart';
import 'package:boardgm/repositories/events_repository.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/event.dart';
part '../events/persons_event.dart';
part '../states/persons_state.dart';


class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonsRepository personRepository;
  PersonBloc({required this.personRepository}) : super(PersonsInitial());

  @override
  Stream<PersonState> mapEventToState(
      PersonEvent event,
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
        bool profileStatus = await personRepository.isMyProfile(event.nickname);
        yield ProfileLoaded(member, profileStatus);
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is ExitProfile) {
      yield PersonsLoading();
      try {
        await personRepository.exitProfile();
        yield ExitSuccess();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is UpdateProfile) {
      yield PersonsLoading();
      try {
        await personRepository.updatePerson(UpdatePersonRequest(event.member.name,
            event.member.nickname, event.member.city, event.member.age, event.member.sex, event.member.avatarId));
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
        var eventRepository = EventsRepository(apiClient: EventsApiClient());
        Event selectedEvent = await eventRepository.getEvent(event.eventId!);
        yield JoinedToEvent(selectedEvent);
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
    } else if (event is DeleteEvent) {
      try {
        var eventRepository = EventsRepository(apiClient: EventsApiClient());
        await eventRepository.deleteEvent(event.eventId);
        yield DeletingEvent();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is KickPerson) {
      try {
        var eventRepository = EventsRepository(apiClient: EventsApiClient());
        await eventRepository.kickPerson(event.eventId, event.nickname);
        yield KickingPerson();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    }
  }
}