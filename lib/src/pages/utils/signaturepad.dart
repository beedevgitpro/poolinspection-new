import 'package:poolinspection/constants.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/elements/BlockButtonWidget.dart';
import 'package:poolinspection/src/elements/drawer.dart';
import 'package:poolinspection/src/elements/inputdecoration.dart';
import 'package:poolinspection/src/elements/radiobutton.dart';
import 'package:poolinspection/src/elements/custom_progress_dialog.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;
import 'package:poolinspection/config/app_config.dart' as config;

class SignCertificateScreen extends StatefulWidget {
  final String id;
  final String category;
  final String bookingDateTime;

  final String bookingtime;
  SignCertificateScreen(this.id,this.category,this.bookingDateTime,this.bookingtime);
  @override
  _SignCertificateScreenState createState() => _SignCertificateScreenState(id,category,bookingDateTime,bookingtime);
}


class _SignCertificateScreenState extends State<SignCertificateScreen> {
  bool autoValidate = true;
  bool readOnly = true;
  List regulationdata;
  GlobalKey<FormBuilderState> _formNKey =  GlobalKey<FormBuilderState>();
  String id;
  String category;
  String bookingTime;
  ProgressDialog pr;
  String bookingDateTime;
  List<bool> nonCompliance=[false,false,false,false];
  List<bool> compliant=[false,false,false,false];
  bool progressCircular = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  _SignCertificateScreenState(id,category,bookingDateTime,bookingTime)
  {
    this.id=id;
    this.category=category;
    this.bookingDateTime=bookingDateTime;
    this.bookingTime=bookingTime;

  }


  @override
  void initState() {
    super.initState();

    _signatureController.addListener(() => print("Value changed"));
    pr = ProgressDialog(context,isDismissible: false);
  }

  Future generatePdf(var dataimage,String paymentpaid) async
  {
    await pr.show();
    String base64Image = base64Encode(dataimage);

    try {
      final response = await http.post(
          '$baseUrl/beedev/post_signature',
          body: {'job_id': id, 'signature':"data:image/png;base64,"+base64Image,'payment_paid':paymentpaid,'non_compliance_option1':nonCompliance[0]?'1':'0',
'non_compliance_option2':nonCompliance[1]?'1':'0',
'non_compliance_option3':nonCompliance[2]?'1':'0',
'non_compliance_option4':nonCompliance[3]?'1':'0',
'barrier_standard_option1':compliant[0]?'1':'0',
'barrier_standard_option2':compliant[1]?'1':'0',
'barrier_standard_option3':compliant[2]?'1':'0',
}
      );
      print("kkresponse"+response.body.toString());

      if(response.body.toString().contains("<!DOCTYPE html>")) {
        await pr.hide();
        Fluttertoast.showToast(
            msg: "Not returning pdf:-\n"+response.body.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: getFontSize(context,-2)
        );
      }
      else
        {
          await pr.hide();
          Navigator.of(context).pop();
        }
     // print("kkresponse"+file.toString());
    }catch(e)
    {
      await pr.hide();
      print("errorinsignaturebackend"+e.toString());
      Fluttertoast.showToast(
          msg: "Error from backend"+e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );
    }




  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
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
            child:Text("Signature",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: "AVENIRLTSTD",
                fontSize: getFontSize(context,2),
                color: Color(0xff222222),
              ),
            ),

          ),
          actions: <Widget>[
            Image.asset(
            "assets/img/app-iconwhite.jpg",
            fit: BoxFit.fitWidth,
          )
          ],
        ),

        body:Builder(
            builder: (context) => Scaffold(
              body: SafeArea(
                              child: SingleChildScrollView(
                                child: Column(

                    children: <Widget>[
                      
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text('Sign Here',style: TextStyle(
                           color:Colors.black54,
                           fontSize: getFontSize(context, 5) 
                          ),),
                          Signature(
                            controller: _signatureController,
                            height: 300,
                            backgroundColor: Colors.grey[200].withOpacity(0.3),
                          ),
                        ],
                      ),
                      Container(
                        child: bookingForm(context),
                      ),

                      Padding(
                        padding: EdgeInsets.all(10.0),

                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                                              child: FlatButton(
                                  child: Padding(
                                    padding:EdgeInsets.symmetric(vertical:14.0),
                                    child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "AVENIRLTSTD",
                          fontSize: getFontSize(context,2),
                        ),
                      ),
                                  ),
                                  color: Colors.blueAccent,
                                  onPressed: () async  {

                                    if (_signatureController.isNotEmpty) {

                                       _formNKey.currentState.saveAndValidate();
                                      var data = await _signatureController.toPngBytes();

                                      generatePdf(data,_formNKey.currentState.value["payment_paid"].toString());

                                    }
                                    else
                                      {
                                        Fluttertoast.showToast(
                                            msg: "Signature Required",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: getFontSize(context,-2)
                                        );
                                      }
                                  },
                                ),
                              ),
                              SizedBox(width: 8,),
                              Expanded(
                                                              child: FlatButton(
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(vertical:14.0),
                                    child: Text(
                        'CLEAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "AVENIRLTSTD",
                          fontSize: getFontSize(context,2),
                        ),
                      ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {
                                    nonCompliance=[false,false,false,false];
                                    compliant=[false,false,false];
                                    setState(() => _signatureController.clear());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),



    );

  }
  FormBuilder bookingForm(BuildContext context) {

    return FormBuilder(
        key: _formNKey,

        initialValue: {
          "payment_paid": "No",
        },

        child:Padding(

          padding: const EdgeInsets.all(8.0),
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

                  if(category=='compliant')Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,

                    children:[
                      Text("The Applicable Barrier Standard Applies under:",textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                    CheckboxListTile(
      title: const Text('Division 2 of Part 9A of the Building Regulations 2018'),
      value: compliant[0],
      onChanged: (bool value) {
        setState(() {
         compliant[0]=value;
        });}),
        CheckboxListTile(
      title: const Text('Relevant deemed to satisfy provisions of the BCA'),
      value: compliant[1],
      onChanged: (bool value) {
        setState(() {
         compliant[1]=value;
        });}),
        CheckboxListTile(
      title: const Text('A Performance Solution in accordance with the BCA'),
      value: compliant[2],
      onChanged: (bool value) {
        setState(() {
         compliant[2]=value;
        });})
                  ]),
                  if(category=='non-compliant')Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,

                    children:[
                      Text("This certificate of pool and spa barrier non-compliance has been issued because",textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                    CheckboxListTile(
      title: const Text('In my opinion the barrier cannot or will not be made compliant with the applicable barrier standard within 60 days.'),
      value: nonCompliance[0],
      onChanged: (bool value) {
        setState(() {
         nonCompliance[0]=value;
        });}),
        CheckboxListTile(
      title: const Text('A written notice was provided to the owner in accordance with regulation 147ZG(1) or 147ZH(1) of the Building Regulations 2018 and the barrier was not made compliant within the time period specified in that notice.'),
      value: nonCompliance[1],
      onChanged: (bool value) {
        setState(() {
         nonCompliance[1]=value;
        });}),
        CheckboxListTile(
      title: const Text('In my opinion the barrier non-compliance poses a significant and immediate risk to life or safety.'),
      value: nonCompliance[2],
      onChanged: (bool value) {
        setState(() {
         nonCompliance[2]=value;
        });}),
        CheckboxListTile(
      title: const Text('In my opinion the barrier is non-compliant with the applicable barrier standard in one or more ways specified in regulation 147ZF(c) of the Building Regulations 2018.'),
      value: nonCompliance[3],
      onChanged: (bool value) {
        setState(() {
         nonCompliance[3]=value;
        });})
                  ]),
                  Text("Paid/Unpaid?",textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                  CustomFormBuilderRadio(
                    activeColor: Colors.blueAccent,
                    decoration: buildInputDecoration(context,
                        "Has the inspection fee payment been made?", "yes or no").copyWith(
                         enabledBorder: InputBorder.none,
                         focusedBorder: InputBorder.none,
                         focusedErrorBorder: InputBorder.none,
                         errorBorder: InputBorder.none
                        ),
                    attribute: "payment_paid",
                    validators: [FormBuilderValidators.required()],
                    options: ["Yes", "No"]
                        .map((lang) => FormBuilderFieldOption(value: lang))
                        .toList(growable: false),
                  ),


                  sizedbox,



                ],
              ),
            )

        ),

        sizedbox,

      ],
    );
  }
}



