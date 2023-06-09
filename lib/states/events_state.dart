part of '../bloc/events_bloc.dart';

@immutable
abstract class EventsState {}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsFirstLoading extends EventsState {}

class MyEventsLoaded extends EventsState {
  final List<Event> events;
  MyEventsLoaded(this.events);
}

class MainPageEventsLoaded extends EventsState {
  final List<MainPageEvent> events;
  MainPageEventsLoaded(this.events);
}

class EventCreated extends EventsState {
}

class EventUpdated extends EventsState {
  final Event event;

  EventUpdated(this.event);
}

class EventLoaded_State extends EventsState {
  final Event event;
  EventLoaded_State(this.event);
}

class ButtonEntry extends EventsState {
}

class EventsError extends EventsState {
  final String errorMessage;
  EventsError({required this.errorMessage});

  String getErrorMessageWithoutException() {
    return errorMessage.substring(11, errorMessage.length);
  }
}

class EventNotFoundError extends EventsState {
  final String errorMessage;

  EventNotFoundError({required this.errorMessage});
}

class EventInputError extends EventsState {
  final String errorMessage;

  EventInputError({required this.errorMessage});
}

class KickPersonError extends EventsState {
  final String errorMessage;

  KickPersonError({required this.errorMessage});
}

class MessagesLoaded extends EventsState {
  final List<ChatBubble> messages;
  MessagesLoaded(this.messages);
}

