import '../apiclient/events_api_client.dart';
import 'package:flutter/cupertino.dart';

import '../model/event.dart';

class EventsRepository {
  final EventsApiClient apiClient;
  EventsRepository({required this.apiClient});
  Future<List<dynamic>> getMyEvents() async =>
      apiClient.fetchMyEvents();

  Future<List<dynamic>> getEvents() async =>
      apiClient.fetchEvents();
}
