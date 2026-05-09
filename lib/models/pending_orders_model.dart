// To parse this JSON data, do
//
//     final pendingOrdersModel = pendingOrdersModelFromJson(jsonString);

import 'dart:convert';

PendingOrdersModel pendingOrdersModelFromJson(String str) => PendingOrdersModel.fromJson(json.decode(str));

String pendingOrdersModelToJson(PendingOrdersModel data) => json.encode(data.toJson());

class PendingOrdersModel {
  final List<Order> orders;
  final Pagination pagination;

  PendingOrdersModel({
    required this.orders,
    required this.pagination,
  });

  factory PendingOrdersModel.fromJson(Map<String, dynamic> json) => PendingOrdersModel(
    orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}

class Order {
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
  final List<Item> items;
  final Table? table;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.subtotal,
    required this.taxAmount,
    required this.total,
    required this.createdAt,
    this.vehicleNumber,
    required this.customerName,
    this.customerPhone,
    required this.items,
    this.table,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
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
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    table: json["table"] == null ? null : Table.fromJson(json["table"]),
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

class Item {
  final String foodName;
  final String? foodImage;
  final String? variationName;
  final int quantity;
  final String unitPrice;
  final String totalPrice;

  Item({
    required this.foodName,
    this.foodImage,
    this.variationName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
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

class Table {
  final int tableId;
  final String tableName;

  Table({
    required this.tableId,
    required this.tableName,
  });

  factory Table.fromJson(Map<String, dynamic> json) => Table(
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
  final int? from;
  final int? to;

  Pagination({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    this.from,
    this.to,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"] ?? 0,
    perPage: json["per_page"] ?? 0,
    currentPage: json["current_page"] ?? 1,
    lastPage: json["last_page"] ?? 1,
    from: json["from"],
    to: json["to"],
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
