part of '../bloc/events_bloc.dart';

@immutable
abstract class EventsEvent {}

class LoadMyEvents extends EventsEvent {
  LoadMyEvents();

}

class LoadEvents extends EventsEvent {
  final String? search;

  LoadEvents(this.search);
}

class LoadEvent extends EventsEvent {
  final int id;

  LoadEvent(this.id);
}

class EventLoaded_Event extends EventsEvent {
  final Event event;

  EventLoaded_Event(this.event);
}

class CreateEvent extends EventsEvent {
  final CreateEventRequest event;

  CreateEvent(this.event);
}