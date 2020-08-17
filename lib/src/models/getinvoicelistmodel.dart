// To parse this JSON data, do
//
//     final getInvoiceList = getInvoiceListFromJson(jsonString);

import 'dart:convert';

GetInvoiceList getInvoiceListFromJson(String str) => GetInvoiceList.fromJson(json.decode(str));

String getInvoiceListToJson(GetInvoiceList data) => json.encode(data.toJson());

class GetInvoiceList {
  GetInvoiceList({
    this.status,
    this.messages,
    this.error,
    this.invoiceList,
  });

  String status;
  String messages;
  int error;
  List<InvoiceList> invoiceList;

  factory GetInvoiceList.fromJson(Map<String, dynamic> json) => GetInvoiceList(
    status: json["status"],
    messages: json["messages"],
    error: json["error"],
    invoiceList: List<InvoiceList>.from(json["invoice_list"].map((x) => InvoiceList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "messages": messages,
    "error": error,
    "invoice_list": List<dynamic>.from(invoiceList.map((x) => x.toJson())),
  };
}

class InvoiceList {
  InvoiceList({
    this.id,
    this.generatedId,
    this.providerName,
    this.invoices,
    this.type,
    this.invoiceId,
    this.invoiceNumber,
    this.amountDue,
    this.amountPaid,
    this.sentToContact,
    this.dateString,
    this.dueDateString,
    this.status,
    this.lineAmountTypes,
    this.subTotal,
    this.totalTax,
    this.total,
    this.currencyCode,
    this.contactId,
    this.transactionId,
    this.response,
  });

  int id;
  String generatedId;
  String providerName;
  dynamic invoices;
  String type;
  String invoiceId;
  String invoiceNumber;
  String amountDue;
  String amountPaid;
  String sentToContact;
  DateTime dateString;
  DateTime dueDateString;
  String status;
  String lineAmountTypes;
  String subTotal;
  String totalTax;
  String total;
  String currencyCode;
  String contactId;
  dynamic transactionId;
  dynamic response;

  factory InvoiceList.fromJson(Map<String, dynamic> json) => InvoiceList(
    id: json["id"],
    generatedId: json["generated_id"],
    providerName: json["provider_name"],
    invoices: json["invoices"],
    type: json["Type"],
    invoiceId: json["InvoiceID"],
    invoiceNumber: json["InvoiceNumber"],
    amountDue: json["AmountDue"],
    amountPaid: json["AmountPaid"],
    sentToContact: json["SentToContact"],
    dateString: DateTime.parse(json["DateString"]),
    dueDateString: DateTime.parse(json["DueDateString"]),
    status: json["Status"],
    lineAmountTypes: json["LineAmountTypes"],
    subTotal: json["SubTotal"],
    totalTax: json["TotalTax"],
    total: json["Total"],
    currencyCode: json["CurrencyCode"],
    contactId: json["ContactID"],
    transactionId: json["transaction_id"],
    response: json["response"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "generated_id": generatedId,
    "provider_name": providerName,
    "invoices": invoices,
    "Type": type,
    "InvoiceID": invoiceId,
    "InvoiceNumber": invoiceNumber,
    "AmountDue": amountDue,
    "AmountPaid": amountPaid,
    "SentToContact": sentToContact,
    "DateString": dateString.toIso8601String(),
    "DueDateString": dueDateString.toIso8601String(),
    "Status": status,
    "LineAmountTypes": lineAmountTypes,
    "SubTotal": subTotal,
    "TotalTax": totalTax,
    "Total": total,
    "CurrencyCode": currencyCode,
    "ContactID": contactId,
    "transaction_id": transactionId,
    "response": response,
  };
}
