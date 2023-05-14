import '../apiclient/events_api_client.dart';
import 'package:flutter/cupertino.dart';

import '../apiclient/persons_api_client.dart';
import '../model/event.dart';
import '../model/member.dart';

class PersonsRepository {
  final PersonsApiClient apiClient;
  PersonsRepository({required this.apiClient});
  Future<List<dynamic>> getMyEvents() async =>
      apiClient.fetchMyEvents();

  Future registration(Member member) async =>
      apiClient.fetchRegistration(member);

  Future authorization(Member member) async =>
      apiClient.fetchAuthorization(member);
}
