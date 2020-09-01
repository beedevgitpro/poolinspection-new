import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/inspection_controller.dart';
import 'package:poolinspection/src/elements/inputdecoration.dart';
import 'package:poolinspection/src/elements/radiobutton.dart';
import 'package:poolinspection/src/helpers/connectivity.dart';
import 'package:poolinspection/src/models/offlinedatamodel.dart';
import 'package:poolinspection/src/models/questionmodel.dart';
import 'package:poolinspection/src/models/selectCompliantOrNotice.dart';
import 'package:poolinspection/src/elements/custom_progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:poolinspection/constants.dart';
import 'inspectionquestionslist.dart';



class InspectionHeadingList extends StatefulWidget {
  final predata;
  final int bookingid;


  InspectionHeadingList({this.predata, this.bookingid});
  @override
  _InspectionHeadingListState createState() => _InspectionHeadingListState();
}

class _InspectionHeadingListState extends StateMVC<InspectionHeadingList> {
  InspectionController _inspectionController;
  List<bool> typeVisibillity=[true,true];
  List<String> superHeadingsSubtitle=['Where a wall of a building serves as a barrier to the pool the following shall apply. (BR 147C(a))','Where a barrier incorporates a boundary paling or similar style fence without openings.','Where a barrier fence is not a wall of a building or boundary fence, the requirements of AS 1926.1-1993 shall apply.  (BR 147C(b))'];
  List<String> superHeadingTitle=['A Wall of a Building','A Paling or Imperforate Boundary Fence','A Barrier Fence and Gate'];
  bool filter = false;
  int headingcompleted = 0;
  String ownerland;
  bool syncdata=false;
  bool isOnline=false;
  int _groupValue1=0;
  int _groupValue2=0;
  ConnectionStatusSingleton connectionStatus;

  _InspectionHeadingListState() : super(InspectionController()) {
    _inspectionController = controller;
  }
  void initializeTypeVisibility(){
    SharedPreferences.getInstance().then((value){
      bool type1=value.getBool('${widget.bookingid}&${1}');
      bool type2=value.getBool('${widget.bookingid}&${2}');
      if(type1!=null)
        typeVisibillity[0]=type1;
      if(type2!=null)
        typeVisibillity[1]=type2;
    });
    
  }
  Future sendQuestionAnswerOfflineData(String data) async {

    ProgressDialog pr;

    pr = new ProgressDialog(context);
    try {

      if(data!=null&& data!='{"answers":[]}'.toString()) {
        pr.show();
        final response = await http.post(
            '$baseUrl/beedev/local-storage-send-ans',
            body: data
        );
        SelectNonCompliantOrNotice selectNonCompliantOrNotice = selectNonCompliantOrNoticeFromJson(
            response.body);
        

        if (selectNonCompliantOrNotice.status.toString() == "success") {
          await pr.hide();
          Fluttertoast.showToast(
              msg: "Successfully Saved",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: getFontSize(context,-2)
          );
          setState(() {
            syncdata=true;
          });
       await _inspectionController.storeQuestionAnswerInLocal("", "questionanswer");
        }
        else {
          await pr.hide();
          Fluttertoast.showToast(
              msg: "Connection Time Out ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: getFontSize(context,-2)
          );
        }
      }
      else
        {
          Fluttertoast.showToast(
              msg: "All Data Synced",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: getFontSize(context,-2)
          );

          setState(() {
            syncdata=true;
          });
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

  Future checkingInternet() async
  {

    //  _connectionChangeStream = await connectionStatus.connectionChange.listen(connectionChanged);
    await connectionStatus.checkConnection().then((val) {
      val ? loadData() :refreshOfflineId();
      isOnline = val;
    });


  }

  QuestionModel model;
  @override
  void initState() {
    //print("cancan"+widget.predata.toString());
    connectionStatus = ConnectionStatusSingleton.getInstance();


    WidgetsBinding.instance.addPostFrameCallback((_){

      checkingInternet();

    });
//    _con.getQuestionsFilled(widget.bookingid);
//    _con.getheadings(widget.bookingid);


    super.initState();
  }
  void connectionChanged(dynamic hasConnection) {   //later use
    setState(() {
      connectionStatus.checkConnection().then((val) {
        val ? loadData() : refreshOfflineId();
        isOnline= val;
      });
      // isOffline = !hasConnection;
    });
  }
  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 0), onDoneLoading);
  }
  onDoneLoading() async {
    // print(currentUser.token2fa);

    refreshId();

  }
  Future refreshId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("ownerland",widget.predata['owner_land'].toString());
    _inspectionController.headingslist = [];
      setState(() {

        _inspectionController.questionpendingcount = 0;
        _inspectionController.questionpending = false;
        _inspectionController.getQuestionsFilled(widget.bookingid);

        _inspectionController.getheadings(widget.bookingid);
        initializeTypeVisibility();
      });


  }
  Future refreshOfflineId() async {
    final prefs = await SharedPreferences.getInstance();
    ownerland=prefs.get("ownerland");
    print("ownerland="+ownerland.toString());
    _inspectionController.headingslist = [];
    setState(() {

     readCounter(widget.bookingid.toString()).then((onValue) {
        print("onvalue"+onValue.toString());
     //   print("decodevalue"+);
        OfflineDataModel offlinedatamodelresponse = offlineDataModelFromJson(onValue);
     //  var onOfflineValue=json.decode(onValue.toString());
     //   print("onvalueregulationname"+offlinedatamodelresponse.quesionList[0].regulationName.toString());
        setState(() {
          print("insideoffline");
       _inspectionController.headingslist.addAll(offlinedatamodelresponse.quesionList);
        initializeTypeVisibility();
        });
      });

      readCounter(widget.bookingid.toString()).then((onValue) {
        OfflineDataModel offlinedatamodelresponse = offlineDataModelFromJson(onValue);
        _inspectionController.questionpendingcount = 0;
        _inspectionController.questionpending = false;
        _inspectionController.allquestionscount=0;
        _inspectionController.percent=0.0;
        setState(() {


          for (var i = 0; i < offlinedatamodelresponse.quesionList[0].headingId; i++) {
            // questionsCount.add(onValue['questions_from_headingId'][i]);
            if (offlinedatamodelresponse.quesionList[0].questions[i].ans == null) {
              _inspectionController.questionpending = true;
              _inspectionController.questionpendingcount++;
            }
           _inspectionController.allquestionscount++;
          }
          // print("${head.length} heading questions list ");


          _inspectionController.percent = ((_inspectionController.allquestionscount - _inspectionController.questionpendingcount) *
              100 /
              _inspectionController.allquestionscount)
              .roundToDouble();
        });
      });


    });
  }
  //${widget.predata['notice_registration']} regulation_id
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      key: _inspectionController.scaffoldKey,
      backgroundColor: config.Colors().scaffoldColor(1),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: config.Colors().secondColor(1),
            ),
            onPressed: () => Navigator.pop(context)), 
        title:  Text(
          // widget.predata['notice_registration'],
          "Inspection: ${widget.predata['owner_name']}",
          style: TextStyle(fontFamily: "AVENIRLTSTD", fontWeight: FontWeight.bold,fontSize: getFontSize(context, 4)),
        ),
        actions: <Widget>[
         isOnline?IconButton(
            icon: Icon(Icons.sync,color: syncdata?Colors.green:Colors.redAccent,),
            onPressed:()async {
            String onOfflineValue;
           await _inspectionController.readQuestionAnswerCounter().then((onValue) {
             {
                onOfflineValue= "{"+ '"answers"'+":"+"["+onValue.toString()+"]"+"}";
             }

                setState(() {
                  print("insideapi reading");
                  print("insideapiofflinevalue="+onOfflineValue.toString());


                });
              });
           await sendQuestionAnswerOfflineData(onOfflineValue);
            },
          ):Container(),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed:()async { isOnline?refreshId():refreshOfflineId();
          },
          )
         
        ],
      ),

      body:_inspectionController.headingslist.length == 0?Center(child: isOnline?CircularProgressIndicator():
      _inspectionController.headingslist.length == 0?CircularProgressIndicator(backgroundColor: Colors.redAccent,):RefreshIndicator(
        onRefresh: refreshOfflineId,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:inpsectionHeadingColumnList(),
        ),
      ),)

          :
      RefreshIndicator(
        onRefresh: refreshId,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:inpsectionHeadingColumnList(),
        ),
      ),
    );
  }

  Widget inpsectionHeadingColumnList()
  {
    
    return Column(
      children: <Widget>[
        Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                  color: Colors.grey[300],
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.grey[300],
                      child: Column(
                        children: [
                          ListTile(
                            trailing: _inspectionController.percent == null
                                ? CircularProgressIndicator()
                                : Text("${_inspectionController.percent.round()}%",
                                style: TextStyle(
                                    fontSize: getFontSize(context,2),
                                    fontFamily: "AVENIRLTSTD",
                                    color: Color(0xff222222))),
                            title: Text(
                              _inspectionController.headingslist[0]
                              ['regulation_name'],
                              style: TextStyle(
                                  fontSize: getFontSize(context,0),
                                  fontFamily: "AVENIRLTSTD",
                                  color: Color(0xff222222)),
                            ),
                            subtitle:  GestureDetector(
                                onTap: ()
                                {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                            return  SingleChildScrollView(
                                                child:AlertDialog(

                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Align(
                                                        
                                                        child: GestureDetector(

                                                          onTap: ()
                                                          {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Icon(Icons.clear,color: Colors.grey,),
                                                        ),
                                                        alignment: Alignment.topRight,
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Flexible(child:
                                                      SingleChildScrollView(
                                                          child: Text(
                                                            _inspectionController.headingslist[0]
                                                            ['regulation_description'].toString(),
                                                            style: TextStyle(
                                                                fontFamily: "AVENIRLTSTD",
                                                                color: Colors.black,
                                                                fontSize: getFontSize(context,0)),
                                                          )
                                                      )
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            );
                                          }
                                      );

                                    },
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                  child: Text(

                                    "More Info.",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(

                                        fontSize: getFontSize(context,0),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "AVENIRLTSTD",
                                        color: Colors.blueAccent),

                                  ),
                                )
                            ),

                          ),
                          if(widget.predata['notice_registration']=='2')
                           ListTile(title:Padding(
                              padding:
                              EdgeInsets.only(top: 4.0),
                              child: Column(
                                children: [
                                  Text(
                                   'Barrier Fences WALLS, Gates, & WINDOWS'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: getFontSize(context,-2),
                                        fontFamily: "AVENIRLTSTD",
                                        color: Color(0xff000000)),
                                        textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            subtitle:  Text(
                               'Note: One or more of the following barriers must be in place to restrict access to the pool/spa area.',
                                style: TextStyle(
                                    fontSize: getFontSize(context,-3),
                                    fontFamily: "AVENIRLTSTD",
                                    color: Colors.black54
                                    
                                    ),textAlign: TextAlign.start,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )),
            )),
            // if(widget.predata['notice_registration']=='4')
            // Padding(
            //    padding: EdgeInsets.all(8.0),
            //    child: Card(
            //  elevation: 1,
                 
            //     //  color: config.Colors().scaffoldColor(1),
            //      child: ListTile(title:Padding(
            //                   padding:
            //                   EdgeInsets.only(top: 4.0),
            //                   child: Column(
            //                     children: [
            //                       Text(
            //                        'ABOVE GROUND SWIMMING POOL OR SPA (Including Inflatable Pools)'.toUpperCase(),
            //                         style: TextStyle(
            //                             fontSize: getFontSize(context,-2),
            //                             fontFamily: "AVENIRLTSTD",
            //                             color: Color(0xff000000)),
            //                             textAlign: TextAlign.start,
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //                 subtitle:  Text(
            //                    'Note: One or more of the following barriers must be in place to restrict access to the pool/spa area.',
            //                     style: TextStyle(
            //                         fontSize: getFontSize(context,-3),
            //                         fontFamily: "AVENIRLTSTD",
            //                         color: Colors.black54
                                    
            //                         ),textAlign: TextAlign.start,
            //                   ),
            //                 ),),
            // ),
            widget.predata['notice_registration']=='2'?
            
            Expanded(flex: 12,
          child: 
          ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index)
          {
            return Column(
              children: [
                Padding(
                   padding: EdgeInsets.all(8.0),
                   child: Card(
                     elevation: 0,
                     color: config.Colors().scaffoldColor(1),
                     child: ListTile(title:Padding(
                                  padding:
                                  EdgeInsets.only(top: 4.0),
                                  child: Text(
                                   superHeadingTitle[index].toUpperCase(),
                                    style: TextStyle(
                                        fontSize: getFontSize(context,-2),
                                        fontFamily: "AVENIRLTSTD",
                                        color: Color(0xff000000)),
                                  ),
                                ),
                                subtitle:  Column(
                                  children: [
                                    Text(
                                       superHeadingsSubtitle[index],
                                        style: TextStyle(
                                            fontSize: getFontSize(context,-3),
                                            fontFamily: "AVENIRLTSTD",
                                            color: Colors.black54,
                                      ),
                                    ),
                                    if(index!=2)
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                                       children: [
                                       Row(
                                         children: [
                                           Radio(value: typeVisibillity[index]?1:2, groupValue: 1, onChanged: (value)async{
                                             ProgressDialog pr;
                                              pr = new ProgressDialog(context);
                                             
                                            submitApplicableNotApplicable(index+1,true,pr).then((value){
                                              pr.hide();
                                              if(value){
                                                setState(() {
                                               typeVisibillity[index]=true;
                                             });
                                              }
                                              });
                                           }),
                                           Text('Applicable',
                                         style: TextStyle(fontSize: getFontSize(context,-2),fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.bold)
                                       ),
                                         ],
                                       ),
                                       
                                       Row(
                                         children: [
                                           Radio(value: !typeVisibillity[index]?1:2,groupValue: 1, onChanged: (value)async{
                                             ProgressDialog pr;
                                              pr = new ProgressDialog(context);
                                            submitApplicableNotApplicable(index+1,false,pr).then((value){
                                              pr.hide();
                                              if(value){
                                                setState(() {
                                               typeVisibillity[index]=false;
                                             });
                                              }
                                              });
                                           }),
                                           Text('Not Applicable',
                                         style: TextStyle(fontSize: getFontSize(context,-2),fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.bold)
                                       ),
                                         ],
                                       ),
                                       
                                     ],)
                                  ],
                                ),),
                )),
                
                Visibility(
                  visible: index!=2?typeVisibillity[index]:true,
                  child: Column(
                   children: [
                     for(var heading in _inspectionController.headingslist)
                     if(heading['heading_type']==index+1)
                     Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(

                            child: ListTile(
                                trailing: heading
                                ['is_completed'] ==
                                    0
                                    ? Text("")
                                    : Icon(
                                  Icons.check,
                                  color: Theme.of(context)
                                      .accentColor,
                                ),

                                title: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    heading
                                    ['regulation_name'],
                                    style: TextStyle(
                                        fontSize: getFontSize(context,-3),
                                        fontFamily: "AVENIRLTSTD",
                                        color: Color(0xffaeaeae)),
                                  ),
                                ),
                                subtitle:  Padding(
                                    padding:
                                     EdgeInsets.only(top: 8.0,bottom: 8.0),
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(

                                          heading
                                          ['heading_name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: getFontSize(context,0),
                                              fontFamily: "AVENIRLTSTD",
                                              color: Color(0xff222222)),
                                        ),
                                        heading['heading_description']==""?Container():GestureDetector(
                                            onTap: ()
                                            {

                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(
                                                      builder: (context, setState) {
                                                        return  SingleChildScrollView(
                                                            child:AlertDialog(

                                                              content: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: <Widget>[
                                                                  Align(
                                                                    child: GestureDetector(
                                                                      onTap: ()
                                                                      {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                      child: Icon(Icons.clear,color: Colors.grey,),
                                                                    ),
                                                                    alignment: Alignment.topRight,
                                                                  ),
                                                                  SizedBox(height: 10,),
                                                                  SizedBox(height: 10,),
                                                                  Flexible(child:
                                                                  SingleChildScrollView(
                                                                      child: Text(
                                                                        heading
                                                                        ['heading_description'].toString(),
                                                                        style: TextStyle(
                                                                            fontFamily: "AVENIRLTSTD",
                                                                            color: Colors.black,
                                                                            fontSize: getFontSize(context,0)),


                                                                      )
                                                                  )
                                                                  ),



                                                                ],
                                                              ),
                                                            )
                                                        );
                                                      }
                                                  );
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                              child: Text(
                                                "More Info.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: getFontSize(context,0),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "AVENIRLTSTD",
                                                    color: Colors.blueAccent),
                                              ),
                                            )
                                        ),
                                      ],
                                    )
                                ),
                                onTap: () async {
                                  bool abc = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InspectionQuestionList(
                                                heading
                                                ['heading_id'],
                                                widget.bookingid,
                                                widget.predata['id'],
                                              )));
                                  if (abc) {
                                   await checkingInternet();
                                  }

                                }
                            ),
                          ),
                        ),
                      ),
                    ),
                   ], 
                  )
                )
              ],
            );
          })
        )
            :
        Expanded(flex: 12,
          child: ListView.builder(
              itemCount: _inspectionController.headingslist.length,
              itemBuilder: (context, i) {
               print(_inspectionController.headingslist[i]
                                ['regulation_name']=='BUILDING REGULATIONS - 2018  (Part 9ADivision 2)');
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(

                            child: ListTile(
                                trailing: _inspectionController.headingslist[i]
                                ['is_completed'] ==
                                    0
                                    ? Text("")
                                    : Icon(
                                  Icons.check,
                                  color: Theme.of(context)
                                      .accentColor,
                                ),

                                title: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    _inspectionController.headingslist[i]
                                    ['regulation_name'],
                                    style: TextStyle(
                                        fontSize: getFontSize(context,-3),
                                        fontFamily: "AVENIRLTSTD",
                                        color: Color(0xffaeaeae)),
                                  ),
                                ),
                                subtitle:  Padding(
                                    padding:
                                     EdgeInsets.only(top: 8.0,bottom: 8.0),
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _inspectionController.headingslist[i]
                                          ['heading_name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: getFontSize(context,0),
                                              fontFamily: "AVENIRLTSTD",
                                              color: Color(0xff222222)),
                                        ),
                                        _inspectionController.headingslist[i]['heading_description']==""?Container():GestureDetector(
                                            onTap: ()
                                            {

                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(
                                                      builder: (context, setState) {
                                                        return  SingleChildScrollView(
                                                            child:AlertDialog(

                                                              content: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: <Widget>[
                                                                  Align(
                                                                    child: GestureDetector(
                                                                      onTap: ()
                                                                      {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                      child: Icon(Icons.clear,color: Colors.grey,),
                                                                    ),
                                                                    alignment: Alignment.topRight,
                                                                  ),
                                                                  SizedBox(height: 10,),
                                                                  SizedBox(height: 10,),
                                                                  Flexible(child:
                                                                  SingleChildScrollView(
                                                                      child: Text(
                                                                        _inspectionController.headingslist[i]
                                                                        ['heading_description'].toString(),
                                                                        style: TextStyle(
                                                                            fontFamily: "AVENIRLTSTD",
                                                                            color: Colors.black,
                                                                            fontSize: getFontSize(context,0)),


                                                                      )
                                                                  )
                                                                  ),



                                                                ],
                                                              ),
                                                            )
                                                        );
                                                      }
                                                  );
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                              child: Text(
                                                "More Info.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: getFontSize(context,0),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "AVENIRLTSTD",
                                                    color: Colors.blueAccent),
                                              ),
                                            )
                                        ),
                                      ],
                                    )
                                ),
                                onTap: () async {
                                  bool abc = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InspectionQuestionList(
                                                _inspectionController.headingslist[i]
                                                ['heading_id'],
                                                widget.bookingid,
                                                widget.predata['id'],
                                              )));
                                  if (abc) {
                                   await checkingInternet();
                                  }

                                }
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );

              }),
        ),

      ],
    );
  }

  Future<bool> submitApplicableNotApplicable(int headingTypeNumber,bool isApplicable,ProgressDialog pr) async{
    
    pr.show();
    final String _apiToken = 'beedev';
    
         try {
           print('booking_id:\'${widget.bookingid}\', heading_type:\'$headingTypeNumber\', is_applicable:\'$isApplicable\',');
    final response = await Dio().post('$publicBaseUrl$_apiToken/regulation_type_post',
        data: FormData.fromMap(
                                            {
                                              'booking_id':'${widget.bookingid}',
                                              'heading_type':'$headingTypeNumber',
                                              'is_applicable':isApplicable.toString()//boolean value
                                            }
                                          ),
                                
        options: Options(headers: {
          "Accept": "application/json",
          // 'Authorization': 'Bearer $authToken',
        }));
     print("Applicable/NotApplicable response:"+response.data.toString());
     if(response.statusCode==200)
      {
        refreshId();
        SharedPreferences prefs=await SharedPreferences.getInstance();
          prefs.setBool('${widget.bookingid}&$headingTypeNumber', isApplicable);
          if(prefs.getBool('${widget.bookingid}&$headingTypeNumber')!=null)
            return true;
        }
  }   on DioError catch (e) {
    pr.hide();
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      Fluttertoast.showToast(
          msg: "Connection Timeout",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );
    }
    if (e.type == DioErrorType.DEFAULT) {
      Fluttertoast.showToast(
          msg: "Device is Offline",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );
    }
    if (e.type == DioErrorType.RESPONSE) {
      Fluttertoast.showToast(
          msg: "Something Went Worg. Please Try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );
    }
    return false;
  }
     
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory(); //maybe for ios permission issue you have to change it into getApplicationSupportDirectorytype kuch.

    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${widget.bookingid}.txt');
  }
  Future<String> readCounter(String bookingid) async {
    try {
      final file = await _localFile;
     
      String contents = await file.readAsString();
      
      return contents.toString();
    } catch (e) {
      print("errrror"+e.toString());
      return null;
    }
  }



}
