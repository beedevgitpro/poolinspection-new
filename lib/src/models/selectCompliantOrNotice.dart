// To parse this JSON data, do
//
//     final selectNonCompliantOrNotice = selectNonCompliantOrNoticeFromJson(jsonString);

import 'dart:convert';

SelectNonCompliantOrNotice selectNonCompliantOrNoticeFromJson(String str) => SelectNonCompliantOrNotice.fromJson(json.decode(str));

String selectNonCompliantOrNoticeToJson(SelectNonCompliantOrNotice data) => json.encode(data.toJson());

class SelectNonCompliantOrNotice {
  SelectNonCompliantOrNotice({
    this.status,
    this.messages,
    this.error,
  });

  String status;
  String messages;
  int error;

  factory SelectNonCompliantOrNotice.fromJson(Map<String, dynamic> json) => SelectNonCompliantOrNotice(
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
