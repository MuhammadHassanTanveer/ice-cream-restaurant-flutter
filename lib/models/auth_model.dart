// To parse this JSON data, do
//
//     final authModel = authModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  final Success success;

  AuthModel({
    required this.success,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    success: Success.fromJson(json["success"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success.toJson(),
  };
}

class Success {
  final String token;
  final User user;

  Success({
    required this.token,
    required this.user,
  });

  factory Success.fromJson(Map<String, dynamic> json) => Success(
    token: json["token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };
}

class User {
  final int id;
  final String name;
  final dynamic surname;
  final String email;
  final String phone;
  final String address;
  final dynamic photo;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.address,
    required this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    surname: json["surname"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "surname": surname,
    "email": email,
    "phone": phone,
    "address": address,
    "photo": photo,
  };
}
