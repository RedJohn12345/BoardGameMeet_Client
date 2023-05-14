import 'dart:async';
import 'package:boardgm/bloc/events_bloc.dart';
import 'package:boardgm/model/member.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../model/event.dart';
import '../repositories/events_repository.dart';
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
    }
  }
}