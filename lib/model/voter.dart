// To parse this JSON data, do
//
//     final voter = voterFromJson(jsonString);

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voterslist/json_data.dart';
import 'package:voterslist/model/response.dart';

Voter voterFromJson(String str) => Voter.fromJson(json.decode(str));

String voterToJson(Voter data) => json.encode(data.toJson());
final FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference<Map<String, dynamic>> voters = firestore.collection('Voters');

class Voter {
  Voter(
      {required this.name,
      required this.id,
      required this.sNo,
      this.father = '',
      this.husband = '',
      required this.door,
      required this.age,
      required this.male,
      required this.partNumber});

  String name;
  String id;
  String father;
  String husband;
  String door;
  int age;
  int partNumber;
  int sNo;
  bool male;

  search(String searchItem) {
    Map<String, dynamic> search = {};
    List<String> texts = searchItem.split(" ");
    for (var text in texts) {
      for (var i = 0; i < text.length; i++) {
        var tempText = text.substring(0, i).toLowerCase();
        if (tempText.length > 2) {
          search[tempText] = true;
        }
      }
      search[text.toLowerCase()] = true;
    }
    return search;
  }

  Future<Response> add() async {
    return await voters.doc(id).set(toJson()).then((value) => Response.success("Voter added")).onError((error, stackTrace) => Response.error(error));
  }

  static loadDummyData() async {
    var voters = (await getJson()).map((e) => Voter.fromJson(e)).toList();
    for (var voter in voters) {
      print(voter.toJson());
      voter.add().then((value) => Response.success("Added ${voter.id}"));
    }
  }

  factory Voter.fromJson(Map<String, dynamic> json) => Voter(
        name: json["name"],
        id: json["id"],
        father: json["father"],
        husband: json["husband"] ?? '',
        door: json["door"],

        age: json["age"],
        male: json["male"],
        partNumber: json["partNumber"],
        sNo: json["sNo"],

        // age: int.parse(json["age"]),
        // male: json["male"] == "TRUE" ? true : false,
        // partNumber: int.parse(json["partNumber"]),
        // sNo: int.parse(json["sNo"]),
      );

  Map<String, dynamic> toJson() => {
        "sNo": sNo,
        "name": name,
        "id": id,
        "father": father,
        "husband": husband,
        "door": door,
        "age": age,
        "partNumber": partNumber,
        "male": male,
        "searchFather": search(father),
        "searchName": search(name),
      };
}

doNothing() {}
