import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/inspection_controller.dart';
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

  bool filter = false;
  int headingcompleted = 0;
  String ownerland;
  bool syncdata=false;
  bool isOnline=false;
  ConnectionStatusSingleton connectionStatus;

  _InspectionHeadingListState() : super(InspectionController()) {
    _inspectionController = controller;
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
            onPressed: () => Navigator.pop(context)), //doubt here
        title:  Text(
          "Inspection: ${widget.predata['owner_land']}",
          style: TextStyle(fontFamily: "AVENIRLTSTD", fontWeight: FontWeight.bold),
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
             //sync data api will go here
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
                      child: ListTile(
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
                                  // return object of type Dialog
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
                    ),
                  )),
            )),
        Expanded(flex: 12,
          child: ListView.builder(
              itemCount: _inspectionController.headingslist.length,
              itemBuilder: (context, i) {
               

                return Padding(
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
                                const EdgeInsets.only(top: 8.0,bottom: 8.0),
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
                                              // return object of type Dialog
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
                );

              }),
        ),

      ],
    );
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
