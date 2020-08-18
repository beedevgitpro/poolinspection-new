import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/user_controller.dart';
import 'package:poolinspection/src/elements/BlockButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/helpers/connectivity.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends StateMVC<LoginWidget> {
  bool _isConnected=true;
  UserController _userController;
  ConnectionStatusSingleton connectionStatus;
  final focus = FocusNode();
  var subscription;
  _LoginWidgetState() : super(UserController()) {
    _userController = controller;
  }


  @override
  void initState() {
    super.initState();
    subscription=Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
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
    subscription.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _userController.scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: GestureDetector(
          onPanDown: (_){
            FocusScope.of(context).requestFocus(FocusNode());
          },
                  child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: ListView(children: <Widget>[
              Container(
                height: config.App(context).appHeight(20),
                child: Image.asset("assets/img/logo.png"),
              ),
              Text(
                "Login",
                style: TextStyle(
                  fontSize: getFontSize(context,13),
                  color: Color(0xff222222),
                  fontWeight: FontWeight.w700,
                  fontFamily: "AVENIRLTSTD",
                )
              ),
              SizedBox(height: 25),
              Form(
                key: _userController.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      style: TextStyle(fontSize: getFontSize(context,2),
                        color: Color(0xff222222),
                        fontFamily: "AVENIRLTSTD",),
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus);
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (input) => _userController.user.email = input,
                      validator: (input) =>
                      !input.contains('@') || !input.contains('.')
                          ? 'Please enter a valid Email'
                          : null,
                      decoration: InputDecoration(
                        enabledBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black
                          ),
                        ),
                        focusedBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black
                          ),
                        ),
                        labelText: "Email Address",
                        labelStyle: TextStyle(
                          fontSize: getFontSize(context,2),
                          color: Color(0xff222222),
                          fontFamily: "AVENIRLTSTD",
                        ),
                        
                        contentPadding: EdgeInsets.all(5),
                        hintText: 'Enter Email Address',
                        hintStyle: TextStyle(
                            color:
                            Theme
                                .of(context)
                                .focusColor
                                .withOpacity(0.7)),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      style: TextStyle(fontFamily: "AVENIRLTSTD", fontSize: getFontSize(context,2),
                        color: Color(0xff222222),
                      ),
                      focusNode: focus,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _userController.user.password = input,
                      validator: (input) =>
                      input.length < 3
                          ? 'Password should be more than 3 characters'
                          : null,
                      obscureText: _userController.hidePassword,
                      decoration: InputDecoration(
                        enabledBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black
                          ),
                        ),
                        focusedBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black
                          ),
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: getFontSize(context,2),
                          color: Color(0xff222222),
                          fontFamily: "AVENIRLTSTD",
                        ),
                        contentPadding: EdgeInsets.all(5),
                        hintText: '••••••••••••',
                        hintStyle: TextStyle(
                            color:
                            Theme
                                .of(context)
                                .focusColor
                                .withOpacity(0.7)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _userController.hidePassword = !_userController.hidePassword;
                            });
                          },
                          color: Theme
                              .of(context)
                              .focusColor,
                          icon: Icon(_userController.hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    BlockButtonWidget(
                      text: Text(
                        'Login',
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          fontFamily: "AVENIRLTSTD",
                          fontSize: getFontSize(context,2),
                        ),
                      ),
                      color: Theme
                          .of(context)
                          .accentColor,
                      onPressed: () {
                        
                                
                        if(_isConnected)
                        _userController.login(context);
                        else
                          Flushbar(
                      title: "Device Offline",
                      message: "Not connected to the internet",
                        duration: Duration(seconds: 3),
                      )..show(context);

                      },
                    ),
                    SizedBox(height: 10),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/ForgetPassword');
                      },
                      textColor: Theme
                          .of(context)
                          .accentColor,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: getFontSize(context,0),
                          fontFamily: "AVENIRLTSTD",
                        ),
                      ),
                    ),
                     Padding(
                       padding: EdgeInsets.all(8.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?',
                                style: TextStyle(
                                  fontFamily: "AVENIRLTSTD",
                                  color: Colors.black,
                                  fontSize: getFontSize(context,0),
                                )),
                                GestureDetector(
                                  onTap: (){
                                     Navigator.pushNamed(context, '/SignUp');
                                  },
                                                                child: Text(' Register',
                                  style: TextStyle(
                                    color:Theme.of(context).accentColor,
                                    fontFamily: "AVENIRLTSTD",
                                    fontSize: getFontSize(context,0),
                                  )),
                                ),
                          ],
                        ),
                     ),
                  ],
                ),
              ),
             
            ]),
          ),
        ));
  }
}
