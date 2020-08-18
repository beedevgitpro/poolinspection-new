import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/constants/validators.dart';
import 'package:poolinspection/src/controllers/bookingform_controller.dart';
import 'package:poolinspection/src/elements/drawer.dart';
import 'package:poolinspection/src/elements/dropdown.dart';
import 'package:poolinspection/src/elements/inputdecoration.dart';
import 'package:poolinspection/src/elements/radiobutton.dart';
import 'package:poolinspection/src/elements/textfield.dart';
import 'package:poolinspection/src/pages/home/MyWebView.dart';
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;
import 'package:poolinspection/config/app_config.dart' as config;

class BookingFormWidget extends StatefulWidget {
  @override
  _BookingFormWidgetState createState() => _BookingFormWidgetState();
}

class _BookingFormWidgetState extends StateMVC<BookingFormWidget> {
  BookingFormController _bookingFormController;

  _BookingFormWidgetState() : super(BookingFormController()) {
    _bookingFormController = controller;
  }
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(); 
  final ownerAddressNode=FocusNode();
  final councilNameNode=FocusNode();
  final postcodeNode=FocusNode();
  final businessNameNode=FocusNode();
  final inspectionAddressNode=FocusNode();
  final contactNumberNode=FocusNode();
  final emailNode=FocusNode();
  final stateNode=FocusNode();
  var data;
  bool autoValidate = false;
  bool readOnly = false;
  bool isChecked = false;
  bool isChecked1 = false;

  ValueChanged _onChanged = (val) => print(val);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, 
      // endDrawer: drawerData(context, userRepo.user.rolesManage),
      backgroundColor: config.Colors().scaffoldColor(1),
      appBar: AppBar(
        title: Text("Book Inspection",
            style: TextStyle(
                fontFamily: "AVENIRLTSTD",
                // fontSize: getFontSize(context,-3),
                color: Color(0xff222222),
                fontWeight: FontWeight.normal)),
        centerTitle: true,
        leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).accentColor),
              onPressed: () => Navigator.pop(context)),
      
        actions: <Widget>[
          Image.asset(
          "assets/img/app-iconwhite.jpg",
          // fit: BoxFit.cover,
          fit: BoxFit.fitWidth,
        ),
        ],
      ),
      body: GestureDetector(
        onPanDown: (_){
          FocusScope.of(context).requestFocus(FocusNode());
        },
              child: Padding(
          padding: EdgeInsets.all(10),
          child:
                SingleChildScrollView(
                  child: Column(
                    children: [
                      bookingForm(context),
                      Align(
                 alignment: Alignment.center,
                 child:  Row(

                   children: <Widget>[
                     Expanded(flex:1,child:Container(

                       alignment: Alignment.bottomCenter,
                       child: Container(

                         child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width/2.5,
                             child:Padding(
                               padding: EdgeInsets.all(10.0),
                               child:  Text(
                                 "Submit",
                                 style: TextStyle(color: Theme.of(context).primaryColor,fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,0)),
                               ),
                             ),
                             color: Theme.of(context).accentColor,
                             onPressed: () {
                               _bookingFormController.bookingFormKey.currentState.initialValue['send_invoice']="0";
                              //  print("qwersend_invoice"+_con.bookingFormKey.currentState.value['send_invoice'].toString());

                               _bookingFormController.sendEnquiry(context);
                             }
                         ),
                       ),
                     ),),
                     Expanded(flex:1,child:Container(

                       alignment: Alignment.bottomCenter,
                       child:Container(

                           child: MaterialButton(
                               minWidth: MediaQuery.of(context).size.width/2.5,
                               child: Padding(
                                 padding: EdgeInsets.all(10.0),
                                 child:Text(
                                   "Send Invoice",
                                   style: TextStyle(color: Theme.of(context).primaryColor,fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,0)),
                                 ),
                               ),
                               color: Theme.of(context).accentColor,
                               onPressed: () {
                                 _bookingFormController.bookingFormKey.currentState.initialValue['send_invoice']="1";

                                 _bookingFormController.sendEnquiry(context);
                               }
                           )
                       ),
                     ),),
                   ],

                 ),
               )
                    ],
                  ),
                ),
               
           

          ),
      )

    );
  }

  FormBuilder bookingForm(BuildContext context) {
    print(_bookingFormController.roles);
    return FormBuilder(
      key: _bookingFormController.bookingFormKey,
      readOnly: readOnly,
      initialValue: {
        "send_invoice":"0",
        "inspector_list": userRepo.inspector.id,
        "notice_regis": "Yes",

//           "permnt_relocate": "Permanent",
//           "certificateofnoncomplianceissued": "No",
//           "poolfoundnoncompliant": "No",
//           "payment_paid": "No",
//           "inspection_fee": "10",
//           // "notice_registration": "",
//           // "company_list": "5",
//           "Council_due_date": DateTime.now(),
//           "booking_date_time": DateTime.now(),
//            "booking_time":DateTime.now(),
//           "council_regis_date": DateTime.now(),
//           "street_road": "543 delhi",
//           "postcode": "1231",
//           "city_suburb": "Mumbai",
//           "municipal_district": "Thane"
      },
      autovalidate: autoValidate,
      child:Padding(

        padding: const EdgeInsets.all(0),
        child: listView(context),
      ));

  }

  Column listView(BuildContext context) {
    final sizedbox =
        SizedBox(height: config.App(context).appVerticalPadding(2));
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
    Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child:Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          sizedbox,
          Text( "Relevant Council",textAlign: TextAlign.left,style: TextStyle(
              fontFamily: "AVENIRLTSTD",
              fontSize: getFontSize(context,0),
              color: Color(0xff222222),
              fontWeight: FontWeight.normal),),

          CustomFormBuilderTextField(
            style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),fontFamily: "AVENIRLTSTD",),
            textInputAction: TextInputAction.next,
            attribute: "name_relevant_council",
            decoration: buildInputDecoration(
                context,
                "The name of the relevant Council that issued \nthe Notice of Registration",
                "Enter Council's Name"),
            keyboardType: TextInputType.text,
            validators: [
              
              FormBuilderValidators.max(20),
              CustomFormBuilderValidators.charOnly(),
              FormBuilderValidators.required()
            ],
          ),

          sizedbox,
          Text( "Date Of Construction of Pool/Spa",textAlign: TextAlign.left,style: TextStyle(
              fontFamily: "AVENIRLTSTD",
              fontSize: getFontSize(context,0),
              color: Color(0xff222222),
              fontWeight: FontWeight.normal),),
              SizedBox(height:3),
          FormBuilderDateTimePicker(
            style: TextStyle(color: Color(0xff222222),fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,2)),
            controller: _bookingFormController.councilRegisDate,
            attribute: "council_regis_date",
            inputType: InputType.date,
            validators: [FormBuilderValidators.required()],
            format:new DateFormat("dd-MM-yyyy"),
            decoration: buildInputDecoration(
                context,
                "What is the date of construction of the pool \nin the Council Registration",
                "Select Date").copyWith(
                  hintStyle: TextStyle(color:Theme.of(context).accentColor),
                         enabledBorder: InputBorder.none,
                         focusedBorder: InputBorder.none,
                         focusedErrorBorder: InputBorder.none, 
                        ),
          ),

          sizedbox,
          Text( "Australian Standard/Regulation",textAlign: TextAlign.left,style: TextStyle(
              fontFamily: "AVENIRLTSTD",
              fontSize: getFontSize(context,0),
              color: Color(0xff222222),
              fontWeight: FontWeight.normal),),
          CustomFormBuilderDropdown(
            style: TextStyle(     fontFamily: "AVENIRLTSTD",
              fontSize: getFontSize(context,2),),
            attribute: "notice_registration",
            // initialValue: 'Male',
            hint: Text('Select Regulation',style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2)),),
            validators: [FormBuilderValidators.required()],
            items: _bookingFormController.regulationdata
                .map((item) => DropdownMenuItem(
                value: item['regulation_id'],
                child: Text("${item['regulation_name']}",style: TextStyle(fontFamily: "AVENIRLTSTD",  fontSize: getFontSize(context,0),color: Color(0xff222222)),)))
                .toList(),
          ),
          SizedBox(height: 20,),
        ],
      ),
    )

    ),
        SizedBox(height: 20,),
        Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Owner Name',textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                  CustomFormBuilderTextField(
                    onFieldSubmitted: (value){
                      businessNameNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                    attribute: "owner_name",
                    decoration: buildInputDecoration(context, "", "Enter Owner Name"),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.maxLength(20),
                      CustomFormBuilderValidators.charOnly(),
                    ],
                  ),
                  sizedbox,
                  Text('Owner Business Name',textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                  CustomFormBuilderTextField(
                    focusNode: businessNameNode,
                    onFieldSubmitted: (value){
                      ownerAddressNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                    attribute: "owner_business_name",
                    decoration: buildInputDecoration(context, "", "Enter Business Name"),
                    validators: [
                      FormBuilderValidators.required(),
                      // FormBuilderValidators.maxLength(20),
                      // CustomFormBuilderValidators.charOnly(),
                    ],
                  ),
                  sizedbox,
                  Text('Owner Postal Address',textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                  CustomFormBuilderTextField(
                    onFieldSubmitted: (value){
                      inspectionAddressNode.requestFocus();
                    },
                    focusNode: ownerAddressNode,
                    textInputAction: TextInputAction.next,
                    attribute: "owner_address",
                    decoration: buildInputDecoration(context, "", "Enter Postal Address"),
                    validators: [
                      FormBuilderValidators.required(),
                      
                    ],
                  ),
                  sizedbox,
                  Text('Inspection Address',textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                  CustomFormBuilderTextField(
                    onFieldSubmitted: (value){
                      contactNumberNode.requestFocus();
                    },
                    focusNode: inspectionAddressNode,
                    textInputAction: TextInputAction.next,
                    attribute: "inspection_address",
                    decoration: buildInputDecoration(context, "", "Enter Inspection Address"),
                    validators: [
                      FormBuilderValidators.required(),
                      // FormBuilderValidators.maxLength(20),
                      // CustomFormBuilderValidators.charOnly(),
                    ],
                  ),
                  sizedbox,
                  Text('Contact Number',textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                  CustomFormBuilderTextField(
                    focusNode: contactNumberNode,
                    onFieldSubmitted: (value){
                      emailNode.requestFocus();
                    },
                    style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),fontFamily: "AVENIRLTSTD",),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
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
                  Text('Email Address',textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                  CustomFormBuilderTextField(
                    onFieldSubmitted: (value){
                      stateNode.requestFocus();
                    },
                    focusNode: emailNode,
                    style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),fontFamily: "AVENIRLTSTD",),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    attribute: "email_owner",
                    decoration: buildInputDecoration(
                        context, "Email of Owner", "Enter Email Address"),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ],
                  ),
                  sizedbox,
                  Text('State',textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                  FormBuilderTextField(
                    onFieldSubmitted: (value){
                      postcodeNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),fontFamily: "AVENIRLTSTD",),
                    attribute: "state",
                    focusNode: stateNode,
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
                  Text('Postcode',textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                  FormBuilderTextField(
                    focusNode: postcodeNode,
                    style: TextStyle(color:Color(0xff222222),fontSize: getFontSize(context,2),fontFamily: "AVENIRLTSTD",),
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
                  

                  Text( "Pool/Spa Type",textAlign: TextAlign.left,style: TextStyle(
              fontFamily: "AVENIRLTSTD",
              fontSize: getFontSize(context,0),
              color: Color(0xff222222),
              fontWeight: FontWeight.normal),),
          CustomFormBuilderDropdown(
            style: TextStyle(     fontFamily: "AVENIRLTSTD",
              fontSize: getFontSize(context,2),),
            attribute: "swi_pool_spa",
            hint: Text('Select Pool/Spa Type',style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2)),),
            validators: [FormBuilderValidators.required()],
            items: ["Pool",'Spa',"Permanent", "Relocatable"]
                .map((item) => DropdownMenuItem(
                value: item,
                child: Text("$item",style: TextStyle(fontFamily: "AVENIRLTSTD",  fontSize: getFontSize(context,0),color: Color(0xff222222)),)))
                .toList(),
          ),
                  sizedbox,
                 

                  
                 


                  Text("Inspection Type",textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),

                  CustomFormBuilderDropdown(
            style: TextStyle(     fontFamily: "AVENIRLTSTD",
              fontSize: getFontSize(context,2),),
            attribute: "inspection_type",
            hint: Text('Select Inspection Type',style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2)),),
            validators: [FormBuilderValidators.required()],
            items: ["First Inspection", "Re-Inspection"]
                .map((item) => DropdownMenuItem(
                value: item,
                child: Text("$item",style: TextStyle(fontFamily: "AVENIRLTSTD",  fontSize: getFontSize(context,0),color: Color(0xff222222)),)))
                .toList(),
          ),
                  sizedbox,
                 

                  Text("Date To Inspect",textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
SizedBox(height:3),
                  FormBuilderDateTimePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 0)),
                    lastDate: DateTime(2100),
                    style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),fontFamily: "AVENIRLTSTD",),
                    controller: _bookingFormController.bookingDateTime,
                    attribute: "booking_date_time",
                    validators: [FormBuilderValidators.required()],
                    inputType: InputType.date,
                    format:new DateFormat("dd-MM-yyyy"),
                    
                     decoration: buildInputDecoration(
                        context,
                        "What is the requested booking date and time \nof the inspection? ",
                        "Select Date").copyWith(
                          hintStyle: TextStyle(color:Theme.of(context).accentColor),
                         enabledBorder: InputBorder.none,
                         focusedBorder: InputBorder.none,
                         focusedErrorBorder: InputBorder.none, 
                        ),
                  ),

                  sizedbox,
                  Text("Time to Inspect",textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                      SizedBox(height:3),
                  FormBuilderDateTimePicker(

                    style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),fontFamily: "AVENIRLTSTD",),
                    controller: _bookingFormController.bookingTime,

                    attribute: "booking_time",
                    validators: [FormBuilderValidators.required()],
                    inputType: InputType.time,
                    format: new DateFormat.jm(),
                   decoration: buildInputDecoration(
                        context,
                        "What is the requested booking time of the inspection? ",
                        "Select Time").copyWith(
                          hintStyle: TextStyle(color:Theme.of(context).accentColor),
                         enabledBorder: InputBorder.none,
                         focusedBorder: InputBorder.none,
                         focusedErrorBorder: InputBorder.none, 
                        ),
                    onChanged: _onChanged,
                  ),


                  sizedbox,
                  Text("Cost",textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),

                  CustomFormBuilderTextField(
                    
                    style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),fontFamily: "AVENIRLTSTD",),
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
                  Text("Paid/Not Paid",textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),

                  CustomFormBuilderRadio(
                    
                    activeColor: Color(0xff222222),
                    decoration: buildInputDecoration(context,
                        "Has the inspection fee payment been made?", "yes or no").copyWith(
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
                  child:FormBuilderTextField(
                    attribute: "send_invoice",
                  ),
                ),

                  
                  FormBuilderCheckbox(
                    decoration: InputDecoration(enabledBorder: InputBorder.none,
                         focusedBorder: InputBorder.none,
                         focusedErrorBorder: InputBorder.none, ),
                    attribute: 'accept_terms',
                    initialValue: true,
                    leadingInput: true,

                    label: RichText(
  text: TextSpan(
    text: "I have read and agree to the ",
    style: TextStyle(
              color: Colors.black,
              fontFamily:"AVENIRLTSTD",
              fontWeight: FontWeight.bold,
              fontSize: getFontSize(context,1)),
    children: <TextSpan>[
      TextSpan(
        recognizer:TapGestureRecognizer()..onTap=(){
          Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => MyWebView(
                  title:"Terms And Conditions" ,
                  selectedUrl:"https://poolinspection.beedevstaging.com/terms-condition",
                )));
        },
        text: 'Terms & Conditions', style: TextStyle(
              color: Theme.of(context).accentColor,
              fontFamily:"AVENIRLTSTD",
              fontWeight: FontWeight.bold,
              fontSize: getFontSize(context,1))),
    ],
  ),
),
                    validators: [
                      FormBuilderValidators.requiredTrue(
                        errorText:
                        "You must accept Important Inspector Advice",
                      ),
                    ],
                  ),
                  

                ],
              ),
            )

        ),





        _bookingFormController.roles == 2
            ? _bookingFormController.companyinspectors.length == 0
                ? Text("No Inspectors to assign task")
                : CustomFormBuilderDropdown(
          style: TextStyle(color:Color(0xff222222), fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,2)),
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
          style: TextStyle(color:Color(0xff222222), fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,2)),
                    attribute: "inspector_list",
                    // initialValue: 'Male',
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

  Container initial() {
    return Container(
      color: Colors.red,
    );
  }

  Container next() {
    return Container(
      color: Colors.blue,
    );
  }
}

