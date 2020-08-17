import 'dart:io';

class CompanyFields {
  String abn;
  String address;
  String cname;
  String email;
  String phone;
  String regno;
  String username;
  String password;
  String cpassword;
  String cardNumber;
  String cardCvv;
  String cardExpiryMonth;
  String cardExpiryYear;
  File logo;

  CompanyFields(
      {this.abn,
      this.address,
      this.cname,
      this.email,
      this.phone,
      this.regno,
      this.username,
      this.password,
      this.cpassword,
      this.logo,
      this.cardNumber,
      this.cardCvv,
      this.cardExpiryMonth,
      this.cardExpiryYear});

  CompanyFields.fromJson(Map<String, dynamic> json, File file) {
    abn = json['abn'];
    address = json['address'];
    cname = json['cname'];
    email = json['email'];
    phone = json['phone'];
    regno = json['regno'];
    username = json['username'];
    password = json['password'];
    logo = file;
    cpassword = json['cpassword'];
    cardNumber = json['card_number'];
    cardCvv = json['card_cvv'];
    cardExpiryMonth = json['card_expiry_month'];
    cardExpiryYear = json['card_expiry_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['abn'] = this.abn;
    data['address'] = this.address;
    data['cname'] = this.cname;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['regno'] = this.regno;
    data['username'] = this.username;
    data['password'] = this.password;
    data['cpassword'] = this.cpassword;
    data['logo'] = this.logo;
    data['card_number'] = this.cardNumber;
    data['card_cvv'] = this.cardCvv;
    data['card_expiry_month'] = this.cardExpiryMonth;
    data['card_expiry_year'] = this.cardExpiryYear;
    return data;
  }
}
