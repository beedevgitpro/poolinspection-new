class BookingPrefil {
  String status;
  String messages;
  int error;
  PreliminaryData preliminaryData;

  BookingPrefil({this.status, this.messages, this.error, this.preliminaryData});

  BookingPrefil.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'];
    error = json['error'];
    preliminaryData = json['preliminary_data'] != null
        ? new PreliminaryData.fromJson(json['preliminary_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    data['error'] = this.error;
    if (this.preliminaryData != null) {
      data['preliminary_data'] = this.preliminaryData.toJson();
    }
    return data;
  }
}

class PreliminaryData {
  int id;
  String ownerName;
  String phonenumber;
  String emailOwner;
  String address,inspectionAddress;
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
  String bookingTime;
  String inspectionFee;
  String paymentPaid;
  String updatedAt;
  String createdAt;
  int status;
  String companyList;
  int isConfirm;
  int inspectorList;
  String inspectionType,state,businessName;
  int isSubmitted;
  int isCompliant;
  var street;
  var district;
  var city;
  var postcode;

  PreliminaryData({
    this.id,
    this.ownerName,
    this.phonenumber,
    this.inspectionAddress,
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
    this.inspectionType,
    this.recentlyInspected,
    this.rectificationIssued,
    this.certificateNonCompliance,
    this.bookingDateTime,
    this.bookingTime,
    this.inspectionFee,
    this.businessName,
    this.paymentPaid,
    this.updatedAt,
    this.createdAt,
    this.status,
    this.companyList,
    this.isConfirm,
    this.inspectorList,
    this.isSubmitted,
    this.isCompliant,
    this.street,
    this.district,
    this.city,
    this.postcode,
    this.state
  });

  PreliminaryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerName = json['owner_name'];
    inspectionType=json['inspection_type'];
    phonenumber = json['phonenumber'];
    emailOwner = json['email_owner'];
    businessName=json['owner_business_name'];
    inspectionAddress=json['inspection_address'];
    address = json['owner_address'];
    noticeRegis = json['notice_regis']=="yes"?"Yes":"No";
    nameRelevantCouncil = json['name_relevant_council'];
    emailRelevantCouncil = json['email_relevant_council'];
    councilRegisDate = json['council_regis_date'];
    noticeRegistration = json['notice_registration'];
    councilDueDate = json['Council_due_date'];
    swiPoolSpa = json['swi_pool_spa'];
    permntRelocate = json['permnt_relocate']=="permanent"?"Permanent":"Relocatable";
    recentlyInspected = json['recently_inspected']=="yes"?"Yes":"No";
    rectificationIssued = json['rectification_issued'];
    certificateNonCompliance = json['certificate_non_compliance'];
    bookingDateTime = json['booking_date_time'];
    bookingTime= json['booking_time'];
    inspectionFee = json['inspection_fee'];
    paymentPaid = json['payment_paid']=="yes"?"Yes":"No";
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    
    street = json['street_road'];
    district = json['municipal_district'];
    city = json['city_suburb'];
    postcode = json['postcode'];
    state=json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner_name'] = this.ownerName;
    data['inspection_type']=this.inspectionType;
    data['phonenumber'] = this.phonenumber;
    data['email_owner'] = this.emailOwner;
    data['inspection_address']=this.inspectionAddress;
    data['owner_business_name']=this.businessName;
    data['owner_address'] = this.address;
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
    data['booking_time'] = this.bookingTime;
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
    data['street_road'] = this.street;
    data['municipal_district'] = this.district;
    data['city_suburb'] = this.city;
    data['postcode'] = this.postcode;
    data['state'] = this.state;
    return data;
  }
}
