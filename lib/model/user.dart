// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    int id;
    String? profilePict;
    String nama;
    String email;
    // String password;
    dynamic emailVerifiedAt;
    dynamic rememberToken;
    dynamic createdAt;
    dynamic updatedAt;

    User({
        required this.id,
        required this.profilePict,
        required this.nama,
        required this.email,
        // required this.password,
        required this.emailVerifiedAt,
        required this.rememberToken,
        required this.createdAt,
        required this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        profilePict: json["profile_pict"],
        nama: json["nama"],
        email: json["email"],
        // password: json["password"],
        emailVerifiedAt: json["email_verified_at"],
        rememberToken: json["remember_token"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "profile_pict": profilePict,
        "nama": nama,
        "email": email,
        // "password": password,
        "email_verified_at": emailVerifiedAt,
        "remember_token": rememberToken,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
