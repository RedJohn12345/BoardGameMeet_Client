import 'dart:core';
import 'dart:ffi';

import '../Sex.dart';

class Profile {
  late String name;
  late String nickname;
  late int age;
  late String city;
  late int avatarId;
  late Sex sex;

  Profile({required this.name, required this.nickname, required this.age,
          required this.city, required this.avatarId, required this.sex});

  static fromJson(json) {
    return Profile(name: json['name'] as String,
                   nickname: json['nickname'] as String,
                   age: json['age'] as int,
                   city: json['city'] as String,
                   avatarId: json['avatarId'] as int,
                   sex: json['sex'] as Sex);
  }
}

class UpdatePersonRequest {
  late String name;
  late String nickname;
  late String city;
  late int? age;
  late Sex? gender;
  late int avatarId;

  UpdatePersonRequest(this.name, this.nickname, this.city,
                      this.age, this.gender, this.avatarId);
}

class MemberInEvent {
  late String nickname;
  late int? avatarId;
  late Bool isHost;

  MemberInEvent({required this.nickname, required this.avatarId, required this.isHost});

  static fromJson(json) {
    return MemberInEvent(nickname: json['nickname'] as String,
                         avatarId: json['avatarId'] as int,
                         isHost: json['host'] as Bool);
  }
}