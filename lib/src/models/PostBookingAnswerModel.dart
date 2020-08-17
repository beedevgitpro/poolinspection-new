//// To parse this JSON data, do
////
////     final postBookingAnswerModel = postBookingAnswerModelFromJson(jsonString);
//
//import 'dart:convert';
//
//PostBookingAnswerModel postBookingAnswerModelFromJson(String str) => PostBookingAnswerModel.fromJson(json.decode(str));
//
//String postBookingAnswerModelToJson(PostBookingAnswerModel data) => json.encode(data.toJson());
//
//class PostBookingAnswerModel {
//  PostBookingAnswerModel({
//    this.status,
//    this.messages,
//    this.error,
//  });
//
//  String status;
//  String messages;
//  String error;
//
//  factory PostBookingAnswerModel.fromJson(Map<String, dynamic> json)
//  {
//    noticeRegis = json['notice_regis'];
//    ownerLand = json['owner_land'];
//    phonenumber = json['phonenumber'];
//    status=json["status"];
//
//  }
//
//
//  Map<String, dynamic> toJson() => {
//    "status": status,
//    "messages": messages,
//    "error": error,
//  };
//}

class PostBookingAnswerModel {
  String status;
  String messages;
  int error;



  PostBookingAnswerModel({
    this.status,
    this.messages,
    this.error,
  });

  PostBookingAnswerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'];
    error = json['error'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    data['error'] = this.error;

    return data;
  }
}
