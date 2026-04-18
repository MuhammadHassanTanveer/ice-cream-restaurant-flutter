// To parse this JSON data, do
//
//     final restaurantTableModel = restaurantTableModelFromJson(jsonString);

import 'dart:convert';

List<RestaurantTableModel> restaurantTableModelFromJson(String str) => List<RestaurantTableModel>.from(json.decode(str).map((x) => RestaurantTableModel.fromJson(x)));

String restaurantTableModelToJson(List<RestaurantTableModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RestaurantTableModel {
  final int restaurantTableId;
  final String restaurantTableName;
  final DateTime createdAt;
  final DateTime updatedAt;

  RestaurantTableModel({
    required this.restaurantTableId,
    required this.restaurantTableName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RestaurantTableModel.fromJson(Map<String, dynamic> json) => RestaurantTableModel(
    restaurantTableId: json["restaurant_table_id"],
    restaurantTableName: json["restaurantTableName"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "restaurant_table_id": restaurantTableId,
    "restaurantTableName": restaurantTableName,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
