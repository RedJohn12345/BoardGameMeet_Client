
import 'dart:core';
import 'dart:ffi';

import 'package:boardgm/model/event.dart';
import 'package:boardgm/utils/yandexMapKit.dart';

class UpdateEventRequest {
  late int id;
  late String name;
  late String game;
  late String address;
  late DateTime date;
  late int maxPersonCount;
  late int? minAge;
  late int? maxAge;
  late String description;

  UpdateEventRequest({required this.id, required this.name, required this.game, required this.address,
      required this.date, required this.maxPersonCount, required this.minAge,  required this.maxAge, required this.description});

}

class CreateEventRequest {
  late String name;
  late String game;
  late String address;
  late DateTime date;
  late int maxPersonCount;
  late int? minAge;
  late int? maxAge;
  late String description;

  CreateEventRequest({required this.name, required this.game, required this.address, required this.date, required this.maxPersonCount,
                      required this.minAge, required this.maxAge, required this.description});
}

class MainPageEvent {
  late int id;
  late String name;
  late String game;
  late String address;
  late DateTime date;
  late int curPersonCount;
  late int maxPersonCount;
  late int? minAge;
  late int? maxAge;

  MainPageEvent({required this.id, required this.name, required this.game,
                 required this.address, required this.date, required this.curPersonCount,
                 required this.maxPersonCount, required this.minAge, required this.maxAge});

  String viewCountPlayers() {
    return "$curPersonCount/$maxPersonCount";
  }

  static fromJson(json) {
    return MainPageEvent(id: json['id'] as int,
                        name: json['name'] as String,
                        game: json['game'] as String,
                        address: json['address'] as String,
                        date: DateTime.parse(json['date'] as String),
                        curPersonCount: json['curPersonCount'] as int,
                        maxPersonCount: json['maxPersonCount'] as int,
                        minAge: json['minAge'] as int?,
                        maxAge: json['maxAge'] as int?);
  }
}