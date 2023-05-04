import 'item.dart';

class Event {
  late String name;
  late String game;
  late DateTime date;
  late String location;
  late int numberPlayers;
  late int maxNumberPlayers;
  late String description;
  late Map<Item, bool> items;

  /*late int minAge;
  late int maxAge;*/

  Event({required this.name, required this.game, required this.date,
    required this.location, required this.numberPlayers, required this.maxNumberPlayers, required this.description,
  required this.items});

  /*Event({required this.name, required this.game, required this.date,
    required this.location, required this.numberPlayers, required this.maxNumberPlayers, required this});*/


  String viewCountPlayers() {
    return "$numberPlayers/$maxNumberPlayers";
  }

  static fromJson(json) {
    final itemsJson = json['items'] as Map<dynamic, bool>;
    final itemsMap = <Item, bool>{};
    itemsJson.forEach((key, value) {
      itemsMap[Item.fromJson(key)] = value;
    });
    return Event(name: json['name'] as String, game: json['game'] as String,
        date: DateTime.parse(json['date'] as String), location: json['location'] as String,
        numberPlayers: json['numberPlayers'] as int, maxNumberPlayers: json['maxNumberPlayers'] as int,
        description: json['description'] as String, items: itemsMap);
  }
}