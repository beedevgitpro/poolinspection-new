import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/elements/drawer.dart';
import 'package:poolinspection/src/models/getpaymentdetailmodel.dart';
import 'package:poolinspection/src/models/selectCompliantOrNotice.dart';
import 'package:poolinspection/src/elements/custom_progress_dialog.dart';
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


class AddBankDetailWidget extends StatefulWidget {
  @override
  _AddBankDetailState createState() => _AddBankDetailState();

}

class _AddBankDetailState extends StateMVC<AddBankDetailWidget> {
  final uploadTextStyle = TextStyle(color: Colors.blueGrey);
  UserController _userController;
  String accountNumber="";
  String accountName="";
  String bSBNumber="";
  int userID;
  final accNumberNode=FocusNode();
  final bsbNumberNode=FocusNode();
  GlobalKey<FormBuilderState> _addBankDetailsKey =  GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();
  GlobalKey<FormBuilderState> signUpKey = GlobalKey<FormBuilderState>();
  _AddBankDetailState() : super(UserController()) {
    _userController = controller;
  }
  Future<PaymentDetailGetApiModel> getBankDetail() async {

    try {



      await UserSharedPreferencesHelper.getUserDetails().then((user) {


          userID=user.id;


      });
      print("useruseruser"+userID.toString());
      final response = await http.get(
        'https://poolinspection.beedevstaging.com/api/beedev/payment-detail/$userID',

      );

      PaymentDetailGetApiModel getbankdetail = paymentDetailGetApiModelFromJson(response.body);

     return getbankdetail;
    }on TimeoutException catch (_) {

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






  Future<void> addBankDetail(userid,accountname,accountnumber,bsbnumber) async {
    ProgressDialog pr;
    pr = ProgressDialog(context,isDismissible: false);
    await pr.show();

    try
    {
      print("ssss"+userid.toString()+accountnumber.toString()+accountname.toString()+bsbnumber.toString());
      final response = await http.post(
          'https://poolinspection.beedevstaging.com/api/beedev/add_bank_details',
          body: {'user_id':userid,'account_name':accountname,'account_no':accountnumber,'bsb_no':bsbnumber}
      );
      print("bankdetailrespnse"+response.body.toString());
      SelectNonCompliantOrNotice loginrespdata = selectNonCompliantOrNoticeFromJson(response.body);

      if (loginrespdata.status== "pass") {
        await pr.hide();
        Fluttertoast.showToast(
            msg: "Bank Details Updated",
            //response code is 400
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,

            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
            fontSize: getFontSize(context,-2)
        );
        Navigator.pushNamedAndRemoveUntil(context,'/Home',(Route<dynamic> route) => false);
      }

      else {
        print("inisdefail");
        await  pr.hide();
        Fluttertoast.showToast(
            msg: "Payment Updation Failed:"+loginrespdata.error.toString(),

            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,

            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
            fontSize: getFontSize(context,-2)
        );
      }
    }
    on TimeoutException catch (_) {
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

      getBankDetail();
    });

    print("AccountNumber"+accountNumber.toString());
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
          child:Text("Your Bank Details",
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

        // actions: <Widget>[
        //   IconButton(icon: Icon(Icons.dns), onPressed: () => print(''))
        // ],
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        body: GestureDetector(
          onPanDown: (_){
            FocusScope.of(context).requestFocus();
          },
                      child: FutureBuilder<PaymentDetailGetApiModel>(
            future: getBankDetail(),
            builder: (context, snapshot) {

              if (snapshot.hasData) {
                
                if(snapshot.data.paymentDetail.accountName!=null)
                {




                accountName=snapshot.data.paymentDetail.accountName;
                accountNumber=snapshot.data.paymentDetail.accountNumber;
                bSBNumber=snapshot.data.paymentDetail.bsbNumber;



                return Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildBankDetailsForm(context),
                );
                  }

                else
                  {
                  return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildBankDetailsForm(context),);

                  }
                }
                else
                {
                  return Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),

                  );
                }


            },

          ),
        ),
    );

  }



  FormBuilder buildBankDetailsForm(BuildContext context) {


    final sizedbox =
    SizedBox(height: config.App(context).appVerticalPadding(2));
    return FormBuilder(

      key:_addBankDetailsKey,
       initialValue: {
//         "account_name":"Hello",
//         "account_no":AccountNumber,
//         "bsb_no":BSBNumber

       },
      autovalidate: _userController.autoValidate,
      child:SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:Column(children: <Widget>[
          
                 Container(
                   alignment: Alignment.centerLeft,
                   child: Padding(
                     padding: EdgeInsets.all(5.0),
                     child:Text("Bank Details" ,textAlign: TextAlign.center, style: TextStyle(
                                 fontWeight: FontWeight.bold, fontSize:20,fontFamily: "AVENIRLTSTD",color:Colors.black))
                        
                       
                   ),
                 ),


            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child:Column(
                  children: <Widget>[


                    Column(
                        children: <Widget>[
                           sizedbox,
                          textLabel("Account Name",context),
                          FormBuilderTextField(
                            style: TextStyle(color: Color(0xff222222), fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,-1)),
                            attribute: "account_name",
                            initialValue: accountName,

                            decoration: buildInputDecoration(
                                context, "Enter Account Name", "Enter Account Name"),
                            keyboardType: TextInputType.text,
                            textInputAction:TextInputAction.next,
                            onFieldSubmitted: (_){
                              accNumberNode.requestFocus();
                            },
                            validators: [
                              FormBuilderValidators.min(4),
                              // FormBuilderValidators.pattern(r'^\D+$'),
                              CustomFormBuilderValidators.charOnly(),
                              FormBuilderValidators.maxLength(25),
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(4),
                            ],
                          ),
                          sizedbox,

                          textLabel("Account Number",context),
                          FormBuilderTextField(
                            initialValue: accountNumber,
                            style: TextStyle(color: Color(0xff222222), fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,-1)),
                            attribute: "account_no",
                            
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            maxLength: 18,

                            keyboardType: TextInputType.number,
                            textInputAction:TextInputAction.next,
                            focusNode:accNumberNode,
                            onFieldSubmitted: (_){
                              bsbNumberNode.requestFocus();
                            },
                            decoration: buildInputDecoration(
                                context, "Account Number", "Enter Account Number"),
                            validators: [
                              // FormBuilderValidators.creditCard(),
                              FormBuilderValidators.maxLength(18),
                              FormBuilderValidators.numeric(),

                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(9),
                            ],
                          ),
                          sizedbox,
                          textLabel("BSB Number",context),
                          FormBuilderTextField(
                            focusNode:bsbNumberNode,
                            initialValue: bSBNumber,
                            style: TextStyle(color: Color(0xff222222), fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,-1)),
                            attribute: "bsb_no",
                           
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            decoration: buildInputDecoration(
                                context, "BSB Number", "Enter BSB Number"),
                            validators: [
                              // FormBuilderValidators.creditCard(),
                              FormBuilderValidators.maxLength(6),
                              FormBuilderValidators.numeric(),

                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(6),
                            ],
                          ),
                          sizedbox,
                        ]
                    ),

 Align(
                  alignment: Alignment.topLeft,
                  child:Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child:
//                        
                      FlatButton(
                          // shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                          color:Color(0xff0ba1d9),
                          child:Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(

                              "Update",
                              style: TextStyle(
                                  fontSize: getFontSize(context,0),

                                  color: Colors.white, fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.w900),
                            ),
                          ),


                          onPressed: () {
                            if (_addBankDetailsKey.currentState.saveAndValidate()) {
//    Future<AddPAymentModel> addPaymentMethod(userid,paymentmethod,cardname,cardnumber,cardcvv,cardexpirymonth,cardexpiryyear,accountname,accountnumber,bsbnumber) async {//    Future<AddPAymentModel> addPaymentMethod(userid,paymentmethod,cardname,cardnumber,cardcvv,cardexpirymonth,cardexpiryyear,accountname,accountnumber,bsbnumber) async {

                              addBankDetail(userID.toString(),_addBankDetailsKey.currentState.value["account_name"].toString(),_addBankDetailsKey.currentState.value["account_no"].toString(),_addBankDetailsKey.currentState.value["bsb_no"].toString());

//      print("furmdata="+_addcreditcardKey.currentState.value["select_cardorbank"].toString());
                            }


                          }
                        // onPressed: () {
                        //   if (_con.signUpKey.currentState.saveAndValidate()) {
                        //     print(_con.signUpKey.currentState.value);
                        //   }
                        // }
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
