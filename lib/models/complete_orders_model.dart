// To parse this JSON data, do
//
//     final completeOrdersModel = completeOrdersModelFromJson(jsonString);

import 'dart:convert';

CompleteOrdersModel completeOrdersModelFromJson(String str) => CompleteOrdersModel.fromJson(json.decode(str));

String completeOrdersModelToJson(CompleteOrdersModel data) => json.encode(data.toJson());

class CompleteOrdersModel {
  final List<OrderComplete>? orders;
  final Pagination pagination;

  CompleteOrdersModel({
    this.orders,
    required this.pagination,
  });

  factory CompleteOrdersModel.fromJson(Map<String, dynamic> json) => CompleteOrdersModel(
    orders: json["orders"] == null ? [] : List<OrderComplete>.from(json["orders"]!.map((x) => OrderComplete.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "orders": orders == null ? [] : List<dynamic>.from(orders!.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}

class OrderComplete {
  final int id;
  final String orderNumber;
  final String status;
  final String subtotal;
  final String taxAmount;
  final String total;
  final DateTime createdAt;
  final String? vehicleNumber;
  final String customerName;
  final String? customerPhone;
  final List<ItemComplete> items;
  final TableComplete? table;

  OrderComplete({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.subtotal,
    required this.taxAmount,
    required this.total,
    required this.createdAt,
    required this.vehicleNumber,
    required this.customerName,
    required this.customerPhone,
    required this.items,
    required this.table,
  });

  factory OrderComplete.fromJson(Map<String, dynamic> json) => OrderComplete(
    id: json["id"],
    orderNumber: json["order_number"],
    status: json["status"],
    subtotal: json["subtotal"],
    taxAmount: json["tax_amount"],
    total: json["total"],
    createdAt: DateTime.parse(json["created_at"]),
    vehicleNumber: json["vehicle_number"],
    customerName: json["customer_name"],
    customerPhone: json["customer_phone"],
    items: List<ItemComplete>.from(json["items"].map((x) => ItemComplete.fromJson(x))),
    table: json["table"] == null ? null : TableComplete.fromJson(json["table"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_number": orderNumber,
    "status": status,
    "subtotal": subtotal,
    "tax_amount": taxAmount,
    "total": total,
    "created_at": createdAt.toIso8601String(),
    "vehicle_number": vehicleNumber,
    "customer_name": customerName,
    "customer_phone": customerPhone,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "table": table?.toJson(),
  };
}

// Keep the existing ItemComplete, TableComplete, and Pagination classes

class ItemComplete {
  final String foodName;
  final String foodImage;
  final String? variationName;
  final int quantity;
  final String unitPrice;
  final String totalPrice;

  ItemComplete({
    required this.foodName,
    required this.foodImage,
    required this.variationName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory ItemComplete.fromJson(Map<String, dynamic> json) => ItemComplete(
    foodName: json["food_name"],
    foodImage: json["food_image"],
    variationName: json["variation_name"],
    quantity: json["quantity"],
    unitPrice: json["unit_price"],
    totalPrice: json["total_price"],
  );

  Map<String, dynamic> toJson() => {
    "food_name": foodName,
    "food_image": foodImage,
    "variation_name": variationName,
    "quantity": quantity,
    "unit_price": unitPrice,
    "total_price": totalPrice,
  };
}

class TableComplete {
  final int tableId;
  final String tableName;

  TableComplete({
    required this.tableId,
    required this.tableName,
  });

  factory TableComplete.fromJson(Map<String, dynamic> json) => TableComplete(
    tableId: json["table_id"],
    tableName: json["table_name"],
  );

  Map<String, dynamic> toJson() => {
    "table_id": tableId,
    "table_name": tableName,
  };
}

class Pagination {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final int from;
  final int to;

  Pagination({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.from,
    required this.to,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    from: json["from"] ??0,
    to: json["to"]??0,
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
    "from": from,
    "to": to,
  };
}
