import 'item.dart';

class Event {
  late String name;
  late String game;
  late String city;
  late DateTime? date;
  late String location;
  late int numberPlayers;
  late int maxNumberPlayers;
  late String description;
  Map<Item, bool> items = {};

  late int minAge;
  late int maxAge;

  Event({this.name = "", this.game = "",
    this.location = "", this.numberPlayers = 0,  this.maxNumberPlayers = 0, this.description = "",});

  /*Event({required this.name, required this.game, required this.date,
    required this.location, required this.numberPlayers, required this.maxNumberPlayers, required this});*/


  String viewCountPlayers() {
    return "$numberPlayers/$maxNumberPlayers";
  }

  static fromJson(json) {
    Event event =  Event(name: json['name'] as String, game: json['game'] as String, location: json['address'] as String,
      numberPlayers: json['curPersonCount'] as int, maxNumberPlayers: json['maxPersonCount'] as int,
      description: "", );
    event.date = DateTime.parse(json['date'] as String);
    return event;
  }
}