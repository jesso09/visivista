// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

import 'package:visivista/model/user.dart';

List<Task> taskFromJson(String str) => List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskToJson(List<Task> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
    int id;
    String idUser;
    // int idUser;
    String? idActuator;
    // int idActuator;
    String? idTeams;
    // int idTeams;
    String title;
    String description;
    String? actuator;
    DateTime start;
    DateTime end;
    String status;
    // int status;
    DateTime? createdAt;
    DateTime? updatedAt;
    User? user;
    User? actuatorUser;

    Task({
        required this.id,
        required this.idUser,
        required this.idActuator,
        required this.idTeams,
        required this.title,
        required this.description,
        required this.actuator,
        required this.start,
        required this.end,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
        required this.actuatorUser,
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        idUser: json["id_user"],
        idActuator: json["id_actuator"],
        idTeams: json["id_teams"],
        title: json["title"],
        description: json["description"],
        actuator: json["actuator"],
        start: DateTime.parse(json["start"]),
        end: DateTime.parse(json["end"]),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
        actuatorUser: json["actuator_user"] == null ? null : User.fromJson(json["actuator_user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "id_actuator": idActuator,
        "id_teams": idTeams,
        "title": title,
        "description": description,
        "actuator": actuator,
        "start": start.toIso8601String(),
        "end": end.toIso8601String(),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "actuator_user": actuatorUser?.toJson(),
    };
}
