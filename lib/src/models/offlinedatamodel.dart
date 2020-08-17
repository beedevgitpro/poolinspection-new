// To parse this JSON data, do
//
//     final offlineDataModel = offlineDataModelFromJson(jsonString);

import 'dart:convert';

OfflineDataModel offlineDataModelFromJson(String str) => OfflineDataModel.fromJson(json.decode(str));

String offlineDataModelToJson(OfflineDataModel data) => json.encode(data.toJson());

class OfflineDataModel {
  OfflineDataModel({
    this.status,
    this.messages,
    this.error,
    this.quesionList,
  });

  String status;
  String messages;
  int error;
  List<QuesionList> quesionList;

  factory OfflineDataModel.fromJson(Map<String, dynamic> json) => OfflineDataModel(
    status: json["status"],
    messages: json["messages"],
    error: json["error"],
    quesionList: List<QuesionList>.from(json["quesion_list"].map((x) => QuesionList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "messages": messages,
    "error": error,
    "quesion_list": List<dynamic>.from(quesionList.map((x) => x.toJson())),
  };
}

class QuesionList {
  QuesionList({
    this.headingId,
    this.headingName,
    this.regulationName,
    this.regulationDescription,
    this.headingDescription,
    this.isCompleted,
    this.questions,
  });

  int headingId;
  String headingName;
  RegulationName regulationName;
  String regulationDescription;
  String headingDescription;
  int isCompleted;
  List<Question> questions;

  factory QuesionList.fromJson(Map<String, dynamic> json) => QuesionList(
    headingId: json["heading_id"],
    headingName: json["heading_name"],
    regulationName: regulationNameValues.map[json["regulation_name"]],
    regulationDescription: json["regulation_description"],
    headingDescription: json["heading_description"],
    isCompleted: json["is_completed"],
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "heading_id": headingId,
    "heading_name": headingName,
    "regulation_name": regulationNameValues.reverse[regulationName],
    "regulation_description": regulationDescription,
    "heading_description": headingDescription,
    "is_completed": isCompleted,
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class Question {
  Question({
    this.id,
    this.bookingId,
    this.regulationId,
    this.headingId,
    this.quesionId,
    this.ans,
    this.comment,
    this.images,
    this.destination,
    this.updatedAt,
    this.createdAt,
    this.updatedBy,
    this.createdBy,
    this.headingName,
    this.question,
    this.hint,
    this.regulationName,
    this.fileName,
    this.hintImgDestination,
    this.headingDescription,
    this.questionType,
  });

  int id;
  int bookingId;
  int regulationId;
  int headingId;
  int quesionId;
  dynamic ans;
  dynamic comment;
  dynamic images;
  dynamic destination;
  dynamic updatedAt;
  dynamic createdAt;
  dynamic updatedBy;
  dynamic createdBy;
  String headingName;
  String question;
  String hint;
  RegulationName regulationName;
  String fileName;
  HintImgDestination hintImgDestination;
  String headingDescription;
  int questionType;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    bookingId: json["booking_id"],
    regulationId: json["regulation_id"],
    headingId: json["heading_id"],
    quesionId: json["quesion_id"],
    ans: json["ans"],
    comment: json["comment"],
    images: json["images"],
    destination: json["destination"],
    updatedAt: json["updated_at"],
    createdAt: json["created_at"],
    updatedBy: json["updated_by"],
    createdBy: json["created_by"],
    headingName: json["heading_name"],
    question: json["question"],
    hint: json["hint"],
    regulationName: regulationNameValues.map[json["regulation_name"]],
    fileName: json["file_name"] == null ? null : json["file_name"],
    hintImgDestination: json["hint_img_destination"] == null ? null : hintImgDestinationValues.map[json["hint_img_destination"]],
    headingDescription: json["heading_description"],
    questionType: json["question_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_id": bookingId,
    "regulation_id": regulationId,
    "heading_id": headingId,
    "quesion_id": quesionId,
    "ans": ans,
    "comment": comment,
    "images": images,
    "destination": destination,
    "updated_at": updatedAt,
    "created_at": createdAt,
    "updated_by": updatedBy,
    "created_by": createdBy,
    "heading_name": headingName,
    "question": question,
    "hint": hint,
    "regulation_name": regulationNameValues.reverse[regulationName],
    "file_name": fileName == null ? null : fileName,
    "hint_img_destination": hintImgDestination == null ? null : hintImgDestinationValues.reverse[hintImgDestination],
    "heading_description": headingDescription,
    "question_type": questionType,
  };
}

enum HintImgDestination { UPLOADS_REGULATION_4 }

final hintImgDestinationValues = EnumValues({
  "uploads/regulation/4": HintImgDestination.UPLOADS_REGULATION_4
});

enum RegulationName { AS_192611993_AMT_1_FENCING_FOR_SWIMMING_POOLS }

final regulationNameValues = EnumValues({
  "AS 1926.1 – 1993 + Amt 1  “Fencing for swimming pools”": RegulationName.AS_192611993_AMT_1_FENCING_FOR_SWIMMING_POOLS
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
