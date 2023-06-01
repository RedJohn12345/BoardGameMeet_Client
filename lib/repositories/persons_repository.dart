
import '../apiclient/persons_api_client.dart';
import '../model/dto/member_dto.dart';
import '../model/member.dart';

class PersonsRepository {
  final PersonsApiClient apiClient;
  PersonsRepository({required this.apiClient});

  Future registration(Member member) async =>
      apiClient.fetchRegistration(member);

  Future authorization(Member member) async =>
      apiClient.fetchAuthorization(member);

  Future<Member> getProfile(String userNickname) async =>
      apiClient.fetchGetProfile(userNickname);

  Future<Member> getOwnProfile() async =>
      apiClient.fetchGetOwnProfile();

  Future updatePerson(UpdatePersonRequest request) async =>
      apiClient.fetchUpdatePerson(request);

  Future<List<MemberInEvent>> getMembers(int eventId) async =>
      apiClient.fetchGetMembers(eventId);

  Future deletePerson(String userNickname) async =>
      apiClient.fetchDeletePerson(userNickname);

  Future exitProfile() async =>
      apiClient.fetchExitProfile();

  Future joinToEvent(int? eventId) async =>
      apiClient.fetchJoinToEvent(eventId);

  Future leaveFromEvent(int? eventId) async =>
      apiClient.fetchLeaveFromEvent(eventId);

  Future<bool> validateSecretWord(NickNameAndSecretWord nickNameAndSecretWord) async =>
      apiClient.fetchValidateSecretWord(nickNameAndSecretWord.nickname, nickNameAndSecretWord.secretWord);

  Future changePassword(String password, String repeatPassword, String nickname) async =>
      apiClient.fetchChangePassword(password, repeatPassword, nickname);

  // Future changePassword(String password, String repeatPassword) async =>
  //     apiClient.fetchChangePassword(password, repeatPassword);

  Future<bool> isMyProfile(String nickname) async =>
      apiClient.fetchIsMyProfile(nickname);

  Future deleteItems(int? eventId) async =>
      apiClient.fetchDeleteItems(eventId);
}
