part of '../bloc/events_bloc.dart';

@immutable
abstract class EventsState {}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsFirstLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<Event> events;
  EventsLoaded(this.events);
}

class EventLoaded extends EventsState {
  final Event event;
  EventLoaded(this.event);
}

class EventsError extends EventsState {
  final String errorMessage;
  EventsError({required this.errorMessage});
}