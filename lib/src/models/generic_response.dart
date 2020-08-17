class GenericResponse {
  String status;
  String messages;
  String error;

  GenericResponse({this.status, this.messages, this.error});

  GenericResponse.fromJson(Map<String, dynamic> json) {
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
