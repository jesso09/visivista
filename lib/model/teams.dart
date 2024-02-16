// To parse this JSON data, do
//
//     final teams = teamsFromJson(jsonString);

import 'dart:convert';

import 'package:visivista/model/user.dart';

Teams teamsFromJson(String str) => Teams.fromJson(json.decode(str));

String teamsToJson(Teams data) => json.encode(data.toJson());

class Teams {
  int id;
  String idOwner;
  // int idOwner;
  String teamName;
  DateTime createdAt;
  DateTime updatedAt;
  User? user;

  Teams({
    required this.id,
    required this.idOwner,
    required this.teamName,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Teams.fromJson(Map<String, dynamic> json) => Teams(
        id: json["id"],
        idOwner: json["id_owner"],
        teamName: json["team_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
        // member: Member.fromJson(json["member"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_owner": idOwner,
        "team_name": teamName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user?.toJson(),
        // "member": member?.toJson(),
      };
}
