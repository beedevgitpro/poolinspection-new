import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/controller.dart';
import 'package:poolinspection/src/helpers/connectivity.dart';
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;
import 'package:mvc_pattern/mvc_pattern.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  bool isOffline = false;

  Controller _con;

  SplashScreenState() : super(Controller()) {
    _con = controller;
  }
  ConnectionStatusSingleton connectionStatus;
  @override
  void initState() {
    super.initState();
    isOffline=true;
    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    // print(currentUser.token2fa);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (userRepo.token!= null) {
        Navigator.of(context).pushReplacementNamed('/Home');
      } else {
        Navigator.of(context).pushReplacementNamed('/Login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _con.scaffoldKey,
      body: Container(
        decoration: new BoxDecoration(

          image: new DecorationImage(
            image: new AssetImage("assets/img/poolsplashimage.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.pool,
                size: MediaQuery.of(context).size.height*0.2,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              Text(
                "Pool Inspection",
                style: Theme.of(context).textTheme.headline4.merge(TextStyle(
                  fontSize: getFontSize(context,0),
                    color: Theme.of(context).scaffoldBackgroundColor)),
              ),
              SizedBox(height: 50),
             // isOffline
               Container(
                 width: MediaQuery.of(context).size.width*0.1,
                 height: MediaQuery.of(context).size.width*0.1,
                 child: CircularProgressIndicator(
                        strokeWidth: 10,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).scaffoldBackgroundColor),
                      ),
               )
                 
            ],
          ),
        ),
      ),
    );
  }
}
