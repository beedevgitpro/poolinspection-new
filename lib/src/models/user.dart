class UserModel {
  int status;
  String token;
  Userdata userdata;
  String message;
  String errors;

  UserModel(
      {this.status, this.token, this.userdata, this.message, this.errors});

  UserModel.fromJSON(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    userdata = json['userdata'] != null
        ? new Userdata.fromJSON(json['userdata'])
        : null;
    message = json['message'];
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['token'] = this.token;
    if (this.userdata != null) {
      data['userdata'] = this.userdata.toJson();
    }
    data['message'] = this.message;
    data['errors'] = this.errors;
    return data;
  }
}

class Userdata {
  User user;
  Company company;
  Inspector inspector;

  Userdata({this.user, this.company, this.inspector});

  Userdata.fromJSON(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJSON(json['user']) : null;
    company =
        json['company'] != null ? new Company.fromJSON(json['company']) : null;
    inspector = json['inspector'] != null
        ? new Inspector.fromJSON(json['inspector'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.company != null) {
      data['company'] = this.company.toJson();
    }
    if (this.inspector != null) {
      data['inspector'] = this.inspector.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String name;
  String email;
  String username;
  String password;
  String registrationNumber;
  String membershipNumber;
  Null emailVerifiedAt;
  int rolesManage;
  String createdAt;
  String updatedAt;
  int status;
  int isPasswordApproved;
  int isPasswordChange;
  String confirmPassword;
  User(
      {this.id,
      this.name,
      this.email,
      this.username,
      this.password,
      this.confirmPassword,
      this.registrationNumber,
      this.membershipNumber,
      this.emailVerifiedAt,
      this.rolesManage,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.isPasswordApproved,
      this.isPasswordChange});

  User.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    registrationNumber = json['registration_number'];
    membershipNumber = json['membership_number'];
    emailVerifiedAt = json['email_verified_at'];
    rolesManage = json['roles_manage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    password = json['password'];
    confirmPassword = json['confirm_password'];
    isPasswordApproved = json['is_password_approved'];
    isPasswordChange = json['is_password_change'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['registration_number'] = this.registrationNumber;
    data['membership_number'] = this.membershipNumber;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['roles_manage'] = this.rolesManage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['is_password_approved'] = this.isPasswordApproved;
    data['is_password_change'] = this.isPasswordChange;
    data['confirm_password'] = confirmPassword;

    return data;
  }
}

class Company {
  int id;
  String companyName;
  String companyAbn;
  String companyLogo;
  String companyAddress;
  String email;
  String phoneNumber;
  String registrationNumber;
  String username;
  String updatedBy;
  Null createdBy;
  String updatedAt;
  String createdAt;
  int status;

  Company(
      {this.id,
      this.companyName,
      this.companyAbn,
      this.companyLogo,
      this.companyAddress,
      this.email,
      this.phoneNumber,
      this.registrationNumber,
      this.username,
      this.updatedBy,
      this.createdBy,
      this.updatedAt,
      this.createdAt,
      this.status});

  Company.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    companyAbn = json['company_abn'];
    companyLogo = json['company_logo'];
    companyAddress = json['company_address'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    registrationNumber = json['registration_number'];
    username = json['username'];
    updatedBy = json['updated_by'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['company_abn'] = this.companyAbn;
    data['company_logo'] = this.companyLogo;
    data['company_address'] = this.companyAddress;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['registration_number'] = this.registrationNumber;
    data['username'] = this.username;
    data['updated_by'] = this.updatedBy;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}

class Inspector {
  int id;
  String firstName;
  String lastName;
  String inspectorAbn;
  String inspectorImage;
  String registrationNumber;
  String inspectorAddress;
  String email;
  String mobileNumber;
  String inspectorSignature;
  String username;
  int companyId;
  String updatedBy;
  String createdBy;
  String updatedAt;
  String createdAt;
  int status;

  Inspector(
      {this.id,
      this.firstName,
      this.lastName,
      this.inspectorAbn,
      this.inspectorImage,
      this.registrationNumber,
      this.inspectorAddress,
      this.email,
      this.mobileNumber,
      this.inspectorSignature,
      this.username,
      this.companyId,
      this.updatedBy,
      this.createdBy,
      this.updatedAt,
      this.createdAt,
      this.status});

  Inspector.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    inspectorAbn = json['inspector_abn'];
    inspectorImage = json['inspector_image'];
    registrationNumber = json['registration_number'];
    inspectorAddress = json['inspector_address'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    inspectorSignature = json['inspector_signature'];
    username = json['username'];
    companyId = json['company_id'];
    updatedBy = json['updated_by'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['inspector_abn'] = this.inspectorAbn;
    data['inspector_image'] = this.inspectorImage;
    data['registration_number'] = this.registrationNumber;
    data['inspector_address'] = this.inspectorAddress;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    data['inspector_signature'] = this.inspectorSignature;
    data['username'] = this.username;
    data['company_id'] = this.companyId;
    data['updated_by'] = this.updatedBy;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}
