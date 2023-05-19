import 'dart:async';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../model/event.dart';
import '../repositories/events_repository.dart';
part '../events/events_event.dart';
part '../states/events_state.dart';


class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository repository;
  int page = 0;
  List<Event> listEvents = [];

  EventsBloc({required this.repository}) : super(EventsInitial());

  @override
  Stream<EventsState> mapEventToState(
      EventsEvent event,
      ) async* {
    if (event is LoadMyEvents) {
      if (page != 0) {
        yield EventsLoading();
      } else {
        yield EventsFirstLoading();
      }
      try {
        final events = await repository.getMyEvents(page);
        yield EventsLoaded(listEvents..addAll(events.cast<Event>()));
        page++;
      } catch (e) {
        yield EventsError(errorMessage: e.toString());
      }
    } else if (event is LoadEvents) {
      if (page != 0) {
        yield EventsLoading();
      } else {
        yield EventsFirstLoading();
      }
      try {
        final events = await repository.getEvents(event.city, event.search, page);
        yield EventsLoaded(listEvents..addAll(events.cast<Event>()));
        page++;
      } catch (e) {
        yield EventsError(errorMessage: e.toString());
      }
    } else if (event is LoadEvent) {
      yield EventsLoading();
      try {
        final responseEvent = await repository.getEvent(event.id);
        yield EventLoaded(responseEvent);
      } catch (e) {
        yield EventsError(errorMessage: e.toString());
      }
    } else if (event is CreateEvent) {
      yield EventsLoading();
      try {
        await repository.createEvent(event.event);
        yield EventCreated();
      } catch (e) {
        yield EventsError(errorMessage: e.toString());
      }
    }
  }
}