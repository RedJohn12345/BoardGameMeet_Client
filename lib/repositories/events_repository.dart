import '../apiclient/events_api_client.dart';
import 'package:flutter/cupertino.dart';

import '../model/event.dart';

class EventsRepository {
  final EventsApiClient apiClient;

  EventsRepository({required this.apiClient});

  Future<List<dynamic>> getMyEvents(int page) async =>
      apiClient.fetchMyEvents(page);

  Future<List<dynamic>> getEvents(String city, String search, int page) async =>
      apiClient.fetchEvents(city, search, page);
}
