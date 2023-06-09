import 'dart:async';
import 'dart:convert';
import 'package:boardgm/exceptions/CustomException.dart';
import 'package:boardgm/model/dto/event_dto.dart';
import 'package:boardgm/model/item.dart';
import 'package:boardgm/utils/preference.dart';
import 'package:boardgm/utils/yandexMapKit.dart';
import 'package:boardgm/widgets/ChatWidget.dart';
import 'package:http/http.dart' as http;

import '../model/event.dart';

class EventsApiClient {

  static const authorization = 'Authorization';
  static const bearer = 'Bearer ';
  static const contentType = 'Content-type';
  static const json = 'application/json';
  static const address = 'https://board-game-meet-dunad4n.cloud.okteto.net';

  Future<List> fetchMyEvents(int page) async {
    print(page);
    var url = Uri.parse('$address/myEvents?page=$page&size=20');
    final token = await Preference.getToken();
    var response = await http.get(url,
        headers: {authorization:
        bearer + token.toString()},);

    if (response.statusCode == 200) {
      // Парсим JSON-ответ и преобразуем его в список событий
      final List<dynamic> eventsJson = jsonDecode(utf8.decode(response.bodyBytes));
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка при загрузке событий');
    }
  }

  Future<List<MainPageEvent>> fetchEvents(String? search, int page) async {
    final Uri url;
    final city = await YandexMapKitUtil.getCityToSearch();
    if (search != null) {
      url = Uri.parse(
          '$address/events?city=$city&search=$search&page=$page&size=20');
    } else {
      url = Uri.parse(
          '$address/events?city=$city&page=$page&size=20');
    }
    final token = await Preference.checkToken() ? await Preference.getToken(): null;
    var response;
    if (token != null) {
      response = await http.get(url,
          headers: {authorization:
          bearer + token.toString()}
      );
    } else {
     response = await http.get(url);
    }

    if (response.statusCode == 200) {
      // Парсим JSON-ответ и преобразуем его в список событий
      final List<dynamic> jsonEvents = jsonDecode(utf8.decode(response.bodyBytes));
      List<MainPageEvent> mainPageEvents = [];
      for(var jsonEvent in jsonEvents) {
        mainPageEvents.add(MainPageEvent.fromJson(jsonEvent));
      }
      return mainPageEvents;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future fetchCreateEvent(CreateEventRequest request) async {
    var url = Uri.parse('$address/createEvent');
    final token = await Preference.getToken();
    final city = await YandexMapKitUtil.getCityByAddress(request.address);
    final msg = jsonEncode({
    "name": request.name,
    "game": request.game,
    "city": city,
    "address": request.address,
    "date": request.date.toIso8601String(),
    "maxPersonCount": request.maxPersonCount,
    "minAge": request.minAge,
    "maxAge": request.maxAge,
    "description": request.description
    });

    print(msg);

    var response = await http.post(url, body: msg,
        headers: {authorization:
        bearer + token.toString(), contentType:
        json}
    );


    if (response.statusCode == 200) {
      // Парсим JSON-ответ и преобразуем его в список событий
      return;
    } else if (response.statusCode == 409) {
      throw InputException(response.body);
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<Event> fetchEvent(int eventId) async {
    var url = Uri.parse('$address/event/$eventId');
    final token = await Preference.getToken();
    var response = await http.get(url,
        headers: {authorization:
        bearer + token.toString(),});

    if (response.statusCode == 200) {
      final dynamic eventJson = jsonDecode(utf8.decode(response.bodyBytes));
      Event event = Event.fromJson(eventJson);
      return event;
    } else if (response.statusCode == 471) {
      throw EventNotFoundException();
    } else {
      throw Exception("Ошибка при загрузке ивента с id=$eventId");
    }
  }

  Future<Event> fetchUpdateEvent(UpdateEventRequest request) async {
    var url = Uri.parse('$address/updateEvent');
    final token = await Preference.getToken();
    final city = await YandexMapKitUtil.getCityByAddress(request.address);
    final msg = jsonEncode({
      "id": request.id,
      "name": request.name,
      "game": request.game,
      "city": city,
      "address": request.address,
      "date": request.date.toIso8601String(),
      "maxPersonCount": request.maxPersonCount,
      "minAge": request.minAge,
      "maxAge": request.maxAge,
      "description": request.description
    });
    print(msg);

    var response = await http.put(url, body: msg,
      headers: {
        authorization: bearer + token.toString(),
        contentType: json
      }
    );

    if (response.statusCode == 200) {
      final dynamic eventJson = jsonDecode(utf8.decode(response.bodyBytes));
      Event event = Event.fromJson(eventJson);
      return event;
    } else if (response.statusCode == 409) {
      throw InputException(response.body);
    } else if (response.statusCode == 471) {
      throw EventNotFoundException();
    } else {
      throw Exception('Error while update event with code ${response.statusCode}');
    }
  }

  Future fetchKickPerson(int eventId, String userNickname) async {
    var url = Uri.parse('$address/kickPerson');
    final token = await Preference.getToken();

    final msg = jsonEncode({
      "eventId": eventId,
      "userNickname": userNickname
    });

    var response = await http.post(url, body: msg,
      headers: {
        authorization: bearer + token.toString(),
        contentType: json
      }
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 471) {
      throw EventNotFoundException();
    } else if (response.statusCode == 472) {
      throw PersonNotFoundException();
    } else {
      throw Exception('Error while ban person with code ${response.statusCode}');
    }
  }

  Future fetchDeleteEvent(int eventId) async {
    var url = Uri.parse('$address/deleteEvent/$eventId');
    final token = await Preference.getToken();

    var response = await http.delete(url, headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 471) {
      throw EventNotFoundException();
    } else {
      throw Exception('Error while delete event with code ${response.statusCode}');
    }
  }

  Future<List> fetchGetItems(int eventId) async {
    var url = Uri.parse('$address/getItemsIn/$eventId');
    final token = await Preference.getToken();

    var response = await http.get(url, headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonItems = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonItems.map((json) => Item.fromJson(json)).toList();
    } else if (response.statusCode == 471) {
      throw EventNotFoundException();
    } else if (response.statusCode == 473) {
      throw KickFromEventException();
    } else {
      throw Exception('Ошибка при получении нужных вещей с кодом'
                                                      '${response.statusCode}');
    }
  }

  Future fetchDeleteItems(int? eventId) async {
    var url = Uri.parse('$address/deleteItemsIn/$eventId');
    final token = await Preference.getToken();

    var response = await http.delete(url,
        headers: {
          authorization: bearer + token.toString()
        }
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 471) {
      throw EventNotFoundException();
    } else {
      throw Exception('Ошибка при удалении итемов ${response.statusCode}');
    }
  }

  Future fetchEditItemsIn(int eventId, List<Item> items) async {
    var url = Uri.parse('$address/editItemsIn/$eventId');
    final token = await Preference.getToken();
    var itemsMap = items.map((item) {
      return {
        "name": item.name,
        "marked": item.marked
      };
    }).toList();
    final msg = jsonEncode(itemsMap);

    var response = await http.put(url, body: msg,
      headers: {
        authorization: bearer + token.toString(),
        contentType: json
      }
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 471) {
      throw EventNotFoundException();
    } else {
      throw Exception('Ошибка при редактировании нужных предметов с кодом'
                                                      '${response.statusCode}');
    }
  }

  Future fetchMarkItemIn(int eventId, Item item) async {
    var url = Uri.parse('$address/markItemIn/$eventId');
    final token = await Preference.getToken();

    final msg = jsonEncode({
      "itemId": item.id,
      "markedStatus": item.marked
    });

    var response = await http.put(url, body: msg,
        headers: {
          authorization: bearer + token.toString(),
          contentType: json
        }
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 471) {
      throw EventNotFoundException();
    } else if (response.statusCode == 473) {
      throw KickFromEventException();
    } else {
      throw Exception('Ошибка при отметке нужных предметов с кодом'
                                                      '${response.statusCode}');
    }
  }

  Future<List> fetchMessages(int eventId, int page) async {
    var url = Uri.parse('$address/messagesIn/$eventId?page=$page&size=7');
    final token = await Preference.getToken();
    var response = await http.get(url,
      headers: {authorization:
      bearer + token.toString()},);

    if (response.statusCode == 200) {
      // Парсим JSON-ответ и преобразуем его в список событий
      final List<dynamic> messagesJson = jsonDecode(utf8.decode(response.bodyBytes));
      String? myNickname = await Preference.getNickname();
      return messagesJson.map((json) => ChatBubble.fromJson(json, myNickname)).toList();
    } else if (response.statusCode == 471) {
      throw EventNotFoundException();
    } else if (response.statusCode == 473) {
      throw KickFromEventException();
    } else {
      throw Exception('Ошибка при загрузке сообщений');
    }
  }

}