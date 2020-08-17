import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/constants/validators.dart';
import 'package:poolinspection/src/controllers/bookingform_controller.dart';
import 'package:poolinspection/src/elements/dropdown.dart';
import 'package:poolinspection/src/elements/inputdecoration.dart';
import 'package:poolinspection/src/elements/radiobutton.dart';
import 'package:poolinspection/src/elements/textfield.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/helpers/connectivity.dart';
import 'package:poolinspection/src/models/errorclasses/errorsignupcompanymodel.dart';

// ignore: must_be_immutable
class PreliminaryWidget extends StatefulWidget {
  PreliminaryWidget(this.jobNo);
  int jobNo = 0;
  @override
  _PreliminaryWidgetState createState() => _PreliminaryWidgetState();
}

class _PreliminaryWidgetState extends StateMVC<PreliminaryWidget> {
  BookingFormController _bookingFormController;
  _PreliminaryWidgetState() : super(BookingFormController()) {
    _bookingFormController = controller;
  }
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  
  var data;

  bool autoValidate = true;

  bool readOnly = false;

  ValueChanged _onChanged = (val) => print(val);

  final councilDueDate = TextEditingController();
  final bookingDateTime = TextEditingController();
  final bookingTime = TextEditingController();
  final councilRegisDate = TextEditingController();
  bool isOnline = false;
  ConnectionStatusSingleton connectionStatus;
  DateTime picked;
  @override
  void initState() {
    connectionStatus = ConnectionStatusSingleton.getInstance();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkingInternet();
    });
    _bookingFormController.getPreliminaryData(widget.jobNo);
    super.initState();
  }

  Future checkingInternet() async {
    await connectionStatus.checkConnection().then((val) {
      isOnline = val;
    });
  }


  void connectionChanged(dynamic hasConnection) {
    setState(() {
      connectionStatus.checkConnection().then((val) {
        isOnline = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.Colors().scaffoldColor(1),
      appBar: AppBar(
        title: Text("Confirm Preliminary Information",
            style: TextStyle(
                fontFamily: "AVENIRLTSTD",
                fontSize: getFontSize(context,2),
                color: Color(0xff222222),
                fontWeight: FontWeight.normal)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: _bookingFormController.preliminaryData.preliminaryData == null
            ? Center(
        child: isOnline
            ? CircularProgressIndicator()
            : SizedBox(
                width: MediaQuery.of(context).size.width * 2 / 3,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    color: Colors.redAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        Text(
                          " Checking Internet...",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "AVENIRLTSTD",
                              fontSize: getFontSize(context,2)),
                        )
                      ],
                    ),
                    onPressed: () async {
                      connectionChanged(await connectionStatus
                          .checkConnection()
                          .then((val) {
                        isOnline = val;
                      }));
                    }),
              ),
      )
            : Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.jobNo == 0
            ? CircularProgressIndicator()
            : Stack(
                children: <Widget>[
                  GestureDetector(
                    onPanDown: (_){
          FocusScope.of(context).requestFocus(FocusNode());
        },
                                      child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              bookingForm(context,
                                  _bookingFormController.preliminaryData.preliminaryData),
                              Row(
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                              onTap: () {
                                                
                                                
                                                  if (_fbKey.currentState
                                                      .validate()) {
                                                    print("Bookingtimegoku" +
                                                        _fbKey
                                                            .currentState
                                                            .value[
                                                                'booking_time']
                                                            .toString());

                                                    _fbKey.currentState
                                                            .initialValue[
                                                        'send_invoice'] = "1";

                                                    _fbKey.currentState
                                                        .save();
                                                    print(
                                                        "${_fbKey.currentState.value}  formm");
                                                    _bookingFormController.confirmToQuestions(
                                                        _fbKey.currentState
                                                            .value,
                                                        context);
                                                  }
                                               
                                              },
                                              child: Container(
                                                padding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 15),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Save",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontFamily:
                                                        "AVENIRLTSTD",
                                                    fontSize: getFontSize(context,-2),
                                                  ),
                                                ),
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            )),
                                  SizedBox(width: 3),
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                        if (_fbKey.currentState
                                            .validate()) {
                                          _fbKey.currentState.initialValue[
                                              'send_invoice'] = "2";
                                          _fbKey.currentState.save();
                                          print(
                                              "${_fbKey.currentState.value}  formm");
                                          _bookingFormController.confirmToQuestions(
                                              _fbKey.currentState.value,
                                              context);
                                        }
                                     
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "eInvoice",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontFamily: "AVENIRLTSTD",
                                          fontSize: getFontSize(context,-2),
                                        ),
                                      ),
                                      color: Theme.of(context).accentColor,
                                    ),
                                  )),
                                  SizedBox(width: 3),
                                  Expanded(
                                      child:GestureDetector(
                                    onTap: () {
                                      
                                        if (_fbKey.currentState
                                            .validate()) {
                                          _fbKey.currentState.initialValue[
                                              'send_invoice'] = "3";
                                          _fbKey.currentState.save();
                                          print(
                                              "${_fbKey.currentState.value}  formm");
                                          print('lol');
                                          _bookingFormController.confirmToQuestions(
                                              _fbKey.currentState.value,
                                              context);
                                        }
                                     
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontFamily: "AVENIRLTSTD",
                                          fontSize: getFontSize(context,-2),
                                        ),
                                      ),
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ))
                                ],
                              ),
                              SizedBox(height:10)
                            ],
                          )),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  FormBuilder bookingForm(BuildContext context, PreliminaryData pre) {
    return FormBuilder(
      key: _fbKey,
      readOnly: readOnly,
      initialValue: {
        "send_invoice": "1",
        'bookingid': pre.id,
        'state': pre.state,
        'inspection_type': pre.inspectionType,
        'owner_business_name': pre.businessName,

        "owner_name": pre.ownerName,
        "phonenumber": pre.phonenumber,
        "email_owner": pre.emailOwner,
        "inspection_address": pre.inspectionAddress,
        "name_relevant_council": pre.nameRelevantCouncil,
        
        "swi_pool_spa": pre.swiPoolSpa,
        "permnt_relocate": pre.permntRelocate,
        "payment_paid": pre.paymentPaid,
        "inspection_fee": pre.inspectionFee,
        "notice_registration": int.parse(pre.noticeRegistration),
        "booking_date_time": DateTime.parse(pre.bookingDateTime),
        "booking_time": DateTime.parse("2012-02-27 " + pre.bookingTime),
        "council_regis_date": pre.councilRegisDate.isEmpty
            ? null
            : DateTime.parse(pre.councilRegisDate),
        "street_road": pre.street,
        "postcode": pre.postcode,
        "city_suburb": pre.city,
        "recently_inspected": pre.recentlyInspected,
        "municipal_district": pre.district,
        "owner_address": pre.address
      },
      autovalidate: autoValidate,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: listView(context, pre),
      ),
    );
  }

  Column listView(BuildContext context, PreliminaryData pre) {
    final sizedbox =
        SizedBox(height: config.App(context).appVerticalPadding(2));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              sizedbox,
              Text(
                "Relevant Council",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              CustomFormBuilderTextField(
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: getFontSize(context,2),
                  fontFamily: "AVENIRLTSTD",
                ),
                textInputAction: TextInputAction.done,
                attribute: "name_relevant_council",
                decoration: buildInputDecoration(
                    context,
                    "The name of the relevant Council that issued \nthe Notice of Registration",
                    "Enter Council's Name"),
                keyboardType: TextInputType.text,
                validators: [
                  // FormBuilderValidators.min(3),
                  FormBuilderValidators.max(20),
                  CustomFormBuilderValidators.charOnly(),
                  FormBuilderValidators.required()
                ],
              ),
              sizedbox,
              Text(
                "Date Of Construction of Pool/Spa",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              FormBuilderDateTimePicker(
                style: TextStyle(
                    color: Color(0xff222222),
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,2)),
                controller: _bookingFormController.councilRegisDate,
                attribute: "council_regis_date",
                inputType: InputType.date,
                validators: [FormBuilderValidators.required()],
                format: new DateFormat("dd-MM-yyyy"),
                decoration: buildInputDecoration(
                    context,
                    "What is the date of construction of the pool \nin the Council Registration",
                    "Select Date").copyWith(
                         enabledBorder: InputBorder.none,
                         focusedBorder: InputBorder.none,
                         focusedErrorBorder: InputBorder.none, 
                        ),
              ),
              sizedbox,
              Text(
                "Australian Standard/Regulation",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              CustomFormBuilderDropdown(
                style: TextStyle(
                  fontFamily: "AVENIRLTSTD",
                  fontSize: getFontSize(context,2),
                ),
                attribute: "notice_registration",
                // initialValue: 'Male',
                hint: Text(
                  'Select Regulation',
                  style: TextStyle(color: Color(0xff222222), fontSize: getFontSize(context,2)),
                ),
                validators: [FormBuilderValidators.required()],
                items: _bookingFormController.regulationdata
                    .map((item) => DropdownMenuItem(
                        value: item['regulation_id'],
                        child: Text(
                          "${item['regulation_name']}",
                          style: TextStyle(
                              fontFamily: "AVENIRLTSTD",
                              fontSize: getFontSize(context,0),
                              color: Color(0xff222222)),
                        )))
                    .toList(),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )),
        SizedBox(
          height: 20,
        ),
        Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Owner Name',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              CustomFormBuilderTextField(
                textInputAction: TextInputAction.done,
                attribute: "owner_name",
                decoration:
                    buildInputDecoration(context, "", "Enter Owner Name"),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(20),
                  CustomFormBuilderValidators.charOnly(),
                ],
              ),
              sizedbox,
              Text(
                'Owner Business Name',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              CustomFormBuilderTextField(
                textInputAction: TextInputAction.done,
                attribute: "owner_business_name",
                decoration:
                    buildInputDecoration(context, "", "Enter Business Name"),
                validators: [
                  FormBuilderValidators.required(),
                ],
              ),
              sizedbox,
              Text(
                'Owner Postal Address',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              CustomFormBuilderTextField(
                textInputAction: TextInputAction.done,
                attribute: "owner_address",
                decoration:
                    buildInputDecoration(context, "", "Enter Postal Address"),
                validators: [
                  FormBuilderValidators.required(),
                ],
              ),
              sizedbox,
              Text(
                'Inspection Address',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              CustomFormBuilderTextField(
                textInputAction: TextInputAction.done,
                attribute: "inspection_address",
                decoration: buildInputDecoration(
                    context, "", "Enter Inspection Address"),
                validators: [
                  FormBuilderValidators.required(),
                ],
              ),
              sizedbox,
              Text(
                'Contact Number',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              CustomFormBuilderTextField(
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: getFontSize(context,2),
                  fontFamily: "AVENIRLTSTD",
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                attribute: "phonenumber",
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                maxLength: 10,
                decoration: buildInputDecoration(
                    context, "Contact phone number", "Enter Contact Number"),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(10),
                  FormBuilderValidators.numeric(),
                ],
              ),
              sizedbox,
              Text(
                'Email Address',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              CustomFormBuilderTextField(
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: getFontSize(context,2),
                  fontFamily: "AVENIRLTSTD",
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                attribute: "email_owner",
                decoration: buildInputDecoration(
                    context, "Email of Owner", "Enter Email Address"),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ],
              ),
              sizedbox,
              Text(
                'State',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              FormBuilderTextField(
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: getFontSize(context,2),
                  fontFamily: "AVENIRLTSTD",
                ),
                attribute: "state",

                decoration:
                    buildInputDecoration(context, "Address", "Enter State"),
                keyboardType: TextInputType.text,
                validators: [
                  CustomFormBuilderValidators.charOnly(),
                  FormBuilderValidators.maxLength(20),
                  FormBuilderValidators.required()
                ],
              ),

              sizedbox,
              Text(
                'Postcode',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              FormBuilderTextField(
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: getFontSize(context,2),
                  fontFamily: "AVENIRLTSTD",
                ),
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                maxLength: 4,
                attribute: "postcode",
                decoration:
                    buildInputDecoration(context, "Address", "Enter Postcode"),
                keyboardType: TextInputType.number,
                validators: [
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.maxLength(4),
                  FormBuilderValidators.minLength(4),
                  FormBuilderValidators.required()
                ],
              ),
              sizedbox,
              Text(
                "Pool/Spa Type",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              CustomFormBuilderDropdown(
                style: TextStyle(
                  fontFamily: "AVENIRLTSTD",
                  fontSize: getFontSize(context,2),
                ),
                attribute: "swi_pool_spa",
                hint: Text(
                  'Select Pool/Spa Type',
                  style: TextStyle(color: Color(0xff222222), fontSize: getFontSize(context,2)),
                ),
                validators: [FormBuilderValidators.required()],
                items: ["Pool", 'Spa', "Permanent", "Relocatable"]
                    .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          "$item",
                          style: TextStyle(
                              fontFamily: "AVENIRLTSTD",
                              fontSize: getFontSize(context,0),
                              color: Color(0xff222222)),
                        )))
                    .toList(),
              ),
              sizedbox,
              Text(
                "Inspection Type",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),

              CustomFormBuilderDropdown(
                style: TextStyle(
                  fontFamily: "AVENIRLTSTD",
                  fontSize: getFontSize(context,2),
                ),
                attribute: "inspection_type",
                hint: Text(
                  'Select Inspection Type',
                  style: TextStyle(color: Color(0xff222222), fontSize: getFontSize(context,2)),
                ),
                validators: [FormBuilderValidators.required()],
                items: ["First Inspection", "Re-Inspection"]
                    .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          "$item",
                          style: TextStyle(
                              fontFamily: "AVENIRLTSTD",
                              fontSize: getFontSize(context,0),
                              color: Color(0xff222222)),
                        )))
                    .toList(),
              ),
              sizedbox,

              Text(
                "Date To Inspect",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              FormBuilderDateTimePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 0)),
                lastDate: DateTime(2100),
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: getFontSize(context,2),
                  fontFamily: "AVENIRLTSTD",
                ),
                controller: _bookingFormController.bookingDateTime,
                attribute: "booking_date_time",
                validators: [FormBuilderValidators.required()],
                inputType: InputType.date,
                format: new DateFormat("dd-MM-yyyy"),
                decoration: buildInputDecoration(
                    context,
                    "What is the requested booking date and time \nof the inspection? ",
                    "Select Date").copyWith(
                         enabledBorder: InputBorder.none,
                         focusedBorder: InputBorder.none,
                         focusedErrorBorder: InputBorder.none, 
                        ),
              ),

              sizedbox,
              Text(
                "Time to Inspect",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),
              FormBuilderDateTimePicker(
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: getFontSize(context,2),
                  fontFamily: "AVENIRLTSTD",
                ),
                controller: _bookingFormController.bookingTime,
                attribute: "booking_time",
                validators: [FormBuilderValidators.required()],
                inputType: InputType.time,
                format: new DateFormat.jm(),
                decoration: buildInputDecoration(
                    context,
                    "What is the requested booking time of the inspection? ",
                    "Select Time").copyWith(
                         enabledBorder: InputBorder.none,
                         focusedBorder: InputBorder.none,
                         focusedErrorBorder: InputBorder.none, 
                        ),
                onChanged: _onChanged,
              ),

              sizedbox,
              Text(
                "Cost",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),

              CustomFormBuilderTextField(
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: getFontSize(context,2),
                  fontFamily: "AVENIRLTSTD",
                ),
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                attribute: "inspection_fee",
                decoration: buildInputDecoration(context,
                    "What is the Fee for this inspection?", "Enter Cost"),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ],
              ),

              sizedbox,
              Text(
                "Paid/Not Paid",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "AVENIRLTSTD",
                    fontSize: getFontSize(context,0),
                    color: Color(0xff222222),
                    fontWeight: FontWeight.normal),
              ),

              CustomFormBuilderRadio(
                activeColor: Color(0xFF00A0DE),
                decoration: buildInputDecoration(context,
                    "Has the inspection fee payment been made?", "Yes/No").copyWith(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                attribute: "payment_paid",
                validators: [FormBuilderValidators.required()],
                options: ["Yes", "No"]
                    .map((lang) => FormBuilderFieldOption(value: lang))
                    .toList(growable: false),
              ),
              Visibility(
                visible: false,
                child: FormBuilderTextField(
                  attribute: "send_invoice",
                ),
              ),

              sizedbox,
              // FormBuilderCheckbox(

              //   attribute: 'accept_terms',
              //   initialValue: true,
              //   leadingInput: true,

              //   label: GestureDetector(
              //     onTap: (){
              //       Navigator.of(context).push(MaterialPageRoute(
              //           builder: (BuildContext context) => MyWebView(
              //             title:"Inspector Advice" ,
              //             selectedUrl:"https://poolinspection.beedevstaging.com/important-advice",
              //           )));

              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(2, 14,0, 0),
              //       child: Text(

              //         "I Hereby Acknowledge & Agree To Important Inspector Advice"
              //             .toUpperCase(),
              //         style: TextStyle(
              //             color: Colors.red,
              //             fontFamily:"AVENIRLTSTD",
              //             fontWeight: FontWeight.bold,
              //             fontSize: getFontSize(context,-5)),
              //       ),
              //     )
              //   ),
              //   validators: [
              //     FormBuilderValidators.requiredTrue(
              //       errorText:
              //       "You must accept Important Inspector Advice",
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20,),
            ],
          ),
        )),
        _bookingFormController.roles == 2
            ? _bookingFormController.companyinspectors.length == 0
                ? Text("No Inspectors to assign task")
                : CustomFormBuilderDropdown(
                    style: TextStyle(
                        color: Color(0xff222222),
                        fontFamily: "AVENIRLTSTD",
                        fontSize: getFontSize(context,2)),
                    attribute: "inspector_list",
                    // initialValue: 'Male',
                    hint: Text('Select Inspectors'),
                    validators: [FormBuilderValidators.required()],
                    items: _bookingFormController.companyinspectors
                        .map((item) =>
                            DropdownMenuItem(value: item, child: Text("$item")))
                        .toList(),
                  )
            : _bookingFormController.roles == 1
                ? CustomFormBuilderDropdown(
                    style: TextStyle(
                        color: Color(0xff222222),
                        fontFamily: "AVENIRLTSTD",
                        fontSize: getFontSize(context,2)),
                    attribute: "inspector_list",
                    hint: Text('Select Inspectors'),
                    validators: [FormBuilderValidators.required()],
                    items: _bookingFormController.companyinspectors
                        .map((item) =>
                            DropdownMenuItem(value: item, child: Text("$item")))
                        .toList(),
                  )
                : Container(),
        sizedbox,
      ],
    );
  }
}
