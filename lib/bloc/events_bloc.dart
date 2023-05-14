import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../model/event.dart';
import '../repositories/events_repository.dart';
part '../events/events_event.dart';
part '../states/events_state.dart';


class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository repository;
  EventsBloc({required this.repository}) : super(EventsInitial());

  @override
  Stream<EventsState> mapEventToState(
      EventsEvent event,
      ) async* {
    if (event is LoadMyEvents) {
      yield EventsLoading();
      try {
        final events = await repository.getMyEvents();
        yield EventsLoaded(events.cast<Event>());
      } catch (e) {
        yield EventsError(errorMessage: e.toString());
      }
    } else if (event is LoadEvents) {
      try {
        final events = await repository.getEvents();
        yield EventsLoaded(events.cast<Event>());
      } catch (e) {
        yield EventsError(errorMessage: e.toString());
      }
    }
  }
}