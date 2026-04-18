import 'categories_and_food.dart';
import 'dart:convert';

class CartItem {
  final int foodId;
  final Food food;
  int quantity;
  List<List<bool>> selectedVariations;
  double totalPrice;

  CartItem({
    required this.foodId,
    required this.food,
    required this.quantity,
    required this.selectedVariations,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() => {
    'foodId': foodId,
    'food': food.toJson(),
    'quantity': quantity,
    'selectedVariations': jsonEncode(selectedVariations),
    'totalPrice': totalPrice,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    foodId: json['foodId'],
    food: Food.fromJson(json['food']),
    quantity: json['quantity'],
    selectedVariations: List<List<bool>>.from(jsonDecode(json['selectedVariations']).map((x) => List<bool>.from(x))),
    totalPrice: json['totalPrice'],
  );
}