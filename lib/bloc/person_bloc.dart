import 'dart:async';
import 'package:boardgm/model/dto/member_dto.dart';
import 'package:boardgm/model/member.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part '../events/persons_event.dart';
part '../states/persons_state.dart';


class PersonBloc extends Bloc<PersonsEvent, PersonsState> {
  final PersonsRepository repository;
  PersonBloc({required this.repository}) : super(PersonsInitial());

  @override
  Stream<PersonsState> mapEventToState(
      PersonsEvent event,
      ) async* {
    if (event is RegistrationPerson) {
      yield PersonsLoading();
      try {
        await repository.registration(event.member);
        yield RegistrationSuccess();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is AuthorizationPerson) {
      yield PersonsLoading();
      try {
        await repository.authorization(event.member);
        yield AuthorizationSuccess();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is LoadOwnProfile) {
      yield PersonsLoading();
      try {
        Member member =  await repository.getOwnProfile();
        yield OwnProfileLoaded(member);
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is LoadProfile) {
      yield PersonsLoading();
      try {
        Member member =  await repository.getProfile(event.nickname);
        yield OwnProfileLoaded(member);
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is ExitProfile) {
      yield PersonsLoading();
      try {
        await repository.exitProfile();
        print("exit profile");
        yield ExitSuccess();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is UpdateProfile) {
      yield PersonsLoading();
      try {
        await repository.updatePerson(UpdatePersonRequest(event.member.name,
            event.member.login, event.member.city, event.member.age, event.member.sex, 3));
        yield UpdateProfileSuccess();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    } else if (event is WatchEvent) {
      yield WatchingEvent();
    } else if (event is JoinToEvent) {
      yield PersonsLoading();
      try {
        await repository.joinToEvent(event.eventId);
        yield JoinedToEvent();
      } catch (e) {
        yield PersonsError(errorMessage: e.toString());
      }
    }
  }
}