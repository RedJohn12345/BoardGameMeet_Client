import 'dart:async';
import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/model/dto/event_dto.dart';
import 'package:boardgm/utils/preference.dart';
import 'package:boardgm/utils/yandexMapKit.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../model/event.dart';
import '../repositories/events_repository.dart';
import '../repositories/persons_repository.dart';
part '../events/events_event.dart';
part '../states/events_state.dart';


class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository eventsRepository;
  late PersonsRepository personsRepository;
  int page = 0;
  String? city;
  List<Event> listEvents = [];
  List<MainPageEvent> listMainPageEvents = [];

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
        if (await Preference.checkToken()) {
          personsRepository = PersonsRepository(apiClient: PersonsApiClient());
          final profile = await personsRepository.getOwnProfile();
          yield AvatarIsLoaded(profile.getAvatar(), profile.nickname);
        } else {
          yield ButtonEntry();
        }
        final events = await eventsRepository.getMyEvents(page);
        yield MyEventsLoaded(listEvents..addAll(events.cast<Event>()));
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
        if (await Preference.checkToken()) {
          personsRepository = PersonsRepository(apiClient: PersonsApiClient());
          final profile = await personsRepository.getOwnProfile();
          yield AvatarIsLoaded(profile.getAvatar(), profile.nickname);
          city = profile.city;
        } else {
          yield ButtonEntry();
          city = await YandexMapKitUtil.getCity();
        }
        final events = await eventsRepository.getEvents(city!, event.search, page);
        yield MainPageEventsLoaded(listMainPageEvents..addAll(events.cast<MainPageEvent>()));
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
  }
}