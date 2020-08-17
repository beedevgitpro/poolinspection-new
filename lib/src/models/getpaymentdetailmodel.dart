// To parse this JSON data, do
//
//     final paymentDetailGetApiModel = paymentDetailGetApiModelFromJson(jsonString);

import 'dart:convert';

PaymentDetailGetApiModel paymentDetailGetApiModelFromJson(String str) => PaymentDetailGetApiModel.fromJson(json.decode(str));

String paymentDetailGetApiModelToJson(PaymentDetailGetApiModel data) => json.encode(data.toJson());

class PaymentDetailGetApiModel {
  PaymentDetailGetApiModel({
    this.status,
    this.messages,
    this.error,
    this.paymentDetail,
  });

  String status;
  String messages;
  int error;
  PaymentDetail paymentDetail;

  factory PaymentDetailGetApiModel.fromJson(Map<String, dynamic> json) => PaymentDetailGetApiModel(
    status: json["status"],
    messages: json["messages"],
    error: json["error"],
    paymentDetail: PaymentDetail.fromJson(json["payment_detail"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "messages": messages,
    "error": error,
    "payment_detail": paymentDetail.toJson(),
  };
}

class PaymentDetail {
  PaymentDetail({
    this.paymentMethod,
    this.cardNo,
    this.accountName,
    this.accountNumber,
    this.bsbNumber,
  });

  int paymentMethod;
  String cardNo;
  String accountName;
  String accountNumber;
  String bsbNumber;

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
    paymentMethod: json["payment_method"],
    cardNo: json["card_no"],
    accountName: json["account_name"],
    accountNumber: json["account_number"],
    bsbNumber: json["bsb_number"],
  );

  Map<String, dynamic> toJson() => {
    "payment_method": paymentMethod,
    "card_no": cardNo,
    "account_name": accountName,
    "account_number": accountNumber,
    "bsb_number": bsbNumber,
  };
}
