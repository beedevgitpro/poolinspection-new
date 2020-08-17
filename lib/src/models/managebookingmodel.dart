// To parse this JSON data, do
//
//     final manageBookingModel = manageBookingModelFromJson(jsonString);

import 'dart:convert';

ManageBookingModel manageBookingModelFromJson(String str) => ManageBookingModel.fromJson(json.decode(str));

String manageBookingModelToJson(ManageBookingModel data) => json.encode(data.toJson());

class ManageBookingModel {
  ManageBookingModel({
    this.status,
    this.messages,
    this.error,
    this.list,
  });

  String status;
  String messages;
  int error;
  List<ListElement> list;

  factory ManageBookingModel.fromJson(Map<String, dynamic> json) => ManageBookingModel(
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
  Address address;
  NoticeRegis noticeRegis;
  String nameRelevantCouncil;
  EmailRelevantCouncil emailRelevantCouncil;
  String councilRegisDate;
  String noticeRegistration;
  String councilDueDate;
  SwiPoolSpa swiPoolSpa;
  PermntRelocate permntRelocate;
  NoticeRegis recentlyInspected;
  dynamic rectificationIssued;
  dynamic certificateNonCompliance;
  String bookingDateTime;
  String bookingTime;
  String inspectionFee;
  NoticeRegis paymentPaid;
  DateTime updatedAt;
  DateTime createdAt;
  int status;
  String companyList;
  int isConfirm;
  String inspectorList;
  int isSubmitted;
  int isCompliant;
  dynamic poolFound;
  String streetRoad;
  String citySuburb;
  String postcode;
  MunicipalDistrict municipalDistrict;
  int isCertificateGenerated;
  String certificateGeneratedDate;
  String certificateGeneratedData;
  dynamic amountPayable;
  DateTime markedCompliantDate;
  int isReinspection;
  int enquiryId;
  dynamic reinspectionDate;
  dynamic reinspectionTime;
  int agreement;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["id"],
    jobId: json["job_id"] == null ? null : json["job_id"],
    ownerLand: json["owner_land"],
    phonenumber: json["phonenumber"],
    emailOwner: json["email_owner"],
    address: json["address"] == null ? null : addressValues.map[json["address"]],
    noticeRegis: json["notice_regis"] == null ? null : noticeRegisValues.map[json["notice_regis"]],
    nameRelevantCouncil: json["name_relevant_council"],
    emailRelevantCouncil: json["email_relevant_council"] == null ? null : emailRelevantCouncilValues.map[json["email_relevant_council"]],
    councilRegisDate: json["council_regis_date"],
    noticeRegistration: json["notice_registration"],
    councilDueDate: json["Council_due_date"],
    swiPoolSpa: json["swi_pool_spa"] == null ? null : swiPoolSpaValues.map[json["swi_pool_spa"]],
    permntRelocate: json["permnt_relocate"] == null ? null : permntRelocateValues.map[json["permnt_relocate"]],
    recentlyInspected: json["recently_inspected"] == null ? null : noticeRegisValues.map[json["recently_inspected"]],
    rectificationIssued: json["rectification_issued"],
    certificateNonCompliance: json["certificate_non_compliance"],
    bookingDateTime: json["booking_date_time"] == null ? null : json["booking_date_time"],
    bookingTime: json["booking_time"] == null ? null : json["booking_time"],
    inspectionFee: json["inspection_fee"],
    paymentPaid: json["payment_paid"] == null ? null : noticeRegisValues.map[json["payment_paid"]],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    status: json["status"],
    companyList: json["company_list"] == null ? null : json["company_list"],
    isConfirm: json["is_confirm"] == null ? null : json["is_confirm"],
    inspectorList: json["inspector_list"],
    isSubmitted: json["is_submitted"],
    isCompliant: json["is_compliant"],
    poolFound: json["pool_found"],
    streetRoad: json["street_road"],
    citySuburb: json["city_suburb"],
    postcode: json["postcode"],
    municipalDistrict: json["municipal_district"] == null ? null : municipalDistrictValues.map[json["municipal_district"]],
    isCertificateGenerated: json["is_certificate_generated"],
    certificateGeneratedDate: json["certificate_generated_date"] == null ? null : json["certificate_generated_date"],
    certificateGeneratedData: json["certificate_generated_data"] == null ? null : json["certificate_generated_data"],
    amountPayable: json["amount_payable"],
    markedCompliantDate: json["marked_compliant_date"] == null ? null : DateTime.parse(json["marked_compliant_date"]),
    isReinspection: json["is_reinspection"],
    enquiryId: json["enquiry_id"] == null ? null : json["enquiry_id"],
    reinspectionDate: json["reinspection_date"],
    reinspectionTime: json["reinspection_time"],
    agreement: json["agreement"] == null ? null : json["agreement"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "job_id": jobId == null ? null : jobId,
    "owner_land": ownerLand,
    "phonenumber": phonenumber,
    "email_owner": emailOwner,
    "address": address == null ? null : addressValues.reverse[address],
    "notice_regis": noticeRegis == null ? null : noticeRegisValues.reverse[noticeRegis],
    "name_relevant_council": nameRelevantCouncil,
    "email_relevant_council": emailRelevantCouncil == null ? null : emailRelevantCouncilValues.reverse[emailRelevantCouncil],
    "council_regis_date": councilRegisDate,
    "notice_registration": noticeRegistration,
    "Council_due_date": councilDueDate,
    "swi_pool_spa": swiPoolSpa == null ? null : swiPoolSpaValues.reverse[swiPoolSpa],
    "permnt_relocate": permntRelocate == null ? null : permntRelocateValues.reverse[permntRelocate],
    "recently_inspected": recentlyInspected == null ? null : noticeRegisValues.reverse[recentlyInspected],
    "rectification_issued": rectificationIssued,
    "certificate_non_compliance": certificateNonCompliance,
    "booking_date_time": bookingDateTime == null ? null : bookingDateTime,
    "booking_time": bookingTime == null ? null : bookingTime,
    "inspection_fee": inspectionFee,
    "payment_paid": paymentPaid == null ? null : noticeRegisValues.reverse[paymentPaid],
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "status": status,
    "company_list": companyList == null ? null : companyList,
    "is_confirm": isConfirm == null ? null : isConfirm,
    "inspector_list": inspectorList,
    "is_submitted": isSubmitted,
    "is_compliant": isCompliant,
    "pool_found": poolFound,
    "street_road": streetRoad,
    "city_suburb": citySuburb,
    "postcode": postcode,
    "municipal_district": municipalDistrict == null ? null : municipalDistrictValues.reverse[municipalDistrict],
    "is_certificate_generated": isCertificateGenerated,
    "certificate_generated_date": certificateGeneratedDate == null ? null : certificateGeneratedDate,
    "certificate_generated_data": certificateGeneratedData == null ? null : certificateGeneratedData,
    "amount_payable": amountPayable,
    "marked_compliant_date": markedCompliantDate == null ? null : markedCompliantDate.toIso8601String(),
    "is_reinspection": isReinspection,
    "enquiry_id": enquiryId == null ? null : enquiryId,
    "reinspection_date": reinspectionDate,
    "reinspection_time": reinspectionTime,
    "agreement": agreement == null ? null : agreement,
  };
}

enum Address { THE_32_B_PATEL_SHOPPING_CENTRE, NULL }

final addressValues = EnumValues({
  "null": Address.NULL,
  "32, B Patel shopping centre": Address.THE_32_B_PATEL_SHOPPING_CENTRE
});

enum EmailRelevantCouncil { COUNCILEMAIL_GMAIL_COM }

final emailRelevantCouncilValues = EnumValues({
  "councilemail@gmail.com": EmailRelevantCouncil.COUNCILEMAIL_GMAIL_COM
});

enum MunicipalDistrict { THANE }

final municipalDistrictValues = EnumValues({
  "Thane": MunicipalDistrict.THANE
});

enum NoticeRegis { YES, NOTICE_REGIS_YES, NO, NOTICE_REGIS_NO }

final noticeRegisValues = EnumValues({
  "no": NoticeRegis.NO,
  "No": NoticeRegis.NOTICE_REGIS_NO,
  "Yes": NoticeRegis.NOTICE_REGIS_YES,
  "yes": NoticeRegis.YES
});

enum PermntRelocate { PERMANENT, PERMNT_RELOCATE_PERMANENT, RELOCATABLE, PERMNT_RELOCATE_RELOCATABLE }

final permntRelocateValues = EnumValues({
  "permanent": PermntRelocate.PERMANENT,
  "Permanent": PermntRelocate.PERMNT_RELOCATE_PERMANENT,
  "Relocatable": PermntRelocate.PERMNT_RELOCATE_RELOCATABLE,
  "relocatable": PermntRelocate.RELOCATABLE
});

enum SwiPoolSpa { SPA, SWIMMING_POOL, SWI_POOL_SPA_SWIMMING_POOL, SWI_POOL_SPA_SPA }

final swiPoolSpaValues = EnumValues({
  "spa": SwiPoolSpa.SPA,
  "swimming_pool": SwiPoolSpa.SWIMMING_POOL,
  "Spa": SwiPoolSpa.SWI_POOL_SPA_SPA,
  "Swimming Pool": SwiPoolSpa.SWI_POOL_SPA_SWIMMING_POOL
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
