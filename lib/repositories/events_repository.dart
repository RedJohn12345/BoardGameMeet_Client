import 'dart:ffi';

import 'package:boardgm/model/dto/event_dto.dart';

import '../apiclient/events_api_client.dart';
import '../model/item.dart';

class EventsRepository {
  final EventsApiClient apiClient;

  EventsRepository({required this.apiClient});

  Future<List<dynamic>> getMyEvents(int page) async =>
      apiClient.fetchMyEvents(page);

  Future<List<dynamic>> getEvents(String city, String? search, int page) async =>
      apiClient.fetchEvents(city, search, page);

  Future createEvent(CreateEventRequest event) async =>
      apiClient.fetchCreateEvent(event);

  Future<dynamic> getEvent(int eventId) async =>
      apiClient.fetchEvent(eventId);

  Future updateEvent(UpdateEventRequest request) async =>
      apiClient.fetchUpdateEvent(request);

  Future banPerson(Long eventId, String userNickname) async =>
      apiClient.fetchBanPerson(eventId, userNickname);

  Future deleteEvent(Long eventId) async =>
      apiClient.fetchDeleteEvent(eventId);

  Future getItems(Long eventId) async =>
      apiClient.fetchGetItems(eventId);

  Future editItems(Long eventId, List<Item> items) async =>
      apiClient.fetchEditItemsIn(eventId, items);

  Future markItems(Long eventId, List<Item> items) async =>
      apiClient.fetchMarkItemsIn(eventId, items);
}
