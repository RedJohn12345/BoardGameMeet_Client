
import 'dart:ffi';

import '../apiclient/persons_api_client.dart';
import '../model/dto/member_dto.dart';
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

  Future<Profile> getProfile(String userNickname) async =>
      apiClient.fetchGetProfile(userNickname);

  Future updatePerson(UpdatePersonRequest request) async =>
      apiClient.fetchUpdatePerson(request);

  Future<List> getMembers(Long eventId) async =>
      apiClient.fetchGetMembers(eventId);

  Future deletePerson(String userNickname) async =>
      apiClient.fetchDeletePerson(userNickname);

  Future joinToEvent(Long eventId) async =>
      apiClient.fetchJoinToEvent(eventId);

  Future leaveFromEvent(Long eventId) async =>
      apiClient.fetchLeaveFromEvent(eventId);

  Future validateSecretWord(String secretWord) async =>
      apiClient.fetchValidateSecretWord(secretWord);

  Future changePassword(String password, String repeatPassword) async =>
      apiClient.fetchChangePassword(password, repeatPassword);
}
