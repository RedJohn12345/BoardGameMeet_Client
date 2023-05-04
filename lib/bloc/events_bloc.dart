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
    if (event is LoadEvents) {
      yield EventsLoading();
      try {
        final events = await repository.getEvents(event.userId);
        yield EventsLoaded(events as List<Event>);
      } catch (e) {
        yield EventsError(errorMessage: e.toString());
      }
    }
  }
}