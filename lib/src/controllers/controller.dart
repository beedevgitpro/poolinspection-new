import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/src/helpers/sharedpreferences/userpreferences.dart';
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;

class Controller extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  Controller() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    UserSharedPreferencesHelper.getCurrentToken().then((token) {
      setState(() {
        print("$token getCurrentToken token");
        userRepo.token = token;
      });
    });

    UserSharedPreferencesHelper.getCompanyDetail().then((company) {
      setState(() {
        print("${company.companyName} getCompanyDetail token");
        userRepo.company = company;
      });
    });

    UserSharedPreferencesHelper.getInspectorDetail().then((inspector) {
      setState(() {
        print("${inspector.id} getInspectorid token");
        userRepo.inspector = inspector;
      });
    });
    UserSharedPreferencesHelper.getUserDetails().then((user) {
      setState(() {
        print("${user.id} userid getUserDetails");
        userRepo.user = user;
      });
    });
  }
}
