// To parse this JSON data, do
//
//     final taxModel = taxModelFromJson(jsonString);

import 'dart:convert';

TaxModel taxModelFromJson(String str) => TaxModel.fromJson(json.decode(str));

String taxModelToJson(TaxModel data) => json.encode(data.toJson());

class TaxModel {
  final int? id;
  final String? type;
  final String? value;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaxModel({
    this.id,
    this.type,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) => TaxModel(
    id: json["id"],
    type: json["type"],
    value: json["value"],
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "value": value,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
