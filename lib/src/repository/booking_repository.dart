import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/inspection_controller.dart';
import 'package:http/http.dart' as http;
import 'package:poolinspection/constants.dart';
Future getAllRegulations() async {
  final String _apiToken = 'beedev';
  final String url =
      '$publicBaseUrl$_apiToken/get_all_regulation';
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load post');
  }
}

Future getCompanyInspectors(int id) async {
  final String _apiToken = 'beedev';
  final String url =
      '$publicBaseUrl$_apiToken/get_company_inspector/$id';
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load post');
  }
}


Future postBooking(value,context) async {
  final String _apiToken = 'beedev';
  try {
    final String url =
        '$baseUrl/$_apiToken/booking_api';
    final client = new http.Client();
    final response = await client.post(url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(value));
    print("responsebody" + response.body.toString());
    return json.decode(response.body);
  }
  on TimeoutException catch (_) {
    Fluttertoast.showToast(
        msg: "Connection Time Out ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:Colors.red,
        textColor:Colors.white ,
        fontSize: getFontSize(context,-2)
    );
  }
  on SocketException catch (e) {
    print(e);
    Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: getFontSize(context,-2)
    );
  }
  on Exception catch (e) {
    print(e);
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

Future confirmPreliminaryBooking(
    Map<String, dynamic> predata, predataprefilled,context) async {
  print(predataprefilled['preliminary_data']['inspector_list']);
  final String _apiToken = 'beedev';
  try {
    final String url ='$publicBaseUrl$_apiToken/confirm_preliminary_data/${predata['bookingid']}';
    print(url);
    print('inConfirm');
    final client = new http.Client();
    var bodydata = {
      'owner_name': predata['owner_name'],
      'owner_business_name': predata['owner_business_name'],
      "phonenumber": predata['phonenumber'],
      "email_owner": predata['email_owner'],
      "inspection_address": predata['inspection_address'] ,
      "owner_address": predata['owner_address'] ?? "null",
      "name_relevant_council": predata['name_relevant_council'],
      "swi_pool_spa": predata['swi_pool_spa'],
     
      "payment_paid": predata['payment_paid'],
      "inspection_fee": predata['inspection_fee'],
      "send_invoice": predata['send_invoice'],
      "notice_registration": predata['notice_registration'].toString(),
      "booking_date_time": predata['booking_date_time'].toString(),
      "booking_time": predata['booking_time'].toString(),
      "council_regis_date": predata['council_regis_date'].toString(),
      "inspector_list": predataprefilled['preliminary_data']['inspector_list'],
      // "notice_regis": predataprefilled['preliminary_data']['notice_regis'],
      // "street_road": predata['street_road'],
      "postcode": predata['postcode'],
      // "city_suburb": predata['city_suburb'],
      "state": predata['state'],
      "inspection_type":predata["inspection_type"]
      // "municipal_district": predata['municipal_district'] ?? "null",
    };
    print(bodydata);
    final response = await client.post(url,
        body: bodydata);

    return response.body;
  }
  on TimeoutException catch (_) {
    
    Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: getFontSize(context,-2)
    );
  }
  on SocketException catch (e) {
    print(e);
    Fluttertoast.showToast(
        msg: "No Internet Connection",
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

Future getHeadersFromBookingId(int bookingid,context) async {
  final String _apiToken = 'beedev';
  try {
  final String url =
      '$publicBaseUrl$_apiToken/get_heading_with_booking_id/$bookingid';
  final response = await http.get(url);
  print("$url getHeadersFromBookingId");
  if (response.statusCode == 200) {

     print("responseofhead="+response.body.toString());
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load post');
  }
  }
  on TimeoutException catch (_) {
    Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: getFontSize(context,-2)
    );
  }
  on SocketException catch (e) {
    print(e);
    Fluttertoast.showToast(
        msg: "No Internet Connection",
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

Future getQuestionsFromHeadingId(int headingId, int booking,context) async {
  final String _apiToken = 'beedev';
  try {
    final String url =
        '$baseUrl/$_apiToken/questions_from_headingID/$booking/$headingId';
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
  on TimeoutException catch (_) {
    Fluttertoast.showToast(
        msg: "Connection Time Out ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:Colors.red,
        textColor:Colors.white ,
        fontSize: getFontSize(context,-2)
    );
  }
  on SocketException catch (e) {
    print(e);
    Fluttertoast.showToast(
        msg: "No Internet Connection",
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

Future preliminaryDataFromJobNo(int jobno,context) async {
  final String _apiToken = 'beedev';
  try
  {
  final String url =
      '$publicBaseUrl$_apiToken/preliminary_data/$jobno';
  print(url);
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return json.decode(response.body);

  } else {
    throw Exception('Failed to load post');
  }

  }
  on TimeoutException catch (_) {
    Fluttertoast.showToast(
        msg: "Connection Time Out ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:Colors.red,
        textColor:Colors.white ,
        fontSize: getFontSize(context,-2)
    );
  }
  on SocketException catch (e) {
    print(e);
    Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: getFontSize(context,-2)
    );
  }
  on Exception catch (e) {
    print(e);
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

Dio dio = new Dio();
Future postBookingAnswer(QuestionData fields,context) async {


  final String _apiToken = 'beedev';

  final String url =
      '$publicBaseUrl$_apiToken/booking_ans_post';
  print(url);
  print("imagepath${fields.imagepath}");
  FormData formData = fields.imagepath == null
      ? FormData.fromMap({
          "bookin_ans_id": fields.bookingAnsId,
          "comment": fields.comment,
          "question_id": fields.questionId,
          "booking_id": fields.bookingID,
          "ans": fields.choice,
          
        })
      : FormData.fromMap({
          "bookin_ans_id": fields.bookingAnsId,
          "comment": fields.comment,
          "question_id": fields.questionId,
          "booking_id": fields.bookingID,
          "ans": fields.choice,
          "images":  [
            for(var i = 0; i < fields.imagename.length; i++)
             await MultipartFile.fromFile(fields.imagepath[i],
                  filename: fields.imagename[i])
]
//          [
//            for (var i = 0; i < fields.imagename.length; i++)
//              await MultipartFile.fromFile(fields.imagepath[i],
//                  filename: fields.imagename[i])
//          ]
          // "images[]": await MultipartFile.fromFile(fields.image.path,
          //     filename: "text121123.png")
        });
  // print(formData.toString())
  try {
    final response = await dio.post(url,
        data: formData,
        options: Options(headers: {
          "Accept": "application/json",
          // 'Authorization': 'Bearer $authToken',
        }));
     print("qwertyuiop"+response.data.toString());
    return response.data;
  }   on DioError catch (e) {

    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      Fluttertoast.showToast(
          msg: "Connection TimeOut",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );
    }
    if (e.type == DioErrorType.DEFAULT) {
      Fluttertoast.showToast(
          msg: "Offline Submitted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );
      return "No Internet";
    }
    if (e.type == DioErrorType.RESPONSE) {
      Fluttertoast.showToast(
          msg: "Error: ${e.message}",
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

Future completeMark(int bookingid, int choice) async {
  final String _apiToken = 'beedev';

  final String url =
      '$publicBaseUrl$_apiToken/compliance_post';
  FormData formData = FormData.fromMap({
    "booking_id": bookingid,
    "is_compliant": choice,
  });
  try {
    final response = await dio.post(url,
        data: formData,
        options: Options(headers: {
          "Accept": "application/json",
          // 'Authorization': 'Bearer $authToken',
        }));
    return response.data;
  } catch (e) {
    return e;
  }
}

Future getAllQuestionsCount(int jobno) async {
  final String _apiToken = 'beedev';
  final String url =
      '$publicBaseUrl$_apiToken/get_all_question_from_job_id/$jobno';
  print(url);
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return json.decode(response.body);

    // print(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

Future getAllQuestionsCountFromHeading(int bookingid, int headingid) async {
  final String _apiToken = 'beedev';
  final String url =
      '$publicBaseUrl$_apiToken/check_all_question_filled_in_heading/$bookingid/$headingid';
  print(url);
  final response = await http.get(url);
  if (response.statusCode == 200) {
    // print(json.decode(response.body)['not_answered']);

    return json.decode(response.body);
  } else {
    throw Exception('Failed to load post');
  }
}


/*

api of all answer send ,
prev , next can be done but tell later.
 */