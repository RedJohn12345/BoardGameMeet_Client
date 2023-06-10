import 'Sex.dart';

class Member {
  late String name;
  late String nickname;
  late int avatarId;
  late int? age;
  late String city;
  late Sex sex;
  late String password;
  late String secretWord;

  Member({this.name = "", this.avatarId = 1,
    required this.nickname, this.age, this.city = "", this.sex = Sex.NONE,
    this.password = "", this.secretWord = ""
  });

  static fromJson(json) {

    Member member =  Member(name: json['name'] as String, avatarId: json['avatarId'] == null ? 1 : json['avatarId'] as int,
    nickname: json['nickname'] as String, age: json['age'] as int?, city: json['city'] as String,
        sex: json['gender'] as String == "MALE" ? Sex.MAN : (json['gender'] as String == "FEMALE" ? Sex.WOMAN : Sex.NONE));
    return member;
  }

  String getAvatar() {
    return "assets/images/$avatarId.jpg";
  }

  /*Event({required this.name, required this.game, required this.date,
    required this.location, required this.numberPlayers, required this.maxNumberPlayers, required this});*/

}