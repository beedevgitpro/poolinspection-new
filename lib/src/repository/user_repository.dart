import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:poolinspection/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/models/generic_response.dart';
import 'package:poolinspection/src/models/signupfields.dart';
import 'package:poolinspection/src/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

UserModel currentUser = new UserModel();
Inspector inspector = new Inspector();
Company company = new Company();
User user = new User();
int userid;
String token;

// Future<UserModel> login(User user) async {
//   final String url =
// '$publicBaseUrl'+'login_api';
//   final client = new http.Client();
//   final response = await client.post(
//     url,
//     headers: {HttpHeaders.contentTypeHeader: 'application/json'},
//     body: json.encode(user.toJson()),
//   );
//   print(response.body);
//   currentUser = UserModel.fromJSON(json.decode(response.body));
//   UserSharedPreferencesHelper.setUserdetails(response.body);

//   return currentUser;

// }
Future login(User user,context) async {

  final String url =
      '$publicBaseUrl'+'login_api';
  final client = new http.Client();
  try {

    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(user.toJson()),
    );
//
    print(response.body);

    return json.decode(response.body);
  }
  on TimeoutException catch (_) {
    Fluttertoast.showToast(
        msg: "Connection Time Out ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: getFontSize(context,-2)
    );
  }
  on SocketException catch (_) {
    Fluttertoast.showToast(
        msg: "No Internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: getFontSize(context,-2)
    );
  }
  on Exception catch (e) {
    Fluttertoast.showToast(
        msg: "Error:"+e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: getFontSize(context,-2)
    );
  }


}


Future registerInspector(SignUpUser fields,context) async {
  Dio dio = new Dio();

  final String url =
      '$publicBaseUrl'+'register_inspector_api';

  FormData formData = FormData.fromMap({
    "registration_number": fields.registrationNumber,
    "email": fields.email,
    "mobile_no": fields.mobileNo,
    "username": fields.username,
    "password": fields.password,
    "password_confirmation": fields.passwordConfirmation,
    "card_number": fields.cardNumber,
    "card_cvv": fields.cardCvv,
    "card_expiry_month": fields.cardExpiryMonth,
    "card_expiry_year": fields.cardExpiryYear,
    "card_type": 1,
    "Street": fields.street,
    "Postcode": fields.postcode,
    "City": fields.city,
    // "District": fields.district,
    "first_name": fields.firstName,
    "last_name": fields.lastName,
    "inspector_abn": fields.inspectorAbn,
    "tax_applicable":fields.taxApplicable=="Yes"?"1":"0",
    "inspector_address":fields.inspectorAddress,

    "inspector_image": await MultipartFile.fromFile(fields.inspectorImage.path,
        filename: "Inspectorimage")
  });
  try {
    final response = await dio.post(url,
        data: formData,
        options: Options(headers: {
          "Accept": "application/json",
          // 'Authorization': 'Bearer $authToken',
        }));

    print(response.data);
    return response.data;
  }
  on DioError catch (e) {
    if (e.type == DioErrorType.DEFAULT) {
      Fluttertoast.showToast(
          msg: "No Internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );
    }
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      Fluttertoast.showToast(
          msg: "No Internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );
    }
    if (e.type == DioErrorType.RESPONSE) {
      Fluttertoast.showToast(
          msg: "Error:",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );
    }
  }

}

Future addCompanyInspector(SignUpUser fields) async {
  Dio dio = new Dio();

  print("${company.id} sdsdsdsds");
  final String url =
      '$publicBaseUrl'+'register_inspector_api';
  print(url);
  FormData formData = FormData.fromMap({
    "first_name": fields.firstName,
    "last_name": fields.lastName,
    "registration_number": fields.registrationNumber,
    "email": fields.email,
    "mobile_no": fields.mobileNo,
    "username": fields.username,
    "password": fields.password,
    "password_confirmation": fields.passwordConfirmation,
    "inspector_abn": fields.inspectorAbn,
    "inspector_address": fields.inspectorAddress,
    // "inspector_signature": await MultipartFile.fromFile(
    //     fields.inspectorSignature.path,
    //     filename: "text1.png"),
      "inspector_image": await MultipartFile.fromFile(fields.inspectorImage.path,
  filename: "Inspectorimage"),   // this can break code
    "company_id": company.id
  });
  try {
    final response = await dio.post(url,
        data: formData,
        options: Options(headers: {
          "Accept": "application/json",
          // 'Authorization': 'Bearer $authToken',
        }));
    print(response.data);
    return response.data;
  } catch (e) {
    return e;
  }
}

Future registerCompany(SignUpUser fields) async {
  Dio dio = new Dio();
  final String url =
      "$baseUrl/register_company_api";
  print("urlofcompanysignup="+url.toString());
  var formData = FormData.fromMap({
    "registration_number": fields.registrationNumber,
    "email": fields.email,
    "mobile_no": fields.mobileNo,
//    "username": fields.username,
    "password": fields.password,
    "password_confirmation": fields.passwordConfirmation,
//    "card_number": fields.cardNumber,
//    "card_cvv": fields.cardCvv,
//    "card_expiry_month": fields.cardExpiryMonth,
//    "card_expiry_year": fields.cardExpiryYear,
//    "card_type": 1,
    "Street": fields.street,
    "Postcode": fields.postcode,
    "City": fields.city,
    "tax_applicable":fields.taxApplicable,
    // "District": fields.district,
    "company_logo": await MultipartFile.fromFile(fields.companyLogo.path,
        filename: "text121123.png"),
    "company_name": fields.companyName,
    "company_abn": fields.companyAbn,
    "company_address": fields.companyAddress,
  });

  try {
    final response = await dio.post(url,
        data: formData,
        options: Options(headers: {
          "Accept": "application/json",
          // 'Authorization': 'Bearer $authToken',
        }));


    print("usersignupinspectorresponse"+response.data.toString());
    return response.data;
  } catch (e) {
    return e;
  }
}

Future<void> logout() async {
  currentUser = new UserModel();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
  await prefs.remove('token');
}



Future<GenericResponse> forgetPassword(String text) async {
  // final String _apiToken = 'api_token=${currentUser}';
  final String url =
      '$publicBaseUrl'+'reset_password_request_api';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode({"email": text}),
  );
  Map<String, dynamic> responseJson = json.decode(response.body);
  GenericResponse genericResponse = GenericResponse.fromJson(responseJson);

  print(genericResponse.messages);

  // setCurrentUser(response.body);
  // currentUser = User.fromJson(json.decode(response.body)['data']);
  // return json.decode(response.body);
  return genericResponse;
}

Future<GenericResponse> updatePassword(User user) async {
  // // final String _apiToken = 'api_token=${currentUser}';
  final String url =
      '$publicBaseUrl'+'change_password_api';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode({
      "new_password": user.password,
      "confirm_password": user.confirmPassword,
      "user_id": 13
    }),
  );
  Map<String, dynamic> responseJson = json.decode(response.body);
  GenericResponse genericResponse = GenericResponse.fromJson(responseJson);
  print(genericResponse.messages);
  // setCurrentUser(response.body);
  // currentUser = User.fromJson(json.decode(response.body)['data']);
  // return json.decode(response.body);
  return genericResponse;
}

