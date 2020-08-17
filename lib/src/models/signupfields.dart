import 'dart:io';

class SignUpUser {
  String firstName;
  String lastName;
  int inspectorAbn;
  int registrationNumber;
  String inspectorAddress;
  String email;
  int mobileNo;
  String username;
  String password;
  String taxApplicable;
  String passwordConfirmation;
  int cardNumber;
  int cardCvv;
  var cardExpiryMonth;
  int cardExpiryYear;
  int cardType;
  // File inspectorSignature;
  File inspectorImage;
  var street;
  // var district;
  var city;
  var postcode;

  String companyName;
  int companyAbn;
  String companyAddress;
  File companyLogo;

  SignUpUser(
      {this.firstName,
      this.lastName,
      this.inspectorAbn,
      this.registrationNumber,
      this.inspectorAddress,
      this.email,
      this.mobileNo,
      this.username,
        this.taxApplicable,
      this.password,
      this.passwordConfirmation,

      // this.inspectorSignature,
      this.street,
      // this.district,
      this.city,
      this.postcode,
      this.inspectorImage,
      this.companyName,
      this.companyAbn,
      this.companyAddress,
      this.companyLogo});

  SignUpUser.fromJson(
      Map<String, dynamic> json, File signature, File photo, File logo) {
    print(photo.toString());

    firstName = json['first_name'];
    lastName = json['last_name'];
    inspectorAbn = json['inspector_abn'] is String
        ? int.parse(json['inspector_abn'])
        : json['inspector_abn'];
    registrationNumber = int.parse(json['registration_number']);
    inspectorAddress = json['inspector_address'];
    email = json['email'];
    mobileNo = int.parse(json['mobile_no']);
    username = json['username'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
    // inspectorSignature = signature;
    inspectorImage = photo;
    street = json['Street'];
    taxApplicable=json['tax_applicable'];
    // district = json['District']??'null';
    city = json['City'];
    postcode = json['Postcode'];

    companyName = json['company_name'];
    companyAbn = json['company_abn'] == null
        ? 12312312312
        : int.parse(json['company_abn']);
    companyAddress = json['company_address'];
    companyLogo = photo;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['inspector_abn'] = this.inspectorAbn;
    // data['inspector_signature'] = this.inspectorSignature;
    data['inspector_image'] = this.inspectorImage;
    data['inspector_address'] = this.inspectorAddress;

    data['registration_number'] = this.registrationNumber;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['username'] = this.username;
    data['password'] = this.password;
    data['password_confirmation'] = this.passwordConfirmation;

    data['Street'] = this.street;
    // data['District'] = this.district;
    data['City'] = this.city;
    data['Postcode'] = this.postcode;
    data['company_name'] = this.companyName;
    data['tax_applicable'] = this.taxApplicable;
    data['company_abn'] = this.companyAbn;
    data['company_address'] = this.companyAddress;
    data['company_logo'] = this.inspectorImage;
    return data;
  }
}
