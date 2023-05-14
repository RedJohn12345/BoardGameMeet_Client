part of '../bloc/events_bloc.dart';

@immutable
abstract class EventsEvent {}

class LoadMyEvents extends EventsEvent {
}

class LoadEvents extends EventsEvent {
}