part of '../bloc/events_bloc.dart';

@immutable
abstract class EventsEvent {}

class LoadEvents extends EventsEvent {
  final int userId;
  LoadEvents({required this.userId});
}