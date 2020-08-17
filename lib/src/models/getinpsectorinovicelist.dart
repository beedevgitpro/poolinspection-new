// To parse this JSON data, do
//
//     final getInspectorInvoiceList = getInspectorInvoiceListFromJson(jsonString);

import 'dart:convert';

GetInspectorInvoiceList getInspectorInvoiceListFromJson(String str) => GetInspectorInvoiceList.fromJson(json.decode(str));

String getInspectorInvoiceListToJson(GetInspectorInvoiceList data) => json.encode(data.toJson());

class GetInspectorInvoiceList {
  GetInspectorInvoiceList({
    this.status,
    this.messages,
    this.error,
    this.list,
  });

  String status;
  String messages;
  int error;
  List<ListElement> list;

  factory GetInspectorInvoiceList.fromJson(Map<String, dynamic> json) => GetInspectorInvoiceList(
    status: json["status"],
    messages: json["messages"],
    error: json["error"],
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "messages": messages,
    "error": error,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class ListElement {
  ListElement({
    this.id,
    this.bookingId,
    this.bookingPrice,
    this.ownerName,
    this.ownerEmail,
    this.inspectorEmail,
    this.bookingDate,
    this.bookingTime,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.inspectorId,
    this.companyId,
    this.invoiceName,
    this.invoicePath,
  });

  int id;
  int bookingId;
  int bookingPrice;
  String ownerName;
  String ownerEmail;
  dynamic inspectorEmail;
  DateTime bookingDate;
  String bookingTime;
  DateTime createdAt;
  int createdBy;
  dynamic updatedAt;
  dynamic updatedBy;
  int inspectorId;
  int companyId;
  String invoiceName;
  String invoicePath;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["id"],
    bookingId: json["booking_id"],
    bookingPrice: json["booking_price"] == null ? null : json["booking_price"],
    ownerName: json["owner_name"] == null ? null : json["owner_name"],
    ownerEmail: json["owner_email"] == null ? null : json["owner_email"],
    inspectorEmail: json["inspector_email"],
    bookingDate: json["booking_date"] == null ? null : DateTime.parse(json["booking_date"]),
    bookingTime: json["booking_time"] == null ? null : json["booking_time"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    updatedAt: json["updated_at"],
    updatedBy: json["updated_by"],
    inspectorId: json["inspector_id"] == null ? null : json["inspector_id"],
    companyId: json["company_id"] == null ? null : json["company_id"],
    invoiceName: json["invoice_name"] == null ? null : json["invoice_name"],
    invoicePath: json["invoice_path"] == null ? null : json["invoice_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_id": bookingId,
    "booking_price": bookingPrice == null ? null : bookingPrice,
    "owner_name": ownerName == null ? null : ownerName,
    "owner_email": ownerEmail == null ? null : ownerEmail,
    "inspector_email": inspectorEmail,
    "booking_date": bookingDate == null ? null : "${bookingDate.year.toString().padLeft(4, '0')}-${bookingDate.month.toString().padLeft(2, '0')}-${bookingDate.day.toString().padLeft(2, '0')}",
    "booking_time": bookingTime == null ? null : bookingTime,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "updated_at": updatedAt,
    "updated_by": updatedBy,
    "inspector_id": inspectorId == null ? null : inspectorId,
    "company_id": companyId == null ? null : companyId,
    "invoice_name": invoiceName == null ? null : invoiceName,
    "invoice_path": invoicePath == null ? null : invoicePath,
  };
}
