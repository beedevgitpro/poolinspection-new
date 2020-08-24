import 'dart:async';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poolinspection/src/elements/custom_progress_dialog.dart';
import 'package:poolinspection/src/helpers/sharedpreferences/userpreferences.dart';
import 'package:poolinspection/src/models/bookingmodel.dart';
import 'package:poolinspection/src/models/errorclasses/errorsignupcompanymodel.dart';
import 'package:poolinspection/src/repository/booking_repository.dart' as repository;
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;
import 'package:poolinspection/src/repository/booking_repository.dart';

class BookingFormController extends ControllerMVC {
  GlobalKey<FormBuilderState> bookingFormKey;
  bool bookingLoader = false;
  bool bookingLoader1 = false;
  bool prefilLoader1 = false;
  bool prefilLoader2 = false;
  bool prefilLoader3 = false;
  String bookingIdforStore;
  BookingPrefil preliminaryData;
  List regulationdata;
  List<String> companyinspectors;
  final councilDueDate = TextEditingController();
  final bookingDateTime = TextEditingController();
  final bookingTime = TextEditingController();
  final councilRegisDate = TextEditingController();
  int roles;
  BookingFormController() {
    regulationdata = List();
    preliminaryData = BookingPrefil();
    companyinspectors = List<String>();
    bookingFormKey = GlobalKey<FormBuilderState>();
    decideView();
    getRegulations();
 
  }
  var predata;
  getRegulations() async {
    repository.getAllRegulations().then((onValue) {
      setState(() {
        for (var i = 0; i < onValue['get_all_regulation'].length; i++) {
      
          regulationdata.add(onValue['get_all_regulation'][i]);
        }
      });
    });
  }

  getPreliminaryData(int jobid) async {
    repository.preliminaryDataFromJobNo(jobid,context).then((onValue) {
      setState(() {
        print('Prefill Response: '+onValue['preliminary_data']['state'].toString());
        predata = onValue;
        preliminaryData = BookingPrefil.fromJson(onValue);
      });
    });
  }

  getinspectorList() async {
    userRepo.company != null
        ? repository.getCompanyInspectors(3).then((onValue) {
        
            setState(() {
              for (var i = 0;
                  i < onValue['get_company_inspector'].length;
                  i++) {
                companyinspectors
                    .add(onValue['get_company_inspector'][i]['first_name']);
              }
              print(companyinspectors.length);
            });
          })
        : print('Company id null');
  }

  Future decideView() async {
    UserSharedPreferencesHelper.getRoles().then((onValue) {
      print(onValue);
      setState(() {
        roles = onValue;
      });
    });
  }

  sendEnquiry(BuildContext context) {
        String sendInvoice=bookingFormKey.currentState.value["send_invoice"];
        if (bookingFormKey.currentState.validate()) {
          bookingFormKey.currentState.save();
          
          setState(() {

            bookingFormKey.currentState.value["send_invoice"]=="1"?bookingLoader1=true:bookingLoader = true;

          }
          );
          final pr=ProgressDialog(context);
          pr.show();
          repository.postBooking(BookingModel.fromJson(bookingFormKey.currentState.value),context)
              .then((onValue) {
                pr.hide();
               print("checkinbook="+onValue.toString());
               if(onValue!=null) {
                 print(bookingFormKey.currentState.value["send_invoice"]);
                 if(sendInvoice=='0')
                  Navigator.of(context).pushReplacementNamed('/Home');
                 Flushbar(
                   title: sendInvoice=="1"?"Invoice Sent":"Done Booking",
                   message: sendInvoice=="1"?onValue['messages']:onValue['messages'],
                   duration: Duration(seconds: 3),
                 )
                   ..show(context);
               }
               else
                 {
                   setState(() {
                     bookingLoader1=false;
                     bookingLoader=false;
                   });
                 }

          });
        }

   
  }

  confirmToQuestions(Map<String, dynamic> value, BuildContext context) {
    final pr=ProgressDialog(context);
    setState(() {
      value["send_invoice"]=="1"?prefilLoader1=true:value["send_invoice"]=="2"?prefilLoader2 = true:prefilLoader3=true;
    }
    );
    pr.show();
    confirmPreliminaryBooking(value, predata,context).then((onValue) {
           pr.hide();
       if(onValue!=null) {
        storeListDataInLocal(onValue,value['bookingid'].toString());
        if(value["send_invoice"]=="3")
         Navigator.pushReplacementNamed(context, "/Home");
         Flushbar(
           title: value["send_invoice"]=="1"?"Details Saved":value["send_invoice"]=="2"?'eInvoice Sent':"Details Confirmed",
           message: value["send_invoice"]=="1"?"Details have to be confirmed":value["send_invoice"]=="2"?'Details have to be confirmed':"Inspection has to be Initiated",
           duration: Duration(seconds: 3),
         )
           ..show(context);



       }
       else
         {
           setState(() {
             prefilLoader1=false;
             prefilLoader2=false;
             prefilLoader3=false;
           });
         }


    });
  }

  storeListDataInLocal(var onValue, String name)
  {
    bookingIdforStore=name.toString();
    writeCounter(onValue,name);


  }
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory(); //maybe for ios permission issue you have to change it into getApplicationSupportDirectorytype kuch.

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    print("bookingid"+bookingIdforStore.toString());
    return File('$path/$bookingIdforStore.txt');
  }

  Future<File> writeCounter(var onValue,String name) async {

    final file = await _localFile;
    print("writepath="+file.path.toString());
    return file.writeAsString(onValue);
  }


}
