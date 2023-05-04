import '../apiclient/events_api_client.dart';
import 'package:flutter/cupertino.dart';

import '../model/event.dart';

class EventsRepository {
  final EventsApiClient apiClient;
  EventsRepository({required this.apiClient});
  Future<Future<List>> getEvents(int userId) async =>
      apiClient.fetchEvents(userId);
}
