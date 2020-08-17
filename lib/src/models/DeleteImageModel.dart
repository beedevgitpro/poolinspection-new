// To parse this JSON data, do
//
//     final deleteImageModel = deleteImageModelFromJson(jsonString);

import 'dart:convert';

DeleteImageModel deleteImageModelFromJson(String str) => DeleteImageModel.fromJson(json.decode(str));

String deleteImageModelToJson(DeleteImageModel data) => json.encode(data.toJson());

class DeleteImageModel {
  DeleteImageModel({
    this.status,
    this.messages,
    this.error,
  });

  String status;
  String messages;
  int error;

  factory DeleteImageModel.fromJson(Map<String, dynamic> json) => DeleteImageModel(
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
