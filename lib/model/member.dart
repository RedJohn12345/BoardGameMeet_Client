import 'Sex.dart';
import 'item.dart';

class Member {
  late String name;
  late String login;
  late String pathToAvatar;
  late int age;
  late String city;
  late Sex sex;

  Member({required this.name, this.pathToAvatar = "",
    required this.login, this.age = 0, required this.city, this.sex = Sex.NONE
  });

  /*Event({required this.name, required this.game, required this.date,
    required this.location, required this.numberPlayers, required this.maxNumberPlayers, required this});*/

}