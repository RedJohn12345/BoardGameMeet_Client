
import 'dart:core';
import 'dart:ffi';

class UpdateEventRequest {
  late Long id;
  late String name;
  late String game;
  late String city;
  late String address;
  late DateTime date;
  late int maxPersonCount;
  late int minAge;
  late int maxAge;
  late String description;

  UpdateEventRequest(this.id, this.name, this.game, this.city, this.address,
      this.date, this.maxPersonCount, this.minAge, this.maxAge, this.description);
}

class CreateEventRequest {
  late String name;
  late String game;
  late String city;
  late String address;
  late DateTime date;
  late int maxPersonCount;
  late int? minAge;
  late int? maxAge;
  late String description;

  CreateEventRequest({required this.name, required this.game, required this.city,
                      required this.address, required this.date, required this.maxPersonCount,
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