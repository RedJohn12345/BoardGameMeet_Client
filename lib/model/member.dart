import 'Sex.dart';
import 'item.dart';

class Member {
  late String name;
  late String login;
  late String pathToAvatar;
  late int age;
  late String city;
  late Sex sex;
  late String password;
  late String secretWord;

  Member({this.name = "", this.pathToAvatar = "",
    required this.login, this.age = 0, this.city = "", this.sex = Sex.NONE,
    this.password = "", this.secretWord = ""
  });


  static fromJson(json) {
    int avatarId = json['avatarId'] == null ? 1 : json['avatarId'] as int;
    Member member =  Member(name: json['name'] as String, pathToAvatar: "assets/images/$avatarId.jpg",
    login: json['nickname'] as String, age: json['age'] == null ? 0 : json['age'] as int, city: json['city'] as String,
        sex: json['gender'] as String == "MALE" ? Sex.MAN : Sex.WOMAN);
    return member;
  }

  /*Event({required this.name, required this.game, required this.date,
    required this.location, required this.numberPlayers, required this.maxNumberPlayers, required this});*/

}