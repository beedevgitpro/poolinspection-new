import 'dart:convert';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:poolinspection/src/elements/custom_progress_dialog.dart';

import 'package:poolinspection/src/helpers/sharedpreferences/userpreferences.dart';
import 'package:poolinspection/src/models/route_argument.dart';
import 'package:poolinspection/src/models/signupfields.dart';
import 'package:poolinspection/src/models/user.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/src/repository/user_repository.dart'
    as userRepository;

final String apiToken = 'beedev';

class UserController extends ControllerMVC {
  bool loginLoader = false;
  bool forgetPassLoader = false;
  bool autoValidate = false;
  bool signupLoader = false;
  User user;
  int groupValue = 0;
  bool hidePassword = true;
  File logoImage;
  File signatureImage;
  File photoImage;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> otpFormKey;
  GlobalKey<FormBuilderState> signUpKey;
  GlobalKey<FormBuilderState> forgetPasswordKey;
  GlobalKey<FormState> updatePasswordKey;

  GlobalKey<ScaffoldState> scaffoldKey;

  UserController() {
    updatePasswordKey = new GlobalKey<FormState>();
    loginFormKey = new GlobalKey<FormState>();
    otpFormKey = new GlobalKey<FormState>();
    signUpKey = GlobalKey<FormBuilderState>();
    forgetPasswordKey = GlobalKey<FormBuilderState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    user = new User();
    // fetchData();
  }

  void login(BuildContext context) async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      final pr=ProgressDialog(context);
      pr.show();
      setState(() => loginLoader = true);

      userRepository.login(user,context).then((value) {
        pr.hide();
       if(value==null)
         {
           
           setState(() => loginLoader = false);
         }
       
       else if (value['errors'] == "1") {
          setState(() => loginLoader = false);
          
          Flushbar(
            title: "Access Denied",
            message: "Wrong email or password",
            duration: Duration(seconds: 3),
          )..show(context);
        } else if (value['errors'] == "2") {
          setState(() => loginLoader = false);
          Flushbar(
            title: "Access Denied",
            message: "Activation pending from Administrator",
            duration: Duration(seconds: 3),
          )..show(context);
        } else if (value['errors'] == "0" &&
                value['userdata']['user']['roles_manage'] == 2 ||
            value['userdata']['user']['roles_manage'] == 3) {
          setState(() => loginLoader = false);
          Flushbar(
            title: "Access Denied",
            message: "Only Inspectors can login",
            duration: Duration(seconds: 3),
          )..show(context);
        } else {
          userRepository.currentUser = UserModel.fromJSON(value);
          UserSharedPreferencesHelper.setUserdetails(json.encode(value));
          userRepository.inspector = userRepository.currentUser.userdata.inspector;
          userRepository.company = userRepository.currentUser.userdata.company;
          userRepository.user = userRepository.currentUser.userdata.user;

          Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Home',
              arguments: RouteArgumentHome(
                  id: value['userdata']['user']['id'],
                  role: value['userdata']['user']['rolesManage']));


          flushbar(value, context, "Welcome Inspector");
        }
      });
    }
  }

  Flushbar<Object> flushbar(dynamic value, BuildContext context, String title) {
    return Flushbar(
      title: title,
      message: value['userdata']['company'] != null
          ? "${value['userdata']['company']['companyName']}!"
          : "${value['userdata']['inspector']['first_name']}!",
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void updatePassword(BuildContext context) async {
    if (updatePasswordKey.currentState.validate()) {
      updatePasswordKey.currentState.save();
      print(user.confirmPassword);
      print(user.password);
      print(user.id);
      userRepository.updatePassword(user).then((val) {
        if (val.error == '0') {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/Home', (Route<dynamic> route) => false);
          Flushbar(
            title: "Status ${val.status}",
            message: val.messages,
            duration: Duration(seconds: 3),
          )..show(context);
        } else {
          Flushbar(
            title: "Status ${val.status}",
            message: val.messages,
            duration: Duration(seconds: 3),
          )..show(context);
        }
      });
    }
  }

  void forgetPassword(BuildContext context, String text) {
    print(text);
    if (forgetPasswordKey.currentState.saveAndValidate()) {
      setState(() => forgetPassLoader = true);

      userRepository.forgetPassword(text).then((val) {
        if (val.error == '0') {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/Login', (Route<dynamic> route) => false);
          Flushbar(
            title: "Password Change request Sent",
            message: "Wait for the Approval from Administrator",
            duration: Duration(seconds: 3),
          )..show(context);
        } else {
          setState(() => forgetPassLoader = false);

          Flushbar(
            title: "Email Address",
            message: "doesn't exist",
            duration: Duration(seconds: 3),
          )..show(context);
        }
      });




    }
  }

  void register(BuildContext context, bool companyInspector) {
    SignUpUser fields;
    if (signUpKey.currentState.saveAndValidate()) {
      final pr=ProgressDialog(context);
      pr.show();
      setState(() => signupLoader = true);
      fields = SignUpUser.fromJson(
        signUpKey.currentState.value,
        signatureImage,
        photoImage,
        photoImage,
      );
      if (groupValue == 0) {
        if (
            photoImage != null &&
                fields.password == fields.passwordConfirmation) {
          if (companyInspector) {
            userRepository.addCompanyInspector(fields).then((val) {
              pr.hide();
              if (val == []) {
                setState(() => signupLoader = false);

                Flushbar(
                  title: "Please Verify",
                  message: "Internet Down",
                  duration: Duration(seconds: 3),
                )..show(context);
              }
              if (val['error'] == 1) {
                setState(() => signupLoader = false);

                Flushbar(
                  title: "Please Verify",
                  message: val['messages'].toString(),
                  duration: Duration(seconds: 3),
                )..show(context);
              } else {

                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Home', (Route<dynamic> route) => false);
                Flushbar(
                  title: "Status ${val.status}",
                  message: val['messages'].toString(),
                  duration: Duration(seconds: 3),
                )..show(context);
              }
            });
          } else {
            //register inspectors
            userRepository.registerInspector(fields,context).then((val) {
              pr.hide();
              print(val);

              setState(() => signupLoader = false);

              if(val==null)
                {
                  setState(() => signupLoader = false);
                }
             else if (val['error'] == 1) {
                Flushbar(
                  title: "Please Verify",
                  message: val['messages'].toString(),
                  duration: Duration(seconds: 3),
                )..show(context);
              } else {

                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Login', (Route<dynamic> route) => false);
                Flushbar(
                  title: "Registration Successfull",
                  message: "Wait for your approval from the Administrator",
                  duration: Duration(seconds: 3),
                )..show(context);
              }
            });
          }
        } else {
          if (photoImage == null) {
            setState(() => signupLoader = false);

            Flushbar(
              title: "Logo Required",
              message: "Please Pick a Logo",
              duration: Duration(seconds: 3),
            )..show(context);
          } else if (fields.password != fields.passwordConfirmation) {
            setState(() => signupLoader = false);

            Flushbar(
              title: "Password & Confirm Password Fields don't match",
              duration: Duration(seconds: 3),
            )..show(context);
          }
        }
      }


      else {
        if (photoImage != null &&
            fields.password == fields.passwordConfirmation) {
           print("hello"+fields.toJson().toString());                       
          userRepository.registerCompany(fields).then((val) {
            print(val);
            if (val['error'] == 1) {
              setState(() => signupLoader = false);

              Flushbar(
                title: "Please Verify",
                message: val['messages'].toString(),
                duration: Duration(seconds: 3),
              )..show(context);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Login', (Route<dynamic> route) => false);
              Flushbar(
                title: "Registration Successfull",
                message: "Wait for your approval from the Administrator",
                duration: Duration(seconds: 3),
              )..show(context);
            }
          });
        } else {
          if (photoImage == null) {
            setState(() => signupLoader = false);

            Flushbar(
              title: "Logo Required",
              message: "Please pick a Company Logo",
              duration: Duration(seconds: 3),
            )..show(context);
          } else if (fields.password != fields.passwordConfirmation) {
            setState(() => signupLoader = false);
            Flushbar(
              title: "Passwords don't match",
              message:"Passwords & Confirm Password Fields don\'t match",
              duration: Duration(seconds: 3),
            )..show(context);
          }
        }
      }
    }else{
      Flushbar(
              title: "Please verify Entered Information",
              message: "Invalid/Missing Information",
              duration: Duration(seconds: 3),
            )..show(context);
    }
  }
}


