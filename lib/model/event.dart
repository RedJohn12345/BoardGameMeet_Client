import 'item.dart';

class Event {
  late String name;
  late String game;
  late DateTime date;
  late String location;
  late int numberPlayers;
  late int maxNumberPlayers;
  late String description;
  late List<Item> items;

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
}