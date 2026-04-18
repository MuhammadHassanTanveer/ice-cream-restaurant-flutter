// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  final DateTime date;
  final int totalOrders;
  final int pendingOrders;
  final int completedOrders;
  final int cancelledOrders;

  DashboardModel({
    required this.date,
    required this.totalOrders,
    required this.pendingOrders,
    required this.completedOrders,
    required this.cancelledOrders,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    date: DateTime.parse(json["date"]),
    totalOrders: json["total_orders"],
    pendingOrders: json["pending_orders"],
    completedOrders: json["completed_orders"],
    cancelledOrders: json["cancelled_orders"],
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "total_orders": totalOrders,
    "pending_orders": pendingOrders,
    "completed_orders": completedOrders,
    "cancelled_orders": cancelledOrders,
  };
}
