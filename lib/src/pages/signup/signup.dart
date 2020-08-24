import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/constants/validators.dart';
import 'package:poolinspection/src/controllers/user_controller.dart';
import 'package:poolinspection/src/elements/BlockButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/elements/inputdecoration.dart';
import 'package:poolinspection/src/elements/radiobutton.dart';
import 'package:poolinspection/src/elements/textlabel.dart';
import 'package:poolinspection/src/models/signupfields.dart';
import 'package:poolinspection/src/pages/home/MyWebView.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  final fNameNode=FocusNode();
  final lNameNode=FocusNode();
  final abnNumberNode=FocusNode();
  final streetNode=FocusNode();
  final cityNode=FocusNode();
  final postcodeNode=FocusNode();
  final phoneNumberNode=FocusNode();
  final emailNode=FocusNode();
  final passwordNode=FocusNode();
  final cPasswordNode=FocusNode();
  final vbaNode=FocusNode();
  final uploadTextStyle = TextStyle(color: Colors.blueGrey);
  UserController _userController;
  _SignUpWidgetState() : super(UserController()) {
    _userController = controller;
  }
  bool _isConnected=true;
  var subscription;
  @override
  void initState() {
    super.initState();
     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        if (result == ConnectivityResult.none)_isConnected=false;
    else _isConnected=true;
       });
       print(_isConnected);
  });
  }
  @override
  void dispose() {
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            key: _userController.scaffoldKey,
            resizeToAvoidBottomPadding: true,
            body: GestureDetector(
              onPanDown: (_){
          FocusScope.of(context).requestFocus(FocusNode());
        },
                          child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildListInspectorView(context),
              ),
            ));
  }
  List<bool> accountFilterSelected=[true,false];
  Widget accountFilter(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      return ToggleButtons(
        constraints: BoxConstraints.expand(width:(MediaQuery.of(context).size.width-20) / 2),
      selectedColor: Colors.white,
      fillColor: Theme.of(context).accentColor,
      isSelected: accountFilterSelected,
      onPressed:(index){
         _userController.groupValue = index;
        accountFilterSelected[index]=true;
        if(index==0){
          accountFilterSelected[1]=false;
        }
        else{
          accountFilterSelected[0]=false;
        }
        _userController.signUpKey.currentState.reset();
        setState(() { });
      } ,
      children: <Widget>[
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
            "Individual",
            style: TextStyle(fontSize: getFontSize(context,0),
              fontFamily: "AVENIRLTSTD",),
          ),
    ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Company", style: TextStyle(fontSize: getFontSize(context,0),
            fontFamily: "AVENIRLTSTD",)),
        ),
  ]
    );
    });
  }

  FormBuilder buildListInspectorView(BuildContext context) {
    final sizedBox =
        SizedBox(height: config.App(context).appVerticalPadding(2));
    return FormBuilder(
      key: _userController.signUpKey,
      // initialValue: {
      // 'inspector_abn': "12312312312",
      // 'inspector_address': "32, b patel shopping centre",
      // 'first_name': "Sumit",
      // 'company_name': "Beedev",
      // 'last_name': "Sumit",
      // 'email': 'royal@gmail.com',
      // "mobile_no": "4182475355",
      // "registration_number": "4182475355",
      // 'username': "sumeet221",
      // 'password': 'Eruasion1!',
      // 'password_confirmation': "Eruasion1!",
      // 'card_number': "8523697412561111",
      // 'card_cvv': '856',
      // 'card_expiry_month': "12",
      // 'card_expiry_year': "2034",
      // "company_abn": "12312312312",
      // "company_address": "32, b patel shopping centre",
      // "company_logo": "34",
      // "card_type": "1",
      // "Street":"street",
      // "Postcode":"1231",
      // "City":"Mumbai",
      // "District":"Thane"
      // },
      autovalidate: _userController.autoValidate,
      child: SafeArea(
              child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: config.App(context).appHeight(20),
                  child: Image.asset("assets/img/logo.png"),
                ),
                Text(
                  "Register",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: getFontSize(context,14), fontWeight: FontWeight.w500,
                    fontFamily: "AVENIRLTSTD",)
                      .merge(TextStyle(
                          color: Color(0xff222222), fontWeight: FontWeight.w700)),
                ),
                SizedBox(
                  height: 10,
                ),
                accountFilter(context),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child:Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                _userController.groupValue == 1 ? sizedBox : Container(),
                _userController.groupValue == 1 ? textLabel("Company Name",context) : Container(),

                _userController.groupValue == 1
                    ? FormBuilderTextField(
                      onFieldSubmitted: (value){
                        abnNumberNode.requestFocus();
                      },
                  style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),fontFamily: "AVENIRLTSTD",),
                        attribute: "company_name",
                        decoration: buildInputDecoration(
                            context, "Company Name", "Enter Company Name"),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validators: [
                          CustomFormBuilderValidators.charOnly(),
                          FormBuilderValidators.minLength(3),
                          FormBuilderValidators.maxLength(20),
                          FormBuilderValidators.required()
                        ],
                      )
                    : Container(),
                sizedBox,


                _userController.groupValue == 0 ? textLabel("First Name",context) : Container(),
                _userController.groupValue == 0
                    ? FormBuilderTextField(
                      focusNode: fNameNode,
                  style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",),
                        attribute: "first_name",
                        decoration: buildInputDecoration(
                            context, "First Name", "Enter First Name"),
                            onFieldSubmitted: (value){
                              lNameNode.requestFocus();
                            },
                            textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        validators: [
                          FormBuilderValidators.min(3),
                          CustomFormBuilderValidators.charOnly(),
                          FormBuilderValidators.maxLength(20),
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(3),
                        ],
                      )
                    : Container(),
                _userController.groupValue == 0 ? sizedBox : Container(),
                _userController.groupValue == 0 ? textLabel("Last Name",context) : Container(),
                _userController.groupValue == 0
                    ? FormBuilderTextField(
                      focusNode: lNameNode,
                      onFieldSubmitted: (value){
                              abnNumberNode.requestFocus();
                            },
                  style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",),
                        attribute: "last_name",
                        textInputAction: TextInputAction.next,
                        decoration: buildInputDecoration(
                            context, "Last Name", "Enter Last Name"),
                        keyboardType: TextInputType.text,
                        validators: [
                          CustomFormBuilderValidators.charOnly(),
                          FormBuilderValidators.minLength(3),
                          FormBuilderValidators.maxLength(20),
                          FormBuilderValidators.required()
                        ],
                      )
                    : Container(),
                _userController.groupValue == 0 ? sizedBox : Container(),
                _userController.groupValue == 0 ? textLabel("ABN Number",context) : Container(),

                _userController.groupValue == 0
                    ? FormBuilderTextField(
                      focusNode: abnNumberNode,
                      
                  style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",),
                        attribute: "inspector_abn",
                        maxLength: 11,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: buildInputDecoration(
                            context, "ABN Number I", "Enter ABN Number"),
                        keyboardType: TextInputType.number,
                        validators: [
                          FormBuilderValidators.maxLength(11),
                          FormBuilderValidators.minLength(11),
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.required()
                        ],
                      )
                    : Container(),
                _userController.groupValue == 0 ? sizedBox : Container(),
                _userController.groupValue == 1 ? textLabel("ABN Number ",context) : Container(),
                _userController.groupValue == 1
                    ? FormBuilderTextField(
                      focusNode: abnNumberNode,
                  style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",),
                        maxLength: 11,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        attribute: "company_abn",
                        decoration: buildInputDecoration(
                            context, "ABN Number C", "Enter ABN Number"),
                        keyboardType: TextInputType.number,
                        validators: [
                          FormBuilderValidators.maxLength(11),
                          FormBuilderValidators.minLength(11),
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.required()
                        ],
                      )
                    : Container(),
                SizedBox(height: 7,),
                          Text("Is the GST Number Applicable?",textAlign: TextAlign.left,  style: TextStyle(
                              fontFamily: "AVENIRLTSTD",
                              fontSize: getFontSize(context,1),
                              color: Color(0xff222222),
                              fontWeight: FontWeight.bold),),
                              
                CustomFormBuilderRadio(
                  activeColor: Theme.of(context).accentColor,
                  decoration: buildInputDecoration(context,
                      "Is the GST Number Applicable?", "yes or no",).copyWith(
                       enabledBorder: InputBorder.none,
                       disabledBorder: InputBorder.none,
                       errorBorder: InputBorder.none 
                      ),
                  attribute: "tax_applicable",
                  validators: [FormBuilderValidators.required()],
                  options: ["Yes", "No"]
                      .map((choice) => FormBuilderFieldOption(value: choice))
                      .toList(growable: false),
                ),
                sizedBox,
                _userController.groupValue == 1
                    ? _userController.photoImage == null
                        ? ListTile(

                            title:
                                Text('No Logo selected.', style: uploadTextStyle),
                            trailing: Container(
                              padding: EdgeInsets.all(5),
                              child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                onPressed: () =>
                                    getImage(_userController.photoImage).then((val) {
                                  setState(() {
                                    _userController.photoImage = val;

                                  });
                                }),
                                child: Text("Select File",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          )
                        : ListTile(
                            leading: Image.file(_userController.photoImage),
                            title: Text(
                              'Logo selected',
                              style: uploadTextStyle,
                            ),
                            trailing: Container(
                              padding: EdgeInsets.all(5),
                              child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                onPressed: () =>
                                    getImage(_userController.photoImage).then((val) {
                                  setState(() {
                                    _userController.photoImage = val;

                                  });
                                }),
                                child: Text("Change File",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          )
                    : Container(),
                _userController.groupValue == 0
                    ? _userController.photoImage == null
                        ? ListTile(
                            title:
                                Text('No Logo selected.', style: uploadTextStyle),
                            trailing: Container(
                              padding: EdgeInsets.all(5),
                              child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                onPressed: () =>
                                    getImage(_userController.photoImage).then((val) {
                                  setState(() {
                                    _userController.photoImage = val;
                                  });
                                }),
                                child: Text("Select Image",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          )
                        : ListTile(
                            leading: Image.file(_userController.photoImage),
                            title: Text(
                              '',
                              style: uploadTextStyle,
                            ),
                            trailing: Container(
                              padding: EdgeInsets.all(5),
                              child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                onPressed: () =>
                                    getImage(_userController.photoImage).then((val) {
                                  setState(() {
                                    _userController.photoImage = val;
                                  });
                                }),
                                child: Text("Change Image",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          )
                    : Container(),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text("Image Dimensions should be 150*150",style: TextStyle(color:Color(0xff222222),fontSize: getFontSize(context,-4), fontFamily: "AVENIRLTSTD"),),
                    
                ),

  ]
    ),
    ),
    ),







                sizedBox,

    Card(
    child: Padding(
    padding: const EdgeInsets.all(10.0),
    child:Column(

    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
                textLabel("Street",context),
                FormBuilderTextField(
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value){
                    cityNode.requestFocus();
                  },
                  style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",),
                  attribute: "Street",
                  decoration:
                      buildInputDecoration(context, "Address", "Enter Street"),
                  keyboardType: TextInputType.text,
                  validators: [
                    FormBuilderValidators.maxLength(50),
                    FormBuilderValidators.required()
                  ],
                ),
                sizedBox,
                textLabel("City",context),

                FormBuilderTextField(
                  focusNode: cityNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value){
                    postcodeNode.requestFocus();
                  },
                  style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",),
                  attribute: "City",
                  decoration:
                      buildInputDecoration(context, "Address", "Enter City"),
                  keyboardType: TextInputType.text,
                  validators: [
                    CustomFormBuilderValidators.addressOnly(),
                    FormBuilderValidators.maxLength(20),
                    FormBuilderValidators.required()
                  ],
                ),
                sizedBox,
                textLabel("Postcode",context),

                FormBuilderTextField(
                  focusNode: postcodeNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value){
                    phoneNumberNode.requestFocus();
                  },
                  style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  maxLength: 4,
                  attribute: "Postcode",
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
                sizedBox,
                textLabel("Phone Number",context),
                FormBuilderTextField(
                  focusNode: phoneNumberNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value){
                    emailNode.requestFocus();
                  },
                  style: TextStyle(color: Color(0xff222222),
                    fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",),
                  attribute: "mobile_no",
                  maxLength: 10,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  decoration: buildInputDecoration(
                      context, "Phone Number", "Enter Phone Number"),
                  keyboardType: TextInputType.number,
                  validators: [
                    FormBuilderValidators.numeric(),
                    FormBuilderValidators.minLength(10),
                    FormBuilderValidators.required()
                  ],
                ),



              sizedBox,


                textLabel("Email Address",context),
                FormBuilderTextField(
                                    textInputAction: TextInputAction.next,

                  focusNode: emailNode,
                  onFieldSubmitted: (value){
                    passwordNode.requestFocus();
                  },
                  style: TextStyle(color: Color(0xff222222),
                    fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",),
                  attribute: "email",
                  decoration: buildInputDecoration(
                      context, "Email Address", "Enter Email Address"),
                  keyboardType: TextInputType.emailAddress,
                  validators: [
                    FormBuilderValidators.email(),
                    FormBuilderValidators.required()
                  ],
                ),

                sizedBox,
                textLabel("Password",context),
                FormBuilderTextField(
                                    textInputAction: TextInputAction.next,

                  onFieldSubmitted: (value){
                    cPasswordNode.requestFocus();
                  },
                  focusNode: passwordNode,
                  style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",),
                  attribute: "password",
                  decoration:
                  buildInputDecoration(context, "Password", "Enter Password"),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.maxLength(12),
                    CustomFormBuilderValidators.strongPassCheck(),
                    FormBuilderValidators.required()
                  ],
                ),
                SizedBox(height: 2,),
                Align(
                  alignment: Alignment.topLeft,
                  child:
                  Text("Note: Strong Password is Required",style: TextStyle(color:Color(0xff222222),fontSize: getFontSize(context,-4), fontFamily: "AVENIRLTSTD"),),),

                sizedBox,
                sizedBox,
                textLabel("Confirm Password",context),
                FormBuilderTextField(
                                    textInputAction: TextInputAction.next,

                  focusNode: cPasswordNode,
                  onFieldSubmitted: (value){
                    vbaNode.requestFocus();
                  },
                  style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",),
                  attribute: "password_confirmation",
                  decoration: buildInputDecoration(
                      context, "Confirm Password", "Enter Confirm Password"),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  maxLines: 1,
                  validators: [
                    CustomFormBuilderValidators.strongPassCheck(),
                    FormBuilderValidators.maxLength(12),
                    FormBuilderValidators.required()
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
          
                sizedBox,
                textLabel(" VBA Practitioner Number",context),
                FormBuilderTextField(
                  focusNode: vbaNode,
                  style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",),
                  maxLength: 10,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  attribute: "registration_number",
                  decoration: buildInputDecoration(context, "Practitioner Number",
                      "Enter Practitioner Number"),
                  keyboardType: TextInputType.number,
                  validators: [
                    CustomFormBuilderValidators.regNumber(),
                    FormBuilderValidators.required(),
                    FormBuilderValidators.maxLength(12),
                  ],
                ),
             
        FormBuilderCheckbox(
          decoration: InputDecoration(
           border: InputBorder.none,
           enabledBorder:InputBorder.none,
           errorBorder: InputBorder.none,
           focusedBorder: InputBorder.none  
          ),
          attribute: 'accept_terms',
          initialValue: false,
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
                  selectedUrl:"https://pia.bdstaging.com.au/terms-condition",
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
              "Please Accept Terms & Conditions to continue",
            ),
          ],
        ),
             ],
    ),),
    ),

                sizedBox,



                SizedBox(
                  height: 20,
                ),
                 SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: BlockButtonWidget(
                            text: Text(
                              "Register",
                              style: TextStyle(
                                 fontSize: getFontSize(context,2),
                                  fontFamily:"AVENIRLTSTD",
                                  color: Theme.of(context).primaryColor),
                            ),
                            color: Theme.of(context).accentColor,
                            onPressed: ()
                            {
                              if(_isConnected) 
                              _userController.groupValue.toString()=="0" ?_userController.register(context, false):_userController.register(context, true);
                              else
                               Flushbar(
                      title: "Device Offline",
                      message: "Not Connected to the Internet",
                        duration: Duration(seconds: 3),
                      )..show(context);
                            }
                            )),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Have an Account?',style: TextStyle(color:Colors.black,fontSize: getFontSize(context,0),
                          fontFamily:"AVENIRLTSTD",),),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                                                    child: Text(' Login',style: TextStyle(color:Theme.of(context).accentColor,fontSize: getFontSize(context,0),
                            fontFamily:"AVENIRLTSTD",),),
                          ),
                      ],
                    ),
                ),
                
              ],
            ),
          ),
      ),

    );
  }
  Future getImage(File photoImage) async {
    final picker = ImagePicker();
    final image = await picker.getImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            activeControlsWidgetColor: Theme.of(context).accentColor,
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).accentColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    return croppedFile;
  }
  SignUpUser fields = new SignUpUser();
}