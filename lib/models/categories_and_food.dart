// To parse this JSON data, do
//
//     final categoryAndFoodModel = categoryAndFoodModelFromJson(jsonString);

import 'dart:convert';

CategoryAndFoodModel categoryAndFoodModelFromJson(String str) => CategoryAndFoodModel.fromJson(json.decode(str));

String categoryAndFoodModelToJson(CategoryAndFoodModel data) => json.encode(data.toJson());

class CategoryAndFoodModel {
  final List<Category> categories;

  CategoryAndFoodModel({
    required this.categories,
  });

  factory CategoryAndFoodModel.fromJson(Map<String, dynamic> json) => CategoryAndFoodModel(
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  final int id;
  final String name;
  final List<Food> foods;

  Category({
    required this.id,
    required this.name,
    required this.foods,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
  };
}

class Food {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final bool hasVariations;
  final int price;
  final int? discountPrice;
  final List<Variation>? variations;

  Food({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.hasVariations,
    required this.price,
    this.discountPrice,
    this.variations,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
    hasVariations: json["has_variations"],
    price: json["price"],
    discountPrice: json["discount_price"],
    variations: json["variations"] == null ? [] : List<Variation>.from(json["variations"]!.map((x) => Variation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image": image,
    "has_variations": hasVariations,
    "price": price,
    "discount_price": discountPrice,
    "variations": variations == null ? [] : List<dynamic>.from(variations!.map((x) => x.toJson())),
  };
}

class Variation {
  final int id;
  final String size;
  final int price;
  final int? discountPrice;

  Variation({
    required this.id,
    required this.size,
    required this.price,
    this.discountPrice,
  });

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
    id: json['id'],
    size: json["size"],
    price: json["price"],
    discountPrice: json["discount_price"],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    "size": size,
    "price": price,
    "discount_price": discountPrice,
  };
}
