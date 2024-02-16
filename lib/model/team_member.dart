// To parse this JSON data, do
//
//     final teamMember = teamMemberFromJson(jsonString);

import 'dart:convert';

import 'package:visivista/model/teams.dart';
import 'package:visivista/model/user.dart';

TeamMember teamMemberFromJson(String str) => TeamMember.fromJson(json.decode(str));

String teamMemberToJson(TeamMember data) => json.encode(data.toJson());

class TeamMember {
    int id;
    String idTeam;
    // int idTeam;
    String idUser;
    // int idUser;
    dynamic createdAt;
    dynamic updatedAt;
    User? user;
    Teams? team;

    TeamMember({
        required this.id,
        required this.idTeam,
        required this.idUser,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
        required this.team,
    });

    factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
        id: json["id"],
        idTeam: json["id_team"],
        idUser: json["id_user"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        user: User.fromJson(json["user"]),
        team: Teams.fromJson(json["team"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_team": idTeam,
        "id_user": idUser,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user": user?.toJson(),
        "team": team?.toJson(),
    };
}