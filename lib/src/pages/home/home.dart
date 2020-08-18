import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/home_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/src/elements/BlockButtonWidget.dart';
import 'package:poolinspection/src/elements/drawer.dart';
import 'package:poolinspection/src/helpers/connectivity.dart';
import 'package:poolinspection/src/helpers/sharedpreferences/userpreferences.dart';
import 'package:poolinspection/src/models/route_argument.dart';
import 'package:poolinspection/src/models/selectCompliantOrNotice.dart';
import 'package:poolinspection/src/pages/booking/prefilbooking.dart';
import 'package:poolinspection/src/pages/inspection/inspectionheadinglist.dart';
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/elements/custom_progress_dialog.dart';
import 'package:poolinspection/constants.dart';
import 'package:strings/strings.dart';

class HomeWidget extends StatefulWidget {
  final RouteArgumentHome routeArgument;
  HomeWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;
  int ax = 0;
  String inspectionType;
  bool _isExpanded=true;
  var differencedate;
  String ownerName='',ownerAddress='',jobNo='';
  int isReinspection;
  bool filtered = false;
  DateTime selectedDate;
  int userID;
  bool isOnline = false;
  String getPaymentMessage;
  var offlineListData;
  bool filter = false;
  ConnectionStatusSingleton connectionStatus;
  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days:365)),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).accentColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future checkPaymentDetail() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context);
    try {
      await pr.show();

      await UserSharedPreferencesHelper.getUserDetails().then((user) {
        setState(() {
          userID = user.id;
        });
      });
      print("useruseruser" + userID.toString());
      final response = await http
          .get(
              '$baseUrl/beedev/check_payment_details/$userID')
          ;
      print("useruseruser2" + response.body.toString());
      SelectNonCompliantOrNotice checkBankOrCardDetail =
          selectNonCompliantOrNoticeFromJson(response.body);

      if (checkBankOrCardDetail.status == "pass") {
        await pr.hide();
        if (checkBankOrCardDetail.messages == "Card & Bank Details Present") {
          Navigator.of(context).pushNamed('/BookingForm');
        } else if (checkBankOrCardDetail.messages == "Card detail not found") {
          Navigator.of(context).pushNamed('/AddCardDetail');
        } else {
          Navigator.of(context).pushNamed('/BankDetails');
        }
        getPaymentMessage = checkBankOrCardDetail.messages.toString();

        setState(() {
        });
      } else {
        await pr.hide();
        setState(() {
        });
        Fluttertoast.showToast(
            msg: response.body.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: getFontSize(context,-2));
      }
    } on TimeoutException catch (_) {
      await pr.hide();
      Fluttertoast.showToast(
          msg: "Not Connected to the Internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2));
    } on SocketException catch (_) {
      await pr.hide();
      Fluttertoast.showToast(
          msg: "Not Connected to the Internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2));
    } catch (e) {
      await pr.hide();
      print(e.toString());
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2));
    }
  }

  Future callSavedHomeListCheckingInternet() async {
    await connectionStatus.checkConnection().then((val) {
      val ? loadData() : print("not connected in home");
      isOnline = val;
    });
  }

  Future checkConnection() async {
    await connectionStatus.checkConnection().then((val) {
      val ? loadDataDash() : print("not connected afterlogin");
      isOnline = val;
    });
  }

  void filterAlert() {

  }
  @override
  void initState() {
    super.initState();
    selectedDate = null;
    connectionStatus = ConnectionStatusSingleton.getInstance();

    userRepo.token = "beedev";

    if (widget.routeArgument == null) {
      print("afterdrawerrefresh");
      _con.readCounter().then((onValue) {
        setState(() {
          offlineListData = json.decode(onValue.toString());
        });
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        callSavedHomeListCheckingInternet();
      });
    } else {
      print("afterlogin");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        checkConnection();
      });
    }
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      connectionStatus.checkConnection().then((val) {
        val ? loadData() : print("not connected");
        isOnline = val;
      });
    });
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 0), onDoneLoading);
  }

  Future<Timer> loadDataDash() async {
    return new Timer(Duration(seconds: 0), callDash);
  }

  onDoneLoading() async {
    refreshId();
  }

  callDash() async {
    // print(currentUser.token2fa);
    _con.dashBoardBloc(widget.routeArgument.id).then((onValue) {
      setState(() {
        print("onValuehome=" + onValue.toString());
        _con.listdata = onValue;

        // if (_con.listdata == 1) {
        //   Navigator.of(_con.scaffoldKey.currentContext)
        //       .pushReplacementNamed('/Login');
        // }
      });
    });
    refreshId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerData(
          context,
          widget.routeArgument == null
              ? userRepo.user.rolesManage
              : widget.routeArgument.role),
      key: _con.scaffoldKey,
      backgroundColor: config.Colors().scaffoldColor(1),
      appBar: AppBar(
        title: Text("Dashboard",
            style: TextStyle(
                fontSize: getFontSize(context,3),
                fontFamily: "AVENIRLTSTD",
                // fontWeight: FontWeight.bold,
                color: Color(0xff222222))),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: config.Colors().secondColor(1),
            ),
            onPressed: () => _con.scaffoldKey.currentState.openDrawer()),
        actions: <Widget>[
          Image.asset(
            "assets/img/app-iconwhite.jpg",
            // fit: BoxFit.cover,
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
      body: _con.listdata == null
          ? Center(
              child: isOnline
                  ? CircularProgressIndicator()
                  : offlineListData == null
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.redAccent,
                        )
                      : RefreshIndicator(
                          onRefresh: refreshOfflineId,
                          child: buildColumn(context, offlineListData)),
            )
          : RefreshIndicator(
              onRefresh: refreshId, child: buildColumn(context, _con.listdata)),
    );
    // : Text(_con.listdata.toString() ?? ""));
  }

//             future: dashBoardBloc(),
  Future refreshId() async {
    setState(() {
      _con.fetchData();
    });
  }

  Future refreshOfflineId() async {
    setState(() {
      _con.readCounter().then((onValue) {
        setState(() {
          offlineListData = json.decode(onValue.toString());
        });
      });
    });
  }

  Widget buildColumn(BuildContext context, data) {
    return data == 1
        ? Container()
        : GestureDetector(
        onPanDown: (_){
          FocusScope.of(context).requestFocus(FocusNode());
        },
                  child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:6.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            buildUpcomingInspections(context,
                                data['newlist']),
                            buildCompletedInspections(context,
                                data['reinspection_list']),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  Container(
                    width: double.infinity,
                    height: 70,
                    child: BlockButtonWidget(
                        text: Text(
                          "Book Enquiry",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: getFontSize(context,2),
                            fontWeight: FontWeight.bold,
                            fontFamily: "AVENIRLTSTD",
                          ),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () async {
                          checkPaymentDetail();
                        }
                        
                        ),
                  ),
                ]),
        );
  }
  Widget buildUpcomingInspections(BuildContext context, data) {
    print(data.length);
    return GestureDetector(
        onPanDown: (_){
          FocusScope.of(context).requestFocus(FocusNode());
        },
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:4.0,vertical: 10),
              child: Text("Upcoming Inspections",
                  style: TextStyle(
                      fontSize: getFontSize(context,3),
                      fontFamily: "AVENIRLTSD",
                      fontWeight: FontWeight.w700,
                      // fontWeight: FontWeight.bold,
                      color: Color(0xff000000))),
            ),
            data.isEmpty?
            Center(
              child: Text('No Upcoming Inspections',style: TextStyle(
                        fontSize: getFontSize(context,-1),
                        fontFamily: "AVENIRLTSD",
                        fontWeight: FontWeight.w500,
                        
                        color: Colors.black54)),
            )
            :
            MediaQuery.of(context).size.width <= 600
                ? mobileEntryList(data)
                : tabletEntryList(data),
          ],
        ),
      ),
    );
  }

  Widget buildCompletedInspections(BuildContext context, data) {
    return GestureDetector(
        onPanDown: (_){
          FocusScope.of(context).requestFocus(FocusNode());
        },
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0),
              child: data.isEmpty?
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title:Text('Completed Inspections',
                    style: TextStyle(
                        fontSize: getFontSize(context,3),
                        fontFamily: "AVENIRLTSD",
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),)
            :buildHeaderWithFilters(context),
            ),
            data.isEmpty?
            Center(
              child: Text('No Completed Inspections',style: TextStyle(
                        fontSize: getFontSize(context,-1),
                        fontFamily: "AVENIRLTSD",
                        fontWeight: FontWeight.w500,
                        
                        color: Colors.black54)),
            )
            :
            MediaQuery.of(context).size.width <= 600
                ? mobileEntryList(data,isCompleted: true)
                : tabletEntryList(data,isCompleted: true),
          ],
        ),
      ),
    );
  }

  Theme buildHeaderWithFilters(BuildContext context) {
    return Theme(
      data: ThemeData(
       dividerColor: Colors.transparent 
      ),
          child: ExpansionTile(
        initiallyExpanded: _isExpanded,
               onExpansionChanged: (value){
                 setState(() { _isExpanded=value;});
                 
               },
                trailing: Icon(
                  _isExpanded?Icons.close:Icons.search,
                  color: _isExpanded?Colors.redAccent:Theme.of(context).accentColor,
                ),
                tilePadding: EdgeInsets.all(0),
                title: Text('Completed Inspections',
                    style: TextStyle(
                        fontSize: getFontSize(context,3),
                        fontFamily: "AVENIRLTSD",
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
                children: [
                  ListTile(
                    leading: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextFormField(
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: getFontSize(context,-2),
                            ),
                            contentPadding: EdgeInsets.all(0),
                            hintText: 'Job No.'),
                            onChanged: (value){
                              jobNo=value;
                            },
                      ),
                    ),
                    title: Row(
                      children: [
                        Text('Job Type:  ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getFontSize(context,-2),
                                fontWeight: FontWeight.w700)),
                        Expanded(
                          child: Container(
                            child: DropdownButtonHideUnderline(
                                                        child: Container(
                                                          
                                                          decoration: BoxDecoration(border: Border(
                                                            bottom: BorderSide(color: Colors.black54)
                                                          )),
                                                          child: DropdownButton(
                                onChanged: (value) {
                                  inspectionType=value;
                                },
                                hint: Text('Any',
                                    style:
                                        TextStyle(color: Colors.black, fontSize: getFontSize(context,-2))),
                                value: inspectionType,
                                items: [
                                  DropdownMenuItem(
                                      child: Text('Inspection '), value: 'First Inspection'),
                                  DropdownMenuItem(
                                    child: Text('Re-Inspection '),
                                    value: 'Re-Inspection',
                                  )
                                ],
                                style: TextStyle(
                                    fontSize: getFontSize(context,-2),
                                    fontFamily: "AVENIRLTSD",
                                    
                                    color: Colors.black),
                              ),
                                                        ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    leading: Container(
                      width: MediaQuery.of(context).size.width * 0.34,
                      child: TextFormField(
                        onChanged: (value) {
                          ownerName=value;
                        },
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: getFontSize(context,-2),
                            ),
                            contentPadding: EdgeInsets.all(0),
                            hintText: 'Owner Name'),
                      ),
                    ),
                    trailing: Container(
                      width: MediaQuery.of(context).size.width * 0.53,
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: getFontSize(context,-2),
                            ),
                            
                            contentPadding: EdgeInsets.all(0),
                            hintText: 'Owner Address'),
                            onChanged:(value){
                              ownerAddress=value;
                            }
                      ),
                    ),
                  ),
                  ListTile(
                    
                    leading: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).accentColor,
                    ),
                    title: GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Text(
                        selectedDate!=null?DateFormat("dd-MM-yyyy").format(selectedDate):'Select Date',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getFontSize(context,-2),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    
                    title: Row(
                      children: [
                        FlatButton(
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              setState(() {
                                filtered=true;
                              });
                            },
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: getFontSize(context,-2),
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        FlatButton(
                            color: Colors.grey,
                            onPressed: () {
                              filtered=false;setState(() {selectedDate=null;ownerAddress=null;ownerName=null;inspectionType=null;});
                            },
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: getFontSize(context,-2),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
    );
  }

  Card tabletEntryList(data,{bool isCompleted=false}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      "#",
                      style: TextStyle(
                          fontFamily: "AVENIRLTSTD",
                          fontSize: getFontSize(context,2),
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Owner Details",
                      style: TextStyle(
                          fontFamily: "AVENIRLTSTD",
                          fontSize: getFontSize(context,2),
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w800),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Align(
                      child: Text(
                        "Date/Time",
                        style: TextStyle(
                            fontFamily: "AVENIRLTSTD",
                            fontSize: getFontSize(context,2),
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w800),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Align(
                      child: Text(
                        "Status",
                        style: TextStyle(
                            fontFamily: "AVENIRLTSTD",
                            fontSize: getFontSize(context,2),
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w800),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
             
              DateTime date = DateTime.now();
              DateTime mondaydateofcurrentdate =
                  DateTime.now().subtract(new Duration(days: date.weekday - 1));
              DateTime bookingDate = DateTime.parse(
                  "${data[index]['booking_date_time'].toString().substring(0, 10)} " +
                      "00:00:00.000");
              DateTime mondayofbookingDate = DateTime.parse(
                      "${data[index]['booking_date_time'].toString().substring(0, 10)} " +
                          "00:00:00.000")
                  .subtract(new Duration(days: bookingDate.weekday - 1));
              print("errorinbookingdate=" + bookingDate.toString());

              differencedate = mondayofbookingDate
                  .difference(mondaydateofcurrentdate)
                  .inDays;
                  if(filtered && isCompleted)
              if((ownerName.isNotEmpty&&!data[index]['owner_name'].toLowerCase().contains(ownerName.toLowerCase()))
              ||(selectedDate!=null&&selectedDate!=bookingDate)
              ||(ownerName.isNotEmpty&&!(data[index]['street_road']+" "+data[index]['postcode']+" "+data[index]['city_suburb']/*data[index]['owner_address']*/).toLowerCase().contains(ownerAddress.toLowerCase()))
              ||(jobNo.isNotEmpty&&!data[index]['id'].toLowerCase().contains(jobNo.toLowerCase()))
              ||(inspectionType!=null&&data[index]['inspection_type'].toString()!=inspectionType.toString()))
                                        return Container();
                  return  InkWell(
                      onTap: () {
                        data[index]['is_compliant'] == 3 ||
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
                              );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${index+1}",
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,3),
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            "",
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,0),
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            "",
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,0),
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            "",
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,0),
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w800),
                                          ),
                                         Text(
                                            "",
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,0),
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w800),
                                          ),
                                          
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ]),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            capitalize(
                                                "${data[index]['owner_name']}"),
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,2),
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${data[index]['owner_address']}",
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,2),
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.normal),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${data[index]['phonenumber']}",
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,2),
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            "",
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,0),
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            "",
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,0),
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Align(
                                            child: Text(
                                              DateFormat("dd-MM-yyyy")
                                                  .format(DateTime.parse(
                                                      "${data[index]['booking_date_time'].toString().substring(0, 10)} " +
                                                          "00:00:00.000z"))
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: "AVENIRLTSTD",
                                                  fontSize: getFontSize(context,2),
                                                  color: Color(0xff000000),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            DateFormat.jm().format(DateTime
                                                    .parse("2012-07-07 " +
                                                        "${data[index]['booking_time']}")) +
                                                "   ",
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,2),
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            "",
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,0),
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            "",
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,0),
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            "",
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,0),
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          
                                        ]),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          isCompleted?
                                          Padding(
                                                  padding:
                                                      new EdgeInsets.fromLTRB(
                                                          4, 4, 4, 4),
                                                  child: new RaisedButton(
                                                    onPressed: () {},
                                                    color: Theme.of(context).hintColor,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(5.0)),
                                                    child: Text(
                                                      "SUBMITTED",
                                                      style: TextStyle(
                                                          fontSize: getFontSize(context,-5),
                                                          color:
                                                              Color(0xffFFFFFF),
                                                          fontFamily:
                                                              "AVENIRLTSTD",
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                ):
                                          Padding(
                                  padding:  EdgeInsets.fromLTRB(4, 4, 4, 0),
                                  child:  RaisedButton(
                                    onPressed: () {},
                                    color: data[index]['is_confirm'] == 1?Theme.of(context).hintColor:Color(0xFFea5c44),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                             BorderRadius.circular(5.0)),
                                    child: Text(
                                      data[index]['is_confirm'] == 1?"Booking Confirmed".toUpperCase():"Booking Not Confirmed".toUpperCase(),
                                      style: TextStyle(
                                          fontSize: getFontSize(context,-5),
                                          color: Color(0xffFFFFFF),
                                          fontFamily: "AVENIRLTSTD",
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                          Text(
                                            "",
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,0),
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            "",
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,0),
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            "",
                                            style: TextStyle(
                                                fontFamily: "AVENIRLTSTD",
                                                fontSize: getFontSize(context,0),
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                    flex: 2,
                                  ),
                                ]),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                            )
                          ],
                        ),
                      ));
            },
          ),
        ]),
      ),
    );
  }

  ListView mobileEntryList(data,{bool isCompleted=false}) {
    
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        DateTime date = DateTime.now();
        DateTime mondaydateofcurrentdate =
            DateTime.now().subtract(new Duration(days: date.weekday - 1));
        DateTime bookingDate = DateTime.parse(
            "${data[index]['booking_date_time'].toString().substring(0, 10)} " +
                "00:00:00.000");
        DateTime mondayofbookingDate = DateTime.parse(
                "${data[index]['booking_date_time'].toString().substring(0, 10)} " +
                    "00:00:00.000")
            .subtract(new Duration(days: bookingDate.weekday - 1));
        differencedate =
            mondayofbookingDate.difference(mondaydateofcurrentdate).inDays;
           
            if(filtered && isCompleted)
              if((ownerName.isNotEmpty&&!data[index]['owner_name'].toLowerCase().contains(ownerName.toLowerCase()))
              ||(selectedDate!=null&&selectedDate!=bookingDate)
              ||(ownerName.isNotEmpty&&!(data[index]['street_road']+" "+data[index]['postcode']+" "+data[index]['city_suburb']/*data[index]['owner_address']*/).toLowerCase().contains(ownerAddress.toLowerCase()))
              ||(jobNo.isNotEmpty&&!data[index]['id'].toLowerCase().contains(jobNo.toLowerCase()))
              ||(inspectionType!=null&&data[index]['inspection_type'].toString()!=inspectionType.toString()))
                                        return Container();
        return  InkWell(
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
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            child:
                                Text(capitalize("${data[index]['owner_name']}"),
                                    style: TextStyle(
                                        fontSize: getFontSize(context,0),
                                        fontFamily: "AVENIRLTSTD",
                                        // fontWeight: FontWeight.bold,
                                        color: Color(0xff000000))),
                            padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                          ),
                          Padding(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  //   Icon((IconData(0xe809, fontFamily: _kFontFam)),size: 12,),
                                  Icon(
                                    Icons.home,
                                    color: Color(0xff999999),
                                    size: 17,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "${data[index]['owner_address']}",
                                      style: TextStyle(
                                          fontFamily: "AVENIRLTSTD",
                                          fontSize: getFontSize(context,-3),
                                          color: Color(0xff999999),
                                          fontWeight: FontWeight.normal),
                                    ),
                                  )
                                ]),
                            padding: const EdgeInsets.all(4.0),
                          ),
                          Padding(
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Color(0xff999999),
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    DateFormat("dd-MM-yyyy")
                                        .format(DateTime.parse(
                                            "${data[index]['booking_date_time'].toString().substring(0, 10)} " +
                                                "00:00:00.000z"))
                                        .toString(),
                                    style: TextStyle(
                                        fontFamily: "AVENIRLTSTD",
                                        fontSize: getFontSize(context,-3),
                                        color: Color(0xff999999),
                                        fontWeight: FontWeight.normal),
                                  ),
                                ]),
                            padding: const EdgeInsets.all(4.0),
                          ),
                          Padding(
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.phone,
                                    color: Color(0xff999999),
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${data[index]['phonenumber']}",
                                    style: TextStyle(
                                        fontFamily: "AVENIRLTSTD",
                                        fontSize: getFontSize(context,-3),
                                        color: Color(0xff999999),
                                        fontWeight: FontWeight.normal),
                                  ),
                                ]),
                            padding: const EdgeInsets.all(2.0),
                          ),
                          isCompleted? Padding(
                                  padding: new EdgeInsets.fromLTRB(4, 4, 4, 0),
                                  child: new RaisedButton(
                                    onPressed: () {},
                                    color: Theme.of(context).hintColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0)),
                                    child: Text(
                                      "SUBMITTED",
                                      style: TextStyle(
                                          fontSize: getFontSize(context,-5),
                                          color: Color(0xffFFFFFF),
                                          fontFamily: "AVENIRLTSTD",
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ):
                                
                                Padding(
                                  padding: new EdgeInsets.fromLTRB(4, 4, 4, 0),
                                  child: new RaisedButton(
                                    onPressed: () {},
                                    color: data[index]['is_confirm'] == 1?Theme.of(context).hintColor:Color(0xFFea5c44),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0)),
                                    child: Text(
                                      data[index]['is_confirm'] == 1?"Confirmed".toUpperCase():"Not Confirmed".toUpperCase(),
                                      style: TextStyle(
                                          fontSize: getFontSize(context,-5),
                                          color: Color(0xffFFFFFF),
                                          fontFamily: "AVENIRLTSTD",
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                          
                        ]),
                  ),
                ),
              );
      },
    );
  }

  
}
