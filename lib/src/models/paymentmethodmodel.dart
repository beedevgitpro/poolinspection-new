// To parse this JSON data, do
//
//     final addPAymentModel = addPAymentModelFromJson(jsonString);

import 'dart:convert';

AddPaymentModel addPAymentModelFromJson(String str) => AddPaymentModel.fromJson(json.decode(str));

String addPAymentModelToJson(AddPaymentModel data) => json.encode(data.toJson());

class AddPaymentModel {
  String status;
  String messages;
  int error;

  AddPaymentModel({
    this.status,
    this.messages,
    this.error,
  });

  factory AddPaymentModel.fromJson(Map<String, dynamic> json) => AddPaymentModel(
    status: json["status"],
    messages: json["messages"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "messages": messages,
    "error": error,
  };
}
