import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class People {
  String? name;
  String? height;
  String? mass;
  String? birthYear;
  String? gender;
  String? homeworld;
  String? hairColor;
  String? skinColor;
  String? eyeColor;
  int? no;

  People(
      {@required this.name,
      @required this.height,
      @required this.mass,
      @required this.birthYear,
      @required this.gender,
      @required this.homeworld,
      @required this.hairColor,
      @required this.skinColor,
      @required this.eyeColor,
      @required this.no});

  factory People.fromJson(Map<String, dynamic> json) => People(
        name: json["name"],
        height: json["height"],
        mass: json["mass"],
        hairColor: json["hair_color"],
        skinColor: json["skin_color"],
        eyeColor: json["eye_color"],
        birthYear: json["birth_year"],
        gender: json["gender"],
        homeworld: json["homeworld"],
        no: int.parse(json["url"]
            .toString()
            .substring(29, json["url"].toString().length - 1)),
      );
}

class StarwarsRepo {
  Future<List<People>> fetchPeople({int page = 1}) async {
    var response = await Dio().get('https://swapi.dev/api/people/?page=$page');
    List<dynamic> results = response.data['results'];
    return results.map((it) => People.fromJson(it)).toList();
  }
}
