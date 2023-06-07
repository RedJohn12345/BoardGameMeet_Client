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

class MessagesLoaded extends EventsState {
  final List<ChatBubble> messages;
  MessagesLoaded(this.messages);
}