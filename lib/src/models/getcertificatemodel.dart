// To parse this JSON data, do
//
//     final getCertificateModel = getCertificateModelFromJson(jsonString);

import 'dart:convert';

GetCertificateModel getCertificateModelFromJson(String str) => GetCertificateModel.fromJson(json.decode(str));

String getCertificateModelToJson(GetCertificateModel data) => json.encode(data.toJson());

class GetCertificateModel {
  GetCertificateModel({
    this.status,
    this.messages,
    this.error,
    this.list,
  });

  String status;
  String messages;
  int error;
  List<ListElement> list;

  factory GetCertificateModel.fromJson(Map<String, dynamic> json) => GetCertificateModel(
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
    this.jobId,
    this.ownerLand,
    this.phonenumber,
    this.emailOwner,
    this.address,
    this.noticeRegis,
    this.nameRelevantCouncil,
    this.emailRelevantCouncil,
    this.councilRegisDate,
    this.noticeRegistration,
    this.councilDueDate,
    this.swiPoolSpa,
    this.permntRelocate,
    this.recentlyInspected,
    this.rectificationIssued,
    this.certificateNonCompliance,
    this.bookingDateTime,
    this.bookingTime,
    this.inspectionFee,
    this.paymentPaid,
    this.updatedAt,
    this.createdAt,
    this.status,
    this.companyList,
    this.isConfirm,
    this.inspectorList,
    this.isSubmitted,
    this.isCompliant,
    this.poolFound,
    this.streetRoad,
    this.citySuburb,
    this.postcode,
    this.municipalDistrict,
    this.isCertificateGenerated,
    this.certificateGeneratedDate,
    this.certificateGeneratedData,
    this.amountPayable,
    this.markedCompliantDate,
    this.isReinspection,
    this.enquiryId,
    this.reinspectionDate,
    this.reinspectionTime,
    this.agreement,
  });

  int id;
  String jobId;
  String ownerLand;
  String phonenumber;
  String emailOwner;
  String address;
  String noticeRegis;
  String nameRelevantCouncil;
  dynamic emailRelevantCouncil;
  dynamic councilRegisDate;
  String noticeRegistration;
  dynamic councilDueDate;
  String swiPoolSpa;
  String permntRelocate;
  String recentlyInspected;
  dynamic rectificationIssued;
  dynamic certificateNonCompliance;
  dynamic bookingDateTime;
  String bookingTime;
  String inspectionFee;
  String paymentPaid;
  DateTime updatedAt;
  DateTime createdAt;
  int status;
  dynamic companyList;
  int isConfirm;
  String inspectorList;
  int isSubmitted;
  int isCompliant;
  dynamic poolFound;
  String streetRoad;
  String citySuburb;
  String postcode;
  dynamic municipalDistrict;
  int isCertificateGenerated;
  String certificateGeneratedDate;
  String certificateGeneratedData;
  dynamic amountPayable;
  DateTime markedCompliantDate;
  int isReinspection;
  int enquiryId;
  DateTime reinspectionDate;
  String reinspectionTime;
  int agreement;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["id"],
    jobId: json["job_id"],
    ownerLand: json["owner_name"],
    phonenumber: json["phonenumber"],
    emailOwner: json["email_owner"],
    address: json["address"] == null ? null : json["address"],
    noticeRegis: json["notice_regis"],
    nameRelevantCouncil: json["name_relevant_council"],
    emailRelevantCouncil: json["email_relevant_council"],
    councilRegisDate: json["council_regis_date"],
    noticeRegistration: json["notice_registration"],
    councilDueDate: json["Council_due_date"],
    swiPoolSpa: json["swi_pool_spa"],
    permntRelocate: json["permnt_relocate"],
    recentlyInspected: json["recently_inspected"],
    rectificationIssued: json["rectification_issued"],
    certificateNonCompliance: json["certificate_non_compliance"],
    bookingDateTime: json["booking_date_time"],
    bookingTime: json["booking_time"],
    inspectionFee: json["inspection_fee"],
    paymentPaid: json["payment_paid"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    status: json["status"],
    companyList: json["company_list"],
    isConfirm: json["is_confirm"],
    inspectorList: json["inspector_list"],
    isSubmitted: json["is_submitted"],
    isCompliant: json["is_compliant"],
    poolFound: json["pool_found"],
    streetRoad: json["street_road"],
    citySuburb: json["city_suburb"],
    postcode: json["postcode"],
    municipalDistrict: json["municipal_district"],
    isCertificateGenerated: json["is_certificate_generated"],
    certificateGeneratedDate: json["certificate_generated_date"],
    certificateGeneratedData: json["certificate_generated_data"],
    amountPayable: json["amount_payable"],
    markedCompliantDate: DateTime.parse(json["marked_compliant_date"]),
    isReinspection: json["is_reinspection"],
    enquiryId: json["enquiry_id"] == null ? null : json["enquiry_id"],
    reinspectionDate: json["reinspection_date"] == null ? null : DateTime.parse(json["reinspection_date"]),
    reinspectionTime: json["reinspection_time"] == null ? null : json["reinspection_time"],
    agreement: json["agreement"] == null ? null : json["agreement"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "job_id": jobId,
    "owner_land": ownerLand,
    "phonenumber": phonenumber,
    "email_owner": emailOwner,
    "address": address == null ? null : address,
    "notice_regis": noticeRegis,
    "name_relevant_council": nameRelevantCouncil,
    "email_relevant_council": emailRelevantCouncil,
    "council_regis_date": councilRegisDate,
    "notice_registration": noticeRegistration,
    "Council_due_date": councilDueDate,
    "swi_pool_spa": swiPoolSpa,
    "permnt_relocate": permntRelocate,
    "recently_inspected": recentlyInspected,
    "rectification_issued": rectificationIssued,
    "certificate_non_compliance": certificateNonCompliance,
    "booking_date_time": bookingDateTime,
    "booking_time": bookingTime,
    "inspection_fee": inspectionFee,
    "payment_paid": paymentPaid,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "status": status,
    "company_list": companyList,
    "is_confirm": isConfirm,
    "inspector_list": inspectorList,
    "is_submitted": isSubmitted,
    "is_compliant": isCompliant,
    "pool_found": poolFound,
    "street_road": streetRoad,
    "city_suburb": citySuburb,
    "postcode": postcode,
    "municipal_district": municipalDistrict,
    "is_certificate_generated": isCertificateGenerated,
    "certificate_generated_date": certificateGeneratedDate,
    "certificate_generated_data": certificateGeneratedData,
    "amount_payable": amountPayable,
    "marked_compliant_date": markedCompliantDate.toIso8601String(),
    "is_reinspection": isReinspection,
    "enquiry_id": enquiryId == null ? null : enquiryId,
    "reinspection_date": reinspectionDate == null ? null : "${reinspectionDate.year.toString().padLeft(4, '0')}-${reinspectionDate.month.toString().padLeft(2, '0')}-${reinspectionDate.day.toString().padLeft(2, '0')}",
    "reinspection_time": reinspectionTime == null ? null : reinspectionTime,
    "agreement": agreement == null ? null : agreement,
  };
}
