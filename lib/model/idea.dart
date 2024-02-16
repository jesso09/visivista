// To parse this JSON data, do
//
//     final idea = ideaFromJson(jsonString);

import 'dart:convert';

import 'package:visivista/model/content.dart';

List<Idea> ideaFromJson(String str) => List<Idea>.from(json.decode(str).map((x) => Idea.fromJson(x)));

String ideaToJson(List<Idea> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Idea {
    int id;
    dynamic idUser;
    String title;
    String? description;
    DateTime tglPelaksanaan;
    DateTime? createdAt;
    DateTime? updatedAt;
    List<Content> content;

    Idea({
        required this.id,
        required this.idUser,
        required this.title,
        required this.description,
        required this.tglPelaksanaan,
        required this.createdAt,
        required this.updatedAt,
        required this.content,
    });

    factory Idea.fromJson(Map<String, dynamic> json) => Idea(
        id: json["id"],
        idUser: json["id_user"],
        title: json["title"],
        description: json["description"],
        tglPelaksanaan: DateTime.parse(json["tgl_pelaksanaan"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        content: List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "title": title,
        "description": description,
        "tgl_pelaksanaan": tglPelaksanaan.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
    };
}
