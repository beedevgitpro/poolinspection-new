class QuestionModel {
  String status;
  String messages;
  int error;
  List<QuestionsFromHeadingId> questionsFromHeadingId;

  QuestionModel(
      {this.status, this.messages, this.error, this.questionsFromHeadingId});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'];
    error = json['error'];
    if (json['questions_from_headingId'] != null) {
      questionsFromHeadingId = new List<QuestionsFromHeadingId>();
      json['questions_from_headingId'].forEach((v) {
        questionsFromHeadingId.add(new QuestionsFromHeadingId.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    data['error'] = this.error;
    if (this.questionsFromHeadingId != null) {
      data['questions_from_headingId'] =
          this.questionsFromHeadingId.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionsFromHeadingId {
  int id;
  int bookingId;
  int regulationId;
  int headingId;
  int quesionId;
  String ans;
  String comment;
  String images;
  String destination;
  String updatedAt;
  String createdAt;
  String updatedBy;
  String createdBy;
  String headingName;
  String question;
  String hint;
  String regulationName;

  QuestionsFromHeadingId(
      {this.id,
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
      this.regulationName});

  QuestionsFromHeadingId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    regulationId = json['regulation_id'];
    headingId = json['heading_id'];
    quesionId = json['quesion_id'];
    ans = json['ans'];
    comment = json['comment'];
    images = json['images'];
    destination = json['destination'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    createdBy = json['created_by'];
    headingName = json['heading_name'];
    question = json['question'];
    hint = json['hint'];
    regulationName = json['regulation_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['regulation_id'] = this.regulationId;
    data['heading_id'] = this.headingId;
    data['quesion_id'] = this.quesionId;
    data['ans'] = this.ans;
    data['comment'] = this.comment;
    data['images'] = this.images;
    data['destination'] = this.destination;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['created_by'] = this.createdBy;
    data['heading_name'] = this.headingName;
    data['question'] = this.question;
    data['hint'] = this.hint;
    data['regulation_name'] = this.regulationName;
    return data;
  }
}
