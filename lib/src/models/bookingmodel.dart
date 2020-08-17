class BookingModel {
  String noticeRegis;
  String ownerBusinessName;
  String phonenumber;
  String emailOwner;
  String address;
  String sendInvoice;
  String nameRelevantCouncil;
  String emailRelevantCouncil;
  String swiPoolSpa;
  String permntRelocate;
  String certificateofnoncomplianceissued;
  String poolfoundnoncompliant;
  String paymentPaid;
  String recentlyInspected;
  String inspectionFee;
  int noticeRegistration;
  String companyList;
  String councilDueDate;
  String bookingDateTime;
  String bookingTime;
  String councilRegisDate;
  int inspectorList;
  String state;
  String inspectionAddress;
  String ownerName;
  String inspectionType;
  var street;
  var district;
  var city;
  var postcode;

  BookingModel(
      {
        this.inspectionType,
        this.noticeRegis,
      this.ownerBusinessName,
      this.phonenumber,
      this.emailOwner,
      this.address,
      this.sendInvoice,
      this.street,
      this.district,
      this.city,
      this.postcode,
      this.nameRelevantCouncil,
      this.emailRelevantCouncil,
      this.swiPoolSpa,
      this.permntRelocate,
      this.certificateofnoncomplianceissued,
      this.poolfoundnoncompliant,
      this.paymentPaid,
      this.recentlyInspected,
      this.inspectionFee,
      this.noticeRegistration,
      this.companyList,
      this.inspectionAddress,
      this.ownerName,
      this.councilDueDate,
      this.bookingTime,
      this.bookingDateTime,
      this.inspectorList,
      this.councilRegisDate});

  BookingModel.fromJson(Map<String, dynamic> json) {
    noticeRegis = json['notice_regis']=="Yes"?"yes":"no";
    ownerBusinessName = json['owner_business_name'];
    phonenumber = json['phonenumber'];
    emailOwner = json['email_owner'];
    address = json['owner_address'];
    sendInvoice=json['send_invoice'];
    nameRelevantCouncil = json['name_relevant_council'];
    emailRelevantCouncil = json['email_relevant_council'];
    swiPoolSpa = json['swi_pool_spa'];
    inspectionAddress=json['inspection_address'];
    ownerName=json['owner_name'];
    certificateofnoncomplianceissued = json['certificateofnoncomplianceissued'];
    poolfoundnoncompliant = json['poolfoundnoncompliant'];
    paymentPaid = json['payment_paid']=="Yes"?"yes":"no";
    inspectionFee = json['inspection_fee'];
    inspectionType=json['inspection_type'];
    noticeRegistration = json['notice_registration'];
    companyList = json['company_list'];
    recentlyInspected=json['recently_inspected']=="Yes"?"yes":"no";
    inspectorList = json['inspector_list'];
    councilDueDate = json['Council_due_date'].toString();
    bookingDateTime = json['booking_date_time'].toString();
    bookingTime=json['booking_time'].toString();
    councilRegisDate = json['council_regis_date'].toString();
    street = json['street_road'];
    district = json['municipal_district'];
    city = json['city_suburb'];
    postcode = json['postcode'];
    state=json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inspection_type']=this.inspectionType;
    data['notice_regis'] = this.noticeRegis;
    data['owner_business_name'] = this.ownerBusinessName;
    data['phonenumber'] = this.phonenumber;
    data['email_owner'] = this.emailOwner;
    data['owner_address'] = this.address;
    data['inspection_address'] = this.inspectionAddress;
    data['owner_name']=this.ownerName;
    data['send_invoice']=this.sendInvoice;
    data['name_relevant_council'] = this.nameRelevantCouncil;
    data['email_relevant_council'] = this.emailRelevantCouncil;
    data['swi_pool_spa'] = this.swiPoolSpa;
    data['permnt_relocate'] = this.permntRelocate;
    data['recently_inspected'] = this.recentlyInspected;
    data['certificateofnoncomplianceissued'] = this.certificateofnoncomplianceissued;
    data['poolfoundnoncompliant'] = this.poolfoundnoncompliant;
    data['payment_paid'] = this.paymentPaid;
    data['inspection_fee'] = this.inspectionFee;
    data['notice_registration'] = this.noticeRegistration;
    data['company_list'] = this.companyList;
    data['Council_due_date'] = this.councilDueDate;
    data['booking_date_time'] = this.bookingDateTime;
    data['booking_time']=this.bookingTime;
    data['council_regis_date'] = this.councilRegisDate;
    data['inspector_list'] = this.inspectorList;
    data['street_road'] = this.street;
    data['state'] = this.state;
    data['municipal_district'] = this.district;
    data['city_suburb'] = this.city;
    data['postcode'] = this.postcode;
    return data;
  }
}
