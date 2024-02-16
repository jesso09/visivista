// To parse this JSON data, do
//
//     final content = contentFromJson(jsonString);

import 'dart:convert';

import 'package:visivista/model/idea.dart';

List<Content> contentFromJson(String str) => List<Content>.from(json.decode(str).map((x) => Content.fromJson(x)));

String contentToJson(List<Content> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Content {
    int id;
    String idUser;
    String? idIdea;
    String? photo;
    String? video;
    String? title;
    String? caption;
    String? hashtag;
    String? voiceOverTeks;
    String? team;
    DateTime? postScheduled;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    Idea? idea;

    Content({
        required this.id,
        required this.idUser,
        required this.idIdea,
        required this.photo,
        required this.video,
        required this.title,
        required this.caption,
        required this.hashtag,
        required this.voiceOverTeks,
        required this.team,
        required this.postScheduled,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.idea,
    });

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        idUser: json["id_user"],
        idIdea: json["id_idea"],
        photo: json["photo"],
        video: json["video"],
        title: json["title"],
        caption: json["caption"],
        hashtag: json["hashtag"],
        voiceOverTeks: json["voice_over_teks"],
        team: json["team"],
        postScheduled: json["post_scheduled"] == null ? null : DateTime.parse(json["post_scheduled"]),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        idea: json["idea"] == null ? null : Idea.fromJson(json["idea"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "id_idea": idIdea,
        "photo": photo,
        "video": video,
        "title": title,
        "caption": caption,
        "hashtag": hashtag,
        "voice_over_teks": voiceOverTeks,
        "team": team,
        "post_scheduled": postScheduled?.toIso8601String(),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "idea": idea?.toJson(),
    };
}
