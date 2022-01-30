// To parse this JSON data, do
//
//     final voter = voterFromJson(jsonString);

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voterslist/model/response.dart';

Voter voterFromJson(String str) => Voter.fromJson(json.decode(str));

String voterToJson(Voter data) => json.encode(data.toJson());
final FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference<Map<String, dynamic>> voters = firestore.collection('Voters');

class Voter {
  Voter(
      {required this.name,
      required this.id,
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
  bool male;

  get searchArray {
    // Map<String, dynamic> search;
    var search = [];
    int i, j;
    for (i = 0; i < name.length; i++) {
      var tempName = name.substring(0, i);
      if (tempName.length > 2) {
        search.add(tempName);
      }
    }
    search.add(name);
    for (i = 0; i < father.length; i++) {
      var tempfather = father.substring(0, i);
      if (tempfather.length > 2) {
        search.add(tempfather);
      }
    }

    father.isEmpty ? doNothing() : search.add(father);
    for (i = 0; i < husband.length; i++) {
      var temphusband = husband.substring(0, i);
      if (temphusband.length > 2) {
        search.add(temphusband);
      }
    }

    husband.isEmpty ? doNothing() : search.add(husband);
    return search;
  }

  Future<Response> add() async {
    return await voters.doc(id).set(toJson()).then((value) => Response.success("Voter added")).onError((error, stackTrace) => Response.error(error));
  }

  factory Voter.fromJson(Map<String, dynamic> json) => Voter(
        name: json["name"],
        id: json["id"],
        father: json["father"],
        husband: json["husband"],
        door: json["door"],
        age: json["age"],
        male: json["male"],
        partNumber: json["partNumber"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "father": father,
        "husband": husband,
        "door": door,
        "age": age,
        "partNumber": partNumber,
        "male": male,
        "search": searchArray,
      };
}

doNothing() {}
