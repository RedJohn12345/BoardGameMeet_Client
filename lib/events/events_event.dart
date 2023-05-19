part of '../bloc/events_bloc.dart';

@immutable
abstract class EventsEvent {}

class LoadMyEvents extends EventsEvent {
  LoadMyEvents();

}

class LoadEvents extends EventsEvent {
  final String city;
  final String? search;

  LoadEvents(this.city, this.search);
}

class LoadEvent extends EventsEvent {
  final Long id;

  LoadEvent(this.id);
}

class CreateEvent extends EventsEvent {
  final Event event;

  CreateEvent(this.event);
}