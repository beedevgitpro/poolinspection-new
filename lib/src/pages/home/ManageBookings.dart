import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/home_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/src/elements/drawer.dart';
import 'package:poolinspection/src/models/route_argument.dart';
import 'package:poolinspection/src/pages/booking/prefilbooking.dart';
import 'package:poolinspection/src/pages/inspection/inspectionheadinglist.dart';
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:strings/strings.dart';


class ManageBookingWidget extends StatefulWidget {

  final RouteArgumentHome routeArgument;
  ManageBookingWidget({Key key, this.routeArgument});


  @override
  _ManageBookingWidgetState createState() => _ManageBookingWidgetState();
}

class _ManageBookingWidgetState extends StateMVC<ManageBookingWidget> {
  HomeController _homeController;
  int ax=0;
  var differencedate;
  int userID;
  String getPaymentMessage;
  bool filter = false;
  _ManageBookingWidgetState() : super(HomeController()) {
    _homeController = controller;
  }



  @override
  void initState() {


    userRepo.token="beedev";

    if (widget.routeArgument == null) { //this condition will run just after drawer dashboard button press
      print("afterdrawerrefresh");

      _homeController.fetchData();

    } else {            //this condition will run just after login //here sqlite inspection dashboard data listing will go.
      print("afterlogin");
      _homeController.dashBoardBloc(widget.routeArgument.id).then((onValue) {
        setState(() {


          _homeController.listdata = onValue;
        });
      });
    }
    super.initState();
    // if(userRepo.currentUser.isPasswordChange ==null || userRepo.currentUser.isPasswordChange == 0) {
    //     Navigator.of(context).pushReplacementNamed('/UpdatePassword');
    //   }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        drawer: drawerData(
            context,
            widget.routeArgument == null
                ? userRepo.user.rolesManage
                : widget.routeArgument.role),
        key: _homeController.scaffoldKey,
        backgroundColor: config.Colors().scaffoldColor(1),
        appBar: AppBar(
          title: Text("Manage Bookings",
              style: TextStyle(
                  fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",
                  // fontWeight: FontWeight.bold,
                  color: Color(0xff222222))),
          centerTitle: true,
          leading: 
          IconButton(
                icon: Icon(
                  Icons.menu,
                  color: config.Colors().secondColor(1),
                ),
                onPressed: () => _homeController.scaffoldKey.currentState.openDrawer()),
          actions: <Widget>[
            Image.asset(
            "assets/img/app-iconwhite.jpg",
    
            fit: BoxFit.fitWidth,
          ),
          ],
        ),
        body:   _homeController.listdata == null
              ? Center(
            child: CircularProgressIndicator(),
          )
              : RefreshIndicator(
              onRefresh: refreshId,
              child:  buildColumn(context, _homeController.listdata)),

    );
  }

  Future refreshId() async {
    setState(() {
      _homeController.fetchData();
    });
  }

  Widget buildColumn(BuildContext context, data) {

   print("xmh="+data['newlist'].length.toString());
    return Column(children: <Widget>[
          SizedBox(height: 10,),

      data['newlist'].length==0 &&data['reinspection_list'].length==0?Center(
        child: Align(
          alignment: Alignment.center,
          child:  Padding(
            padding:  EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*0.4, 0, 0),
            child:Text("No Bookings Found",
                style: TextStyle(
                    fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSD",
                    fontWeight: FontWeight.normal,
                    // fontWeight: FontWeight.bold,
                    color: Color(0xff000000))),
          ),
        ),
      ):Align(
       alignment: Alignment.topLeft,
       child:  Padding(
         padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
         child:Text("Inspection List",
             style: TextStyle(
                 fontSize: getFontSize(context,2),
                 fontFamily: "AVENIRLTSD",
                 fontWeight: FontWeight.w700,
                 // fontWeight: FontWeight.bold,
                 color: Color(0xff000000))),
       ),
     ),
            buildContainerInProgress(context, 1, data['newlist']+ data['reinspection_list']),


          ]);

  }

  Widget buildContainerInProgress(BuildContext context, int i, data) {
    print(data[i]);

    return Expanded( //i removed app height.context and uses expanded in case of some error in future lets do something .
      child: Container(
          padding: EdgeInsets.all(10),
          // certificate_generated_data
          // color: Colors.red,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                MediaQuery.of(context).size.width<=600
                      ? SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5,),
                            ListView.builder(

                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {

                               
                                DateTime date = DateTime.now();
                                DateTime mondaydateofcurrentdate=DateTime.now().subtract(new Duration(days: date.weekday-1));
                                DateTime bookingDate = DateTime.parse("${data[index]['booking_date_time'].toString().substring(0,10)} "+"00:00:00.000z");
                                DateTime mondayofbookingDate=DateTime.parse("${data[index]['booking_date_time'].toString().substring(0,10)} "+"00:00:00.000z").subtract(new Duration(days: bookingDate.weekday-1));
                                differencedate = mondayofbookingDate.difference(mondaydateofcurrentdate).inDays;
                                return InkWell(
                                  onTap: () => data[index]['is_compliant'] == 3 ||
                                      data[index]['is_confirm'] == 1
                                      ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InspectionHeadingList(
                                              predata: data[index],
                                              bookingid: data[index]['id'])))
                                      : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PreliminaryWidget(data[index]['id'])),
                                  ),

                                  child:  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(

                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(

                                              child:Text(capitalize("${data[index]['owner_name']}"),
                                                  style: TextStyle(
                                                      fontSize: getFontSize(context,2),
                                                      fontFamily: "AVENIRLTSTD",
                                                      // fontWeight: FontWeight.bold,
                                                      color: Color(0xff000000))),
                                              padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                                            ) ,
                                            Padding(

                                              child:     Row(

                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                       Icon(Icons.home,color: Color(0xff999999),size: 17,),
                                                    SizedBox(width: 5,),
                                                    Flexible(
                                                      child: Text("${data[index]['owner_address']}", style: TextStyle(
                                                          fontFamily: "AVENIRLTSTD",
                                                          fontSize: getFontSize(context,-1),
                                                          color: Color(0xff999999),
                                                          fontWeight: FontWeight.normal),),
                                                    )
                                                  ]
                                              ),
                                              padding: const EdgeInsets.all(4.0),
                                            ) ,
                                            Padding(

                                              child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[

                                                    Icon(Icons.date_range,color: Color(0xff999999),size: 15,),
                                                    SizedBox(width: 5,),
                                                    Text(DateFormat("dd-MM-yyyy").format(DateTime.parse("${data[index]['booking_date_time'].toString().substring(0,10)} "+"00:00:00.000z")).toString(), style: TextStyle(
                                                        fontFamily: "AVENIRLTSTD",
                                                        fontSize: getFontSize(context,-2),
                                                        color: Color(0xff999999),
                                                        fontWeight: FontWeight.normal),),
                                                         ]
                                              ),
                                              padding: const EdgeInsets.all(4.0),
                                            ) ,
                                            Padding(

                                              child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[

                                                    Icon(Icons.phone,color: Color(0xff999999),size: 16,),
                                                    SizedBox(width: 5,),

                                                    Text("${data[index]['phonenumber']}", style: TextStyle(
                                                        fontFamily: "AVENIRLTSTD",
                                                        fontSize: getFontSize(context,-2),
                                                        color: Color(0xff999999),
                                                        fontWeight: FontWeight.normal),),
                                                  ]
                                              ),
                                              padding: const EdgeInsets.all(2.0),
                                            ) ,
                                            Padding(
                                              padding: new EdgeInsets.fromLTRB(4,4, 4,4), child:Card(
                                              
                                              color:data[index]['certificate_generated_data']==null?Colors.amber[600]:Color(0xff20c67e),
                                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                              child:Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  data[index]['certificate_generated_data']==null?"Upcoming".toUpperCase():"Completed".toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: getFontSize(context,-4),
                                                      color: Color(0xffFFFFFF), fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.bold),
                                                ),
                                              ),


                                            ),
                                            ),

                                            
                                          ]
                                      ),
                                    ),

                                  ),
                                );


                              },

                            ),


                          ]

                      )
                  )
                      :SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            callAX(),
                            Card(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                           Padding(
                             padding: EdgeInsets.all(12.0),
                             child:  Row(
                                 mainAxisSize: MainAxisSize.max,
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child:Text("#", style: TextStyle(
                                      fontFamily: "AVENIRLTSTD",
                                      fontSize: getFontSize(context,2),
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.w800),),
                                ),

                       Expanded(child:Text("Owner's Name & Address", style: TextStyle(
                           fontFamily: "AVENIRLTSTD",
                           fontSize: getFontSize(context,2),
                           color: Color(0xff000000),
                           fontWeight: FontWeight.w800),) ,flex: 2,),

                       Expanded(
                         child:  Align(child: Text("Date/Time", style: TextStyle(
                             fontFamily: "AVENIRLTSTD",
                             fontSize: getFontSize(context,2),
                             color: Color(0xff000000),
                             fontWeight: FontWeight.w800),),alignment: Alignment.center,),flex: 2,
                       ),

                       Expanded(child:Align(child: Text("Contact", style: TextStyle(
                           fontFamily: "AVENIRLTSTD",
                           fontSize: getFontSize(context,2),
                           color: Color(0xff000000),
                           fontWeight: FontWeight.w800),),alignment: Alignment.center,),flex: 1,),


                                 ]
                             ),
                           ),
                             Padding(
                    padding: EdgeInsets.fromLTRB(5,0,5,10),
                  child: Divider(color: Colors.grey,thickness: 1,),
                ),
                            ListView.builder(

                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {


                                
                                DateTime date = DateTime.now();
                                DateTime mondaydateofcurrentdate=DateTime.now().subtract(new Duration(days: date.weekday-1));
                                DateTime bookingDate = DateTime.parse("${data[index]['booking_date_time'].toString().substring(0,10)} "+"00:00:00.000z");
                                DateTime mondayofbookingDate=DateTime.parse("${data[index]['booking_date_time'].toString().substring(0,10)} "+"00:00:00.000z").subtract(new Duration(days: bookingDate.weekday-1));
                                print("errorinbookingdate="+bookingDate.toString());

                                differencedate = mondayofbookingDate.difference(mondaydateofcurrentdate).inDays;

//                                print("qxcurrentday=${date.weekday}");
//                                print("qxmondayofcurrentdate="+mondaydateofcurrentdate.toString());
//                                print("qxmondayofbookingdate="+mondayofbookingDate.toString());
//                                print("qxbookingday=${bookingDate.weekday}");
//                                print("qxcurrentdate=$date");
//                                print("qxbookingdate=$bookingDate");
//                                print("lqxdifference=$differencedate");
                                // print(data[index]['is_confirm']);
                                return InkWell(
                                  onTap: () {
                                    print("goku"+data[index]['booking_time']);
                                    data[index]['is_compliant'] == 3 ||
                                        data[index]['is_confirm'] == 1
                                        ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InspectionHeadingList(
                                                    predata: data[index],
                                                    bookingid: data[index]['id'])))
                                        : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PreliminaryWidget(
                                                  data[index]['id'])),
                                    );
                                  },

                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: <Widget>[

                                        Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[

                                              Expanded(child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[

                                                    Text((++ax).toString(), style: TextStyle(
                                                        fontFamily: "AVENIRLTSTD",
                                                        fontSize: getFontSize(context,3),
                                                        color: Color(0xff000000),
                                                        fontWeight: FontWeight.normal),),

                                                    Text("",maxLines: 2, style: TextStyle(
                                                        fontFamily: "AVENIRLTSTD",
                                                        fontSize: getFontSize(context,0),
                                                        color: Color(0xffffffff),
                                                        fontWeight: FontWeight.w800),),

                                                    Text("", style: TextStyle(
                                                        fontFamily: "AVENIRLTSTD",
                                                        fontSize: getFontSize(context,0),
                                                        color: Color(0xffffffff),
                                                        fontWeight: FontWeight.w800),),

                                                    Text("", style: TextStyle(
                                                        fontFamily: "AVENIRLTSTD",
                                                        fontSize: getFontSize(context,0),
                                                        color: Color(0xffffffff),
                                                        fontWeight: FontWeight.w800),),
                                                    Text("", style: TextStyle(
                                                        fontFamily: "AVENIRLTSTD",
                                                        fontSize: getFontSize(context,0),
                                                        color: Color(0xffffffff),
                                                        fontWeight: FontWeight.w800),),
                                                    SizedBox(height: 15,),


                                                  ]
                                              ) ,flex: 1,),
                                              Expanded(child:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[

                                                    Text("${data[index]['owner_land']}", style: TextStyle(
                                                        fontFamily: "AVENIRLTSTD",
                                                        fontSize: getFontSize(context,2),
                                                        color: Color(0xff000000),
                                                        fontWeight: FontWeight.w800),),

                                                    SizedBox(height: 10,),
                                                    Text("${data[index]['street_road']} ${data[index]['city_suburb']} ${data[index]['postcode']}", style: TextStyle(
                                                        fontFamily: "AVENIRLTSTD",
                                                        fontSize: getFontSize(context,2),
                                                        color: Color(0xff000000),
                                                        fontWeight: FontWeight.normal),),

                                                    SizedBox(height: 10,),
                                                    data[index]['is_compliant'] == 3 || data[index]['is_confirm'] == 1? Padding(
                                                      padding: new EdgeInsets.fromLTRB(4,4, 4,4), child:new RaisedButton(
                                                      onPressed:() {

                                                      },
                                                      color:Color(0xff20c67e),
                                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                                      child:Text(
                                                        "BOOKING CONFIRMED",
                                                        style: TextStyle(
                                                            fontSize: getFontSize(context,-5),
                                                            color: Color(0xffFFFFFF), fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.normal),
                                                      ),


                                                    ),
                                                    ):Padding(
                                                      padding: new EdgeInsets.fromLTRB(4,4, 4,4), child:new RaisedButton(
                                                      onPressed:() {

                                                      },
                                                      color:Colors.redAccent,
                                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                                      child:Text(
                                                        "BOOKING NOT CONFIRMED",
                                                        style: TextStyle(
                                                            fontSize: getFontSize(context,-5),
                                                            color: Color(0xffFFFFFF), fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.normal),
                                                      ),


                                                    ),

                                                    ),

                                                    SizedBox(height: 10,),


                                                  ]
                                              ),flex: 2,) ,
                                              Expanded(child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
//data[index]['booking_date_time'].toString().substring(8,10)+":"+data[index]['booking_date_time'].toString().substring(5,7)+":"+
//                                                    Text(DateFormat.yMMMMd('en_US').format(DateTime.parse("${data[index]['booking_date_time']} ".substring(0,10))).toString(), style: TextStyle(
                                                    Align(

                                                      child: Text(DateFormat("dd-MM-yyyy").format(DateTime.parse("${data[index]['booking_date_time'].toString().substring(0,10)} "+"00:00:00.000z")).toString(), style: TextStyle(
                                                          fontFamily: "AVENIRLTSTD",
                                                          fontSize: getFontSize(context,2),
                                                          color: Color(0xff000000),
                                                          fontWeight: FontWeight.normal),),
                                                    ),

                                                    SizedBox(height: 8,),
                                                    Text(DateFormat.jm().format(DateTime.parse("2012-07-07 "+"${data[index]['booking_time']}"))+"   ",style: TextStyle(
                                                        fontFamily: "AVENIRLTSTD",
                                                        fontSize: getFontSize(context,2),
                                                        color: Color(0xff000000),
                                                        fontWeight: FontWeight.normal),),

                                                    SizedBox(height: 10,),
                                                    data[index]['percentage'] == 0? Padding(
                                                      padding: new EdgeInsets.fromLTRB(4,4, 4,4), child:new RaisedButton(
                                                      onPressed:() {

                                                      },
                                                      color:Colors.blueAccent,
                                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                                      child:Text(
                                                        "NEW JOB  ",
                                                        style: TextStyle(
                                                            fontSize: getFontSize(context,-5),
                                                            color: Color(0xffFFFFFF), fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.normal),
                                                      ),


                                                    ),
                                                    ):Padding(
                                                      padding: new EdgeInsets.fromLTRB(4,4, 4,4), child:new RaisedButton(
                                                      onPressed:() {

                                                      },
                                                      color:Colors.orange,
                                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                                      child:Text(
                                                        "ONGOING INSPECTION",
                                                        style: TextStyle(
                                                            fontSize: getFontSize(context,-5),
                                                            color: Color(0xffFFFFFF), fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.normal),
                                                      ),


                                                    ),

                                                    ),
                                                    SizedBox(height: 6,),
                                                  ]
                                              ),flex: 2,),
                                              Expanded(child:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[

                                                    Text("${data[index]['phonenumber']}", style: TextStyle(
                                                        fontFamily: "AVENIRLTSTD",
                                                        fontSize: getFontSize(context,2),
                                                        color: Color(0xff000000),
                                                        fontWeight: FontWeight.normal),),

                                                    Text("", style: TextStyle(
                                                        fontFamily: "AVENIRLTSTD",
                                                        fontSize: getFontSize(context,2),
                                                        color: Color(0xffffffff),
                                                        fontWeight: FontWeight.normal),),

                                                    SizedBox(height: 80,),
                                                  ]
                                              ),flex: 1,),

                                            ]
                                        ),
                                        Divider(color: Colors.grey,thickness: 1,)
                                      ],
                                    )

                                  ),



                                );


                              },

                            ),

                            ]
                      ),
                      ),
                            ),
                            SizedBox(height: 20,),


                          ]

                      )



)
          )
      ),
    );
  }

  
  Widget callAX()
  {
    ax=0;
    return Container();
  }
}
