import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/user_controller.dart';
import 'package:poolinspection/src/elements/BlockButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/elements/inputdecoration.dart';
import 'package:poolinspection/src/elements/textlabel.dart';
import 'package:poolinspection/src/models/signupfields.dart';

class AddInspectorWidget extends StatefulWidget {
  @override
  _AddInspectorWidgetState createState() => _AddInspectorWidgetState();
}

class _AddInspectorWidgetState extends StateMVC<AddInspectorWidget> {
  final uploadTextStyle = TextStyle(color: Colors.blueGrey);
  UserController _userController;
  _AddInspectorWidgetState() : super(UserController()) {
    _userController = controller;
  }
  Future getImage(File photoImage) async {
    final picker=ImagePicker();
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    return File(image.path);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            key: _userController.scaffoldKey,
            resizeToAvoidBottomPadding: true,
            body: buildListInspectorView(context)));
  }

  FormBuilder buildListInspectorView(BuildContext context) {
    final sizedbox =
        SizedBox(height: config.App(context).appVerticalPadding(2));
    return FormBuilder(
      key: _userController.signUpKey,
      initialValue: {
        // 'inspector_abn': "123123123123",
        // 'inspector_address': "32, b patel shopping centre",
        // 'first_name': "Sumit",
        // 'company_name': "Beedev",
        // 'last_name': "Sumit",
        // 'email': 'johndoe@gmail.com',
        // "mobile_no": "41824753556",
        // "registration_number": "418247535561",
        // 'username': "sumeet221",
        // 'password': 'password',
        // 'password_confirmation': "password",
        // 'card_number': "8523697412561111",
        // 'card_cvv': '856',
        // 'card_expiry_month': "12",
        // 'card_cvv': '856',
        // 'card_expiry_year': "34",
        // "company_abn": "123123123123",
        // "company_address": "32, b patel shopping centre",
        // "company_logo": "34",
        // "card_type": "1",
      },
      autovalidate: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            // physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Text(
                "Add Inspector",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: getFontSize(context,14), fontWeight: FontWeight.w500)
                    .merge(TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700)),
              ),
              SizedBox(
                height: 10,
              ),
              sizedbox,
              _userController.groupValue == 0 ? textLabel("First Name",context) : Container(),
              _userController.groupValue == 0
                  ? FormBuilderTextField(
                      attribute: "first_name",
                      decoration:
                          buildInputDecoration(context, "First Name", "john"),
                      keyboardType: TextInputType.text,
                      validators: [
                        // FormBuilderValidators.min(3),
                        // FormBuilderValidators.max(70),
                        FormBuilderValidators.required()
                      ],
                    )
                  : Container(),
              sizedbox,
              _userController.groupValue == 0 ? textLabel("Last Name",context) : Container(),
              _userController.groupValue == 0
                  ? FormBuilderTextField(
                      attribute: "last_name",
                      decoration:
                          buildInputDecoration(context, "Last Name", "doe"),
                      keyboardType: TextInputType.text,
                      validators: [
                        // FormBuilderValidators.min(3),
                        // FormBuilderValidators.max(70),
                        FormBuilderValidators.required()
                      ],
                    )
                  : Container(),
              sizedbox,
              _userController.groupValue == 0 ? textLabel("ABN Number",context) : Container(),

              _userController.groupValue == 0
                  ? FormBuilderTextField(
                      attribute: "inspector_abn",
                      decoration: buildInputDecoration(
                          context, "ABN Number I", "41 824 753 556"),
                      keyboardType: TextInputType.number,
                      validators: [
                        // FormBuilderValidators.min(3),
                        // FormBuilderValidators.max(70),
                        FormBuilderValidators.required()
                      ],
                    )
                  : Container(),
              sizedbox,
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
                              child: Text("Select File",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
                      : ListTile(
                          leading: Image.file(_userController.photoImage),
                          title: Text(
                            ' Photo selected',
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
              sizedbox,
              textLabel("Address",context),
              _userController.groupValue == 0
                  ? FormBuilderTextField(
                      maxLines: 3,
                      attribute: "inspector_address",
                      decoration: buildInputDecoration(context, "Address",
                          "Suite 2, 6/10-12 Wingate Rd Mulgrave NSW 2756 Australia"),
                      keyboardType: TextInputType.text,
                      validators: [
                        // FormBuilderValidators.min(3),
                        // FormBuilderValidators.max(70),
                        FormBuilderValidators.required()
                      ],
                    )
                  : FormBuilderTextField(
                      maxLines: 3,
                      attribute: "company_address",
                      decoration: buildInputDecoration(context, "Address",
                          "Suite 2, 6/10-12 Wingate Rd Mulgrave NSW 2756 Australia"),
                      keyboardType: TextInputType.text,
                      validators: [
                        // FormBuilderValidators.min(3),
                        // FormBuilderValidators.max(70),
                        FormBuilderValidators.required()
                      ],
                    ),
              sizedbox,
              textLabel("Email Address",context),
              FormBuilderTextField(
                attribute: "email",
                decoration: buildInputDecoration(
                    context, "Email Address", "john@gmail.com"),
                keyboardType: TextInputType.emailAddress,
                validators: [
                  // FormBuilderValidators.email(),
                  FormBuilderValidators.required()
                ],
              ),
              sizedbox,
              textLabel("Phone Number",context),
              FormBuilderTextField(
                attribute: "mobile_no",
                decoration: buildInputDecoration(
                    context, "Phone Number", "1300 200 886"),
                keyboardType: TextInputType.number,
                validators: [
                  // FormBuilderValidators.numeric(),
                  FormBuilderValidators.required()
                ],
              ),

              _userController.groupValue == 0
                  ? _userController.signatureImage == null
                      ? ListTile(
                          title: Text('No Signature selected.',
                              style: uploadTextStyle),
                          trailing: Container(
                            padding: EdgeInsets.all(5),
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              onPressed: () =>
                                  getImage(_userController.signatureImage).then((val) {
                                setState(() {
                                  _userController.signatureImage = val;
                                });
                              }),
                              child: Text("Select File",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
                      : ListTile(
                          leading: Image.file(_userController.signatureImage),
                          title: Text(
                            ' Signature selected',
                            style: uploadTextStyle,
                          ),
                          trailing: Container(
                            padding: EdgeInsets.all(5),
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              onPressed: () =>
                                  getImage(_userController.signatureImage).then((val) {
                                setState(() {
                                  _userController.signatureImage = val;
                                });
                              }),
                              child: Text("Change File",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
                  : Container(),
              sizedbox,
              textLabel("Registration Number",context),
              FormBuilderTextField(
                attribute: "registration_number",
                decoration: buildInputDecoration(
                    context, "Registration Number", "41 824 753 556"),
                keyboardType: TextInputType.number,
                validators: [
                  // FormBuilderValidators.numeric(),
                  FormBuilderValidators.required()
                ],
              ),
              sizedbox,
              textLabel("Username",context),
              FormBuilderTextField(
                attribute: "username",
                decoration: buildInputDecoration(context, "Username", "john22"),
                keyboardType: TextInputType.text,
                validators: [
                  // FormBuilderValidators.min(3),
                  // FormBuilderValidators.max(70),
                  FormBuilderValidators.required()
                ],
              ),
              sizedbox,
              textLabel("Password",context),
              FormBuilderTextField(
                attribute: "password",
                decoration:
                    buildInputDecoration(context, "Password", "********"),
                keyboardType: TextInputType.text,
                obscureText: true,
                maxLines: 1,
                validators: [
                  // FormBuilderValidators.min(3),
                  // FormBuilderValidators.max(70),
                  FormBuilderValidators.required()
                ],
              ),
              sizedbox,
              textLabel("Confirm Password",context),
              FormBuilderTextField(
                attribute: "password_confirmation",
                decoration: buildInputDecoration(
                    context, "Confirm Password", "********"),
                keyboardType: TextInputType.text,
                obscureText: true,
                maxLines: 1,
                validators: [
                  // FormBuilderValidators.min(3),
                  // FormBuilderValidators.max(70),
                  FormBuilderValidators.required()
                ],
              ),
              SizedBox(
                height: 20,
              ),
              FormBuilderCheckbox(
                attribute: 'accept_terms',
                initialValue: false,
                leadingInput: true,
                label:
                    Text("I have read and agree to the terms and conditions"),
                validators: [
                  FormBuilderValidators.requiredTrue(
                    errorText:
                        "You must accept terms and conditions to continue",
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              BlockButtonWidget(
                  text: Text(
                    "Add Inspector",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () => _userController.register(context, true)),
              // onPressed: () {
              //   if (_con.signUpKey.currentState.saveAndValidate()) {
              //     print(_con.signUpKey.currentState.value);
              //   }
              // }),
              // _con.logoImage==null?Image.file(fields)
              MaterialButton(
                child: Text(
                  "Cancel",
                ),
                onPressed: () {
                  // _fbKey.currentState.reset();
                  // Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  SignUpUser fields = new SignUpUser();
}
