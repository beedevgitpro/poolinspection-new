import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/elements/drawer.dart';
import 'package:poolinspection/src/elements/inputdecoration.dart';
import 'package:poolinspection/src/models/getcertificatemodel.dart';
import 'package:poolinspection/src/models/selectCompliantOrNotice.dart';
import 'package:poolinspection/src/helpers/sharedpreferences/userpreferences.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/models/route_argument.dart';
import 'package:poolinspection/src/elements/custom_progress_dialog.dart';
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;
import 'package:poolinspection/constants.dart';





class SelectNoticeOrNonCompliant extends StatefulWidget {
  final String bookingId;
  SelectNoticeOrNonCompliant(this.bookingId);

  @override
  _SelectNoticeOrNonCompliantState createState() => _SelectNoticeOrNonCompliantState(bookingId);

}
class _SelectNoticeOrNonCompliantState extends State<SelectNoticeOrNonCompliant> {


  bool isLoading = false;
  ProgressDialog pr;
  String bookingId;
  bool progressCircular = false;
  GlobalKey<FormBuilderState> _formNKey =  GlobalKey<FormBuilderState>();
  List<ListElement> certificate =new List<ListElement>();


 int userId;
  String categor;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _SelectNoticeOrNonCompliantState(bookingId)
  {
   this.bookingId=bookingId;

  }


  @mustCallSuper
  @override
  void initState() {

     pr = ProgressDialog(context,isDismissible: false);



    UserSharedPreferencesHelper.getUserDetails().then((user) {
      setState(() {
        // print("${user.userdata.inspector.firstName } controller user id");
        userId=user.id;
   print("useruser="+bookingId.toString());

      });
    });
  }




  Future selectnoncompliantornotice(String selection,String bookingDate,String bookingTime) async{

   var response;
    await pr.show();
   
    try
    {
      response = await http.post(
          '$baseUrl/beedev/confirm_non_compliant',
          body: {'booking_id': bookingId.toString(), 'booking_date_time': bookingDate.substring(0,10).toString(),'booking_time':bookingTime.substring(11,16).toString(),'compliant_btn':selection}
      );
      print("helohelo"+response.body.toString());
      SelectNonCompliantOrNotice selectNonCompliantOrNotice= selectNonCompliantOrNoticeFromJson(response.body);


      if(selectNonCompliantOrNotice.error.toString()=="0")
      {

        await pr.hide();
        if(selectNonCompliantOrNotice.status.toString()=="notice") {
          Navigator.pushNamedAndRemoveUntil(context,'/Home',(Route<dynamic> route) => false);
          Navigator.of(context).pushNamed("/Certificate",
           arguments: RouteArgumentCertificate(
               id: 4, heroTag:"Notice of Improvement"));
        }
        else
        {
          Navigator.pushNamedAndRemoveUntil(
              context, '/Home', (Route<dynamic> route) => false);
          Navigator.of(context).pushNamed("/Certificate",
              arguments: RouteArgumentCertificate(
                  id: 3, heroTag: "Non Compliant"));
        }
      }
      else
      {
        await pr.hide();
        Fluttertoast.showToast(
            msg: response.body.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: getFontSize(context,-2)
        );
      }
    }
  catch(e)
    {
      await pr.hide();
      print("errorinselectfrombackend"+e.toString());
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
        // endDrawer: drawerData(context, userRepo.user.rolesManage),
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: config.Colors().secondColor(1),
              ),
              onPressed: () => Navigator.pop(context)),
          title: Align(alignment: Alignment.center,
            child:Text("Select Option",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: "AVENIRLTSTD",
                fontSize: getFontSize(context,4),
                color: Color(0xff222222),
              ),
            ),

          ),
          actions: <Widget>[
            Image.asset(
            "assets/img/app-iconwhite.jpg",
            // fit: BoxFit.cover,
            fit: BoxFit.fitWidth,
          )
            // IconButton(
            //     icon: Icon(Icons.menu),
            //     onPressed: () => _scaffoldKey.currentState.openEndDrawer())
          ],
        ),

        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: bookingForm(context),
              ),
              Align(
                alignment: Alignment.center,
                child:  Column(

                  children: <Widget>[
                    Container(

                      alignment: Alignment.bottomCenter,
                      child: Container(

                        child: MaterialButton(
                             
                            minWidth: MediaQuery.of(context).size.width/2,
                            child:Padding(
                              padding: EdgeInsets.all(10.0),
                              child:  Text(
                                "Non-Compliant",
                                style: TextStyle(color: Theme.of(context).primaryColor,fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,0)),
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                                  if(_formNKey.currentState.saveAndValidate())
                                  selectnoncompliantornotice("non-compliant",_formNKey.currentState.value['booking_date_time'].toString(),_formNKey.currentState.value['booking_time'].toString());

                            }
                        ),
                      ),
                    ),
                    SizedBox(height:10),
                    Container(

                      alignment: Alignment.bottomCenter,
                      child:Container(

                          child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width/2,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child:Text(
                                  "Notice of Improvement",
                                  style: TextStyle(color: Theme.of(context).primaryColor,fontFamily: "AVENIRLTSTD",fontSize: getFontSize(context,0)),
                                ),
                              ),
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                if(_formNKey.currentState.saveAndValidate())

                                {
                                  
                                  selectnoncompliantornotice("notice",_formNKey.currentState.value['booking_date_time'].toString(),_formNKey.currentState.value['booking_time'].toString());
                                }


                              }
                          )
                      ),
                    ),
                  ],

                ),
              )
            ],
          ),

        ),
    );


  }

  FormBuilder bookingForm(BuildContext context) {

    return FormBuilder(
        key: _formNKey,

        initialValue: {

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


                  Text("Requested Booking date of the Re-Inspection:",textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                      SizedBox(height:3),
                  FormBuilderDateTimePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 0)),
                    lastDate: DateTime.now().add(Duration(days: 60)),
                    style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),fontFamily: "AVENIRLTSTD",),

                    attribute: "booking_date_time",
                    validators: [FormBuilderValidators.required()],
                    inputType: InputType.date,
                    format:new DateFormat("dd-MM-yyyy"),
                    decoration: buildInputDecoration(
                        context,
                        "What is the requested booking date and time \nof the inspection? ",
                        "Select Date").copyWith(
                      hintStyle: TextStyle(color:Theme.of(context).accentColor),
                         enabledBorder: InputBorder.none,
                         focusedBorder: InputBorder.none,
                         focusedErrorBorder: InputBorder.none, 
                        ),
                  ),

                  sizedbox,
                  Text("Requested Booking time of the Re-Inspection:",textAlign: TextAlign.left,  style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff222222),
                      fontWeight: FontWeight.normal),),
                      SizedBox(height:3),
                  FormBuilderDateTimePicker(
                    style: TextStyle(color: Color(0xff222222),fontSize: getFontSize(context,2),fontFamily: "AVENIRLTSTD",),
                    attribute: "booking_time",
                    validators: [FormBuilderValidators.required()],
                    inputType: InputType.time,
                    format: new DateFormat.jm(),
                    decoration: buildInputDecoration(
                        context,
                        "What is the requested booking time of the inspection? ",
                        "Select Time").copyWith(
                      hintStyle: TextStyle(color:Theme.of(context).accentColor),
                         enabledBorder: InputBorder.none,
                         focusedBorder: InputBorder.none,
                         focusedErrorBorder: InputBorder.none, 
                        ),


                    //  initialTime: TimeOfDay(hour: 8, minute: 0),
                    // initialValue: DateTime.now(),
                    // readonly: true,
                  ),


                  sizedbox,


                  SizedBox(height: 20,),

                ],
              ),
            )

        ),

        sizedbox,

      ],
    );
  }


}
