import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/user_controller.dart';
import 'package:poolinspection/src/elements/BlockButtonWidget.dart';
import 'package:poolinspection/src/elements/inputdecoration.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends StateMVC<ForgotPasswordScreen> {
  final textController = TextEditingController();
  UserController _userController;
  _ForgotPasswordScreenState() : super(UserController()) {
    _userController = controller;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
       elevation: 0,
       iconTheme:IconThemeData(
        size: 30 
       ),
       leading: IconButton(
         onPressed: (){
           Navigator.pop(context);
         },
         icon: Icon(Icons.arrow_back)),
      ),
      body: GestureDetector(
        onPanDown: (_){
          FocusScope.of(context).requestFocus(FocusNode());
        },
              child: SafeArea(
                child: Padding(
            padding: const EdgeInsets.all(40),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 30),

               Icon(Icons.lock,size: 50,),
               SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Forgot Your Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: getFontSize(context,4), fontWeight: FontWeight.w500)
                          .merge(
                        TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(height: 30),
                FormBuilder(
                    key: _userController.forgetPasswordKey,
                    
                    autovalidate: true,
                    child: FormBuilderTextField(
                      controller: textController,
                      attribute: "email",
                      keyboardType: TextInputType.emailAddress,
                      decoration: buildInputDecoration(
                          context, "Email Address", "john@gmail.com"),
                      validators: [
                        FormBuilderValidators.email(),
                        FormBuilderValidators.required()
                      ],
                    )),
                SizedBox(height: 15),
                
                SizedBox(height: 30),
                _userController.forgetPassLoader
                    ? SizedBox(
                        width: 15,
                        child: Center(child: CircularProgressIndicator()))
                    : SizedBox(
                        width: MediaQuery.of(context).size.height * 1,
                        child: new BlockButtonWidget(
                          onPressed: () =>
                              _userController.forgetPassword(context, textController.text),
                          color: Theme.of(context).accentColor,
                          text: Text('Send Mail',
                              style: Theme.of(context).textTheme.headline6.merge(
                                  TextStyle(
                                    fontSize: getFontSize(context,-2),
                                      color: Theme.of(context).primaryColor))),
                        ),
                      ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
