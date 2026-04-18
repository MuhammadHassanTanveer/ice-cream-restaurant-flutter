// To parse this JSON data, do
//
//     final taxModel = taxModelFromJson(jsonString);

import 'dart:convert';

TaxModel taxModelFromJson(String str) => TaxModel.fromJson(json.decode(str));

String taxModelToJson(TaxModel data) => json.encode(data.toJson());

class TaxModel {
  final int id;
  final String type;
  final String value;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaxModel({
    required this.id,
    required this.type,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) => TaxModel(
    id: json["id"],
    type: json["type"],
    value: json["value"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "value": value,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
