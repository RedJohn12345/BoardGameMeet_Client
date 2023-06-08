import 'package:boardgm/model/dto/event_dto.dart';

import '../apiclient/events_api_client.dart';
import '../model/event.dart';
import '../model/item.dart';

class EventsRepository {
  final EventsApiClient apiClient;

  EventsRepository({required this.apiClient});

  Future<List<dynamic>> getMyEvents(int page) async =>
      apiClient.fetchMyEvents(page);

  Future<List<MainPageEvent>> getEvents(String? search, int page) async =>
      apiClient.fetchEvents(search, page);

  Future createEvent(CreateEventRequest event) async =>
      apiClient.fetchCreateEvent(event);

  Future<Event> getEvent(int eventId) async =>
      apiClient.fetchEvent(eventId);

  Future updateEvent(UpdateEventRequest request) async =>
      apiClient.fetchUpdateEvent(request);

  Future kickPerson(int eventId, String userNickname) async =>
      apiClient.fetchKickPerson(eventId, userNickname);

  Future deleteEvent(int eventId) async =>
      apiClient.fetchDeleteEvent(eventId);

  Future getItems(int eventId) async =>
      apiClient.fetchGetItems(eventId);

  Future editItems(int eventId, List<Item> items) async =>
      apiClient.fetchEditItemsIn(eventId, items);

  Future deleteItems(int? eventId) async =>
      apiClient.fetchDeleteItems(eventId);

  Future markItem(int eventId, Item item) async =>
      apiClient.fetchMarkItemIn(eventId, item);

  Future<List<dynamic>> getMessages(int eventId, int page) async =>
      apiClient.fetchMessages(eventId, page);
}
