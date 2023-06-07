import 'dart:async';
import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/model/dto/event_dto.dart';
import 'package:boardgm/utils/preference.dart';
import 'package:boardgm/widgets/ChatWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/event.dart';
import '../model/item.dart';
import '../repositories/events_repository.dart';
import '../repositories/persons_repository.dart';
part '../events/events_event.dart';
part '../states/events_state.dart';


class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository eventsRepository;
  late PersonsRepository personsRepository;
  int page = 0;
  String? city;
  List<dynamic> list = [];
  // List<MainPageEvent> listMainPageEvents = [];
  // List<MainPageEvent> listMainPageEvents = [];


  EventsBloc({required this.eventsRepository}) : super(EventsInitial());

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
        final events = await eventsRepository.getMyEvents(page);
        yield MyEventsLoaded((list..addAll(events)).cast<Event>());
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
        final events = await eventsRepository.getEvents(event.search, page);
        yield MainPageEventsLoaded((list..addAll(events)).cast<MainPageEvent>());
        // yield MainPageEventsLoaded(events);
        page++;
      } catch (e) {
        yield EventsError(errorMessage: e.toString());
      }
    } else if (event is LoadEvent) {
      yield EventsLoading();
      try {
        final responseEvent = await eventsRepository.getEvent(event.id);
        yield EventLoaded_State(responseEvent);
      } catch (e) {
        yield EventsError(errorMessage: e.toString());
      }
    } else if (event is CreateEvent) {
      yield EventsLoading();
      try {
        await eventsRepository.createEvent(event.event);
        yield EventCreated();
      } catch (e) {
        yield EventsError(errorMessage: e.toString());
      }
    } else if (event is UpdateEvent) {
      yield EventsLoading();
      try {
        await eventsRepository.updateEvent(event.event);
        yield EventUpdated();
      } catch (e) {
        yield EventsError(errorMessage: e.toString());
      }
    }
    if (event is LoadMessages) {
      print("hola");
      if (page == 0) {
        yield EventsFirstLoading();
      }
      try {
        final messages = await eventsRepository.getMessages(event.eventId, page);
        yield MessagesLoaded((list..addAll(messages)).cast<ChatBubble>());
        page++;
      } catch (e) {
        yield EventsError(errorMessage: e.toString());
      }
    }
  }

}