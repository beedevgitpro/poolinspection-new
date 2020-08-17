import 'dart:async';
import 'dart:io';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/elements/custom_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poolinspection/src/elements/drawer.dart';
import 'package:poolinspection/src/models/getpaymentdetailmodel.dart';
import 'package:poolinspection/src/models/selectCompliantOrNotice.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:poolinspection/src/helpers/sharedpreferences/userpreferences.dart';
import 'package:poolinspection/src/constants/validators.dart';
import 'package:poolinspection/src/controllers/user_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/elements/inputdecoration.dart';
import 'package:poolinspection/src/elements/textlabel.dart';
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;
import 'package:poolinspection/src/models/signupfields.dart';


class AddCardDetailWidget extends StatefulWidget {
  @override
  _AddCardDetailState createState() => _AddCardDetailState();

}

class _AddCardDetailState extends StateMVC<AddCardDetailWidget> {
  final uploadTextStyle = TextStyle(color: Colors.blueGrey);
  UserController _userController;
   String cardNumber;
  bool showCard=false;
  bool showCardUpdateButton=false;
  int userId;
  final cvvNode=FocusNode();
  final monthNode=FocusNode();
  final yearNode=FocusNode();
  final cardNumberNode=FocusNode();
  GlobalKey<FormBuilderState> _addcreditcardKey =  GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormBuilderState> signUpKey = GlobalKey<FormBuilderState>();
  _AddCardDetailState() : super(UserController()) {
    _userController = controller;
  }
  Future getCardNumber() async {
    ProgressDialog pr;
    pr = ProgressDialog(context,isDismissible: false);
    try {

      await pr.show();

     await UserSharedPreferencesHelper.getUserDetails().then((user) {
        setState(() {
          userId=user.id;

        });
      });
    print("useruseruser"+userId.toString());
      final response = await http.get(
        'https://poolinspection.beedevstaging.com/api/beedev/payment-detail/$userId',

      );

      PaymentDetailGetApiModel getcardnumber = paymentDetailGetApiModelFromJson(response.body);


      if (getcardnumber.status=="pass" && getcardnumber.paymentDetail.cardNo!=null) {


        await pr.hide();

        cardNumber=getcardnumber.paymentDetail.cardNo.toString();


        setState(() {
          showCardUpdateButton=true;

        });
      }
      else {

        await pr.hide();
        setState(() {

          showCardUpdateButton=false;

        });

      }
    }on TimeoutException catch (_) {
      await pr.hide();
      Fluttertoast.showToast(
          msg: "Connection Time Out ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white ,
          fontSize: getFontSize(context,-2)
      );
    }
    on SocketException catch (e) {
      print(e);
      await pr.hide();
      Fluttertoast.showToast(
          msg: "No Internet Connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );
    }
    on Exception catch (e) {
      await pr.hide();
      Fluttertoast.showToast(
          msg: "Error:"+e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );
    }
  }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){

      getCardNumber();
    });
    UserSharedPreferencesHelper.getUserDetails().then((user) {
      setState(() {
        userId=user.id;

      });
    });
  }

  @override
  Widget build(BuildContext context) {

   return Scaffold(
       backgroundColor: config.Colors().scaffoldColor(1),

       endDrawer: drawerData(context, userRepo.user.rolesManage),
     appBar: AppBar(
       leading: IconButton(
           icon: Icon(
             Icons.arrow_back_ios,
             color: config.Colors().secondColor(1),
           ),
           onPressed: () => Navigator.pop(context)),
       title: Align(alignment: Alignment.center,
         child:Text("Your Card Details",
         style: TextStyle(
           fontWeight: FontWeight.w500,
           fontFamily: "AVENIRLTSTD",
           fontSize: getFontSize(context,2),
           color: Color(0xff222222),
         ),
       ),

    ),
       actions: <Widget>[
         IconButton(
             icon: Icon(Icons.menu),
             onPressed: () => _scaffoldKey.currentState.openEndDrawer())
       ],
       ),
       key: _scaffoldKey,
       resizeToAvoidBottomPadding: true,
       body: GestureDetector(
         onPanDown: (_){
           FocusScope.of(context).requestFocus();
         },
                     child: Padding(
           padding: const EdgeInsets.all(8.0),
           child: buildCardDetailsForm(context),
         ),
       ));
  }



  FormBuilder buildCardDetailsForm(BuildContext context) {

    ProgressDialog pr;


    Future<void> addPaymentMethod(userid,cardname,cardnumber,cardcvv,cardexpirymonth,cardexpiryyear) async {
      pr = ProgressDialog(context,isDismissible: false);
      await pr.show();
      
      print("check="+cardname.toString()+cardnumber.toString()+cardcvv.toString()+cardexpirymonth.toString()+cardexpiryyear.toString());
     try {
       
       final response = await http.post(
           'https://poolinspection.beedevstaging.com/api/beedev/add-payment-method',
           body: {
             'user_id': userid,
             'payment_method':'card',
             'card_name': cardname,
             'card_number': cardnumber,
             'card_cvv': cardcvv,
             'card_expiry_month': cardexpirymonth,
             'card_expiry_year': cardexpiryyear
           }
       );
       SelectNonCompliantOrNotice loginrespdata = selectNonCompliantOrNoticeFromJson(response.body);

       if (loginrespdata.status == "pass") {
         print("inisdesucess=" + userid);
      await pr.hide();
         Fluttertoast.showToast(
             msg: "Card Details Updated ",
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,

             backgroundColor: Colors.blueAccent,
             textColor: Colors.white,
             fontSize: getFontSize(context,-2)
         );
         Navigator.pushNamedAndRemoveUntil(context,'/Home',(Route<dynamic> route) => false);
       }

       else {

         await pr.hide();
         Fluttertoast.showToast(
             msg: loginrespdata.messages.toString(),
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,

             backgroundColor: Colors.blueAccent,
             textColor: Colors.white,
             fontSize: getFontSize(context,-2)
         );
       }
     }on TimeoutException catch (_) {
       await pr.hide();
       Fluttertoast.showToast(
           msg: "Connection Time Out ",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.BOTTOM,
           timeInSecForIosWeb: 1,
           backgroundColor:Colors.red,
           textColor:Colors.white ,
           fontSize: getFontSize(context,-2)
       );
     }
     on SocketException catch (_) {
       await pr.hide();
       Fluttertoast.showToast(
           msg: "No Internet Connection",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.BOTTOM,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.red,
           textColor: Colors.white,
           fontSize: getFontSize(context,-2)
       );
     }
     on Exception catch (e) {
       await pr.hide();
       Fluttertoast.showToast(
           msg: "Error:"+e.toString(),
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.BOTTOM,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.red,
           textColor: Colors.white,
           fontSize: getFontSize(context,-2)
       );
     }

    }



    final sizedbox =
    SizedBox(height: config.App(context).appVerticalPadding(2));
    return FormBuilder(
      key:_addcreditcardKey,
       initialValue: {

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
       },
      autovalidate: _userController.autoValidate,
      child: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                 alignment: Alignment.centerLeft,
                  padding: new EdgeInsets.all(10.0),
                  child: Text("Card Details" ,textAlign: TextAlign.center, style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize:20,fontFamily: "AVENIRLTSTD",color:Colors.black))
              ),
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child:Column(
                  children: <Widget>[


                  showCardUpdateButton?Column(
                      children: <Widget>[
                        textLabel("Your Card Number",context),
                        FormBuilderTextField(
                          
                          style: TextStyle(color: Color(0xff222222), fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,-1)),
                          attribute: "card_number",
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                          maxLength: 16,
                          readOnly: true,


                          keyboardType: TextInputType.number,
                          decoration: buildInputDecoration(
                              context, "Your Card Number", cardNumber),
                          validators: [
                            FormBuilderValidators.maxLength(16),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(16),
                          ],
                        ),
                        FlatButton(
                            color:Color(0xff0ba1d9),
                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Update Card",
                                style: TextStyle(
                                    fontSize: getFontSize(context,-1),
                                    color: Colors.white, fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.w900),
                              ),
                            ),


                            onPressed: () {

                              setState(() {
                                showCardUpdateButton=false;
                              });
                            }

                        ),



                        sizedbox,

                      ]
                  ):  Column(
                children: <Widget>[
                sizedbox,
                textLabel("Name on Card",context),
                FormBuilderTextField(
                  
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_){
                                      cardNumberNode.requestFocus();
                                    },
                  style: TextStyle(color: Color(0xff222222), fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,-1),),
                  attribute: "card_holder_name",
                  decoration: buildInputDecoration(
                      context, "Enter Name", "Name on Card"),
                  keyboardType: TextInputType.text,
                  validators: [
                    FormBuilderValidators.min(4),
                    CustomFormBuilderValidators.charOnly(),
                    FormBuilderValidators.maxLength(20),
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(4),
                  ],
                ),
                sizedbox,
                textLabel("Card Number",context),
                FormBuilderTextField(
                  focusNode: cardNumberNode,
                  
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_){
                                      monthNode.requestFocus();
                                    },
                  style: TextStyle(color: Color(0xff222222), fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,-1)),
                  attribute: "card_number",
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  maxLength: 16,
                  keyboardType: TextInputType.number,
                  decoration: buildInputDecoration(
                      context, "Card Number", "0000 0000 0000 0000"),
                  validators: [
                    FormBuilderValidators.maxLength(16),
                    FormBuilderValidators.numeric(),

                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(16),
                  ],
                ),
                sizedbox,

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child:Column(
                          children: <Widget>[
                            textLabel("Valid Through",context),
                            Row(
                              children: <Widget>[
                                Expanded(child:Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child:FormBuilderTextField(
                                    focusNode: monthNode,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_){
                                      yearNode.requestFocus();
                                    },
                                    style: TextStyle(color: Color(0xff222222), fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,-1)),
                                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],

                                    attribute: "card_expiry_month",
                                    maxLength: 2,
                                    keyboardType: TextInputType.number,

                                    decoration: buildInputDecoration(context, "Month", "Month"),
                                    validators: [
                                      FormBuilderValidators.min(1),
                                      FormBuilderValidators.max(12),
                                      FormBuilderValidators.minLength(2),
                                      FormBuilderValidators.numeric(),
                                    ],
                                  ),),),
                                sizedbox,

                                Expanded(child:Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child:FormBuilderTextField(
                                    focusNode: yearNode,
                                    onFieldSubmitted: (_){
                                      cvvNode.requestFocus();

                                    },
                                    style: TextStyle(color: Color(0xff222222), fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,-1)),
                                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                    attribute: "card_expiry_year",
                                    textInputAction: TextInputAction.next,
                                    maxLength: 4,
                                    keyboardType: TextInputType.number,
                                    decoration: buildInputDecoration(context, "Year", "Year"),
                                    validators: [
                                      FormBuilderValidators.min(2020),
                                      FormBuilderValidators.max(2035),
                                      FormBuilderValidators.minLength(4),
                                      FormBuilderValidators.numeric(),
                                    ],
                                  ),),),

                                sizedbox,


                              ],
                            ),


                          ]
                      ),),

                    Expanded(
                      flex: 3,
                      child:Column(
                          children: <Widget>[

                            Padding(
                              child:textLabel("CVV",context),
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(child:Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child:FormBuilderTextField(
                                    focusNode: cvvNode,
                                    style: TextStyle(color: Color(0xff222222), fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,-1)),
                                    attribute: "card_cvv",
                                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],

                                    maxLength: 3,
                                    keyboardType: TextInputType.number,
                                    decoration: buildInputDecoration(context, "CVV Number", "000"),
                                    validators: [
                                      FormBuilderValidators.min(3),
                                      FormBuilderValidators.numeric(),
                                      FormBuilderValidators.required()
                                    ],
                                  ),
                                ),)
                              ],
                            ),


                          ]
                      ),),
                  ],
                ),




                sizedbox,

                ]
            ),



                    showCardUpdateButton
                        ? Container()
                        : Align(
                  alignment: Alignment.topLeft,
                  child:Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child:  Align(
                        alignment: Alignment.topLeft,
                        child: FlatButton(
                            
                            color:Color(0xff0ba1d9),
                            child:Padding(
                              padding:  EdgeInsets.all(10.0),
                              child: Text(

                                "Update",
                                style: TextStyle(
                                    fontSize: getFontSize(context,0),

                                    color: Colors.white, fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.w900),
                              ),
                            ),


                            onPressed: () async{
                              if (_addcreditcardKey.currentState.saveAndValidate()) {

                                await addPaymentMethod(userId.toString(),_addcreditcardKey.currentState.value["card_holder_name"].toString(),_addcreditcardKey.currentState.value["card_number"].toString(),_addcreditcardKey.currentState.value["card_cvv"].toString(),_addcreditcardKey.currentState.value["card_expiry_month"].toString(),_addcreditcardKey.currentState.value["card_expiry_year"].toString());

                              }


                            }
                          
                        ),
                      ),
                    
                  ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                  ],
                ),
              ),
            ),
          ],)
        ),
      ),
    );
  }

  SignUpUser fields = new SignUpUser();


}
