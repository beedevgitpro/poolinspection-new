class ReportModel {
  String status;
  String messages;
  int error;
  List<CompliantReportList> compliantReportList;

  ReportModel(
      {this.status, this.messages, this.error, this.compliantReportList});

  ReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'];
    error = json['error'];
    if (json['compliant_report_list'] != null) {
      compliantReportList = new List<CompliantReportList>();
      json['compliant_report_list'].forEach((v) {
        compliantReportList.add(new CompliantReportList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    data['error'] = this.error;
    if (this.compliantReportList != null) {
      data['compliant_report_list'] =
          this.compliantReportList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompliantReportList {
  int id;
  String ownerLand;
  String phonenumber;
  String emailOwner;
  String address;
  String noticeRegis;
  String nameRelevantCouncil;
  String emailRelevantCouncil;
  String councilRegisDate;
  String noticeRegistration;
  String councilDueDate;
  String swiPoolSpa;
  String permntRelocate;
  String recentlyInspected;
  String rectificationIssued;
  String certificateNonCompliance;
  String bookingDateTime;
  String inspectionFee;
  String paymentPaid;
  String updatedAt;
  String createdAt;
  int status;
  String companyList;
  int isConfirm;
  String inspectorList;
  int isSubmitted;
  int isCompliant;
  String regulationName;
  String inspectorName;
  var street;
  var district;
  var city;
  var postcode;

  CompliantReportList(
      {this.id,
      this.street,
      this.district,
      this.city,
      this.postcode,
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
      this.regulationName,
      this.inspectorName});

  CompliantReportList.fromJson(Map<String, dynamic> json) {
    street = json['street_road'];
    district = json['municipal_district'];
    city = json['city_suburb'];
    postcode = json['postcode'];
    id = json['id'];
    ownerLand = json['owner_land'];
    phonenumber = json['phonenumber'];
    emailOwner = json['email_owner'];
    address = json['address'];
    noticeRegis = json['notice_regis'];
    nameRelevantCouncil = json['name_relevant_council'];
    emailRelevantCouncil = json['email_relevant_council'];
    councilRegisDate = json['council_regis_date'];
    noticeRegistration = json['notice_registration'];
    councilDueDate = json['Council_due_date'];
    swiPoolSpa = json['swi_pool_spa'];
    permntRelocate = json['permnt_relocate'];
    recentlyInspected = json['recently_inspected'];
    rectificationIssued = json['rectification_issued'];
    certificateNonCompliance = json['certificate_non_compliance'];
    bookingDateTime = json['booking_date_time'];
    inspectionFee = json['inspection_fee'];
    paymentPaid = json['payment_paid'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    status = json['status'];
    companyList = json['company_list'];
    isConfirm = json['is_confirm'];
    inspectorList = json['inspector_list'];
    isSubmitted = json['is_submitted'];
    isCompliant = json['is_compliant'];
    regulationName = json['regulation_name'];
    inspectorName = json['inspector_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street_road'] = this.street;
    data['municipal_district'] = this.district;
    data['city_suburb'] = this.city;
    data['postcode'] = this.postcode;
    data['id'] = this.id;
    data['owner_land'] = this.ownerLand;
    data['phonenumber'] = this.phonenumber;
    data['email_owner'] = this.emailOwner;
    data['address'] = this.address;
    data['notice_regis'] = this.noticeRegis;
    data['name_relevant_council'] = this.nameRelevantCouncil;
    data['email_relevant_council'] = this.emailRelevantCouncil;
    data['council_regis_date'] = this.councilRegisDate;
    data['notice_registration'] = this.noticeRegistration;
    data['Council_due_date'] = this.councilDueDate;
    data['swi_pool_spa'] = this.swiPoolSpa;
    data['permnt_relocate'] = this.permntRelocate;
    data['recently_inspected'] = this.recentlyInspected;
    data['rectification_issued'] = this.rectificationIssued;
    data['certificate_non_compliance'] = this.certificateNonCompliance;
    data['booking_date_time'] = this.bookingDateTime;
    data['inspection_fee'] = this.inspectionFee;
    data['payment_paid'] = this.paymentPaid;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['company_list'] = this.companyList;
    data['is_confirm'] = this.isConfirm;
    data['inspector_list'] = this.inspectorList;
    data['is_submitted'] = this.isSubmitted;
    data['is_compliant'] = this.isCompliant;
    data['regulation_name'] = this.regulationName;
    data['inspector_name'] = this.inspectorName;
    return data;
  }
}
