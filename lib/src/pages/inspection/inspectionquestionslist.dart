import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/inspection_controller.dart';
import 'package:poolinspection/src/helpers/connectivity.dart';
import 'package:poolinspection/src/models/questionmodel.dart';

import 'inspectionquestion.dart';

class InspectionQuestionList extends StatefulWidget {
  int headingid;
  int bookingid;
  var bookingStringid;
  InspectionQuestionList(
      this.headingid, this.bookingid, this.bookingStringid);
  @override
  _InspectionQuestionListState createState() =>
      _InspectionQuestionListState();
}

class _InspectionQuestionListState
    extends StateMVC<InspectionQuestionList> {
  InspectionController _con;
  bool filter = false;
  bool isOnline=false;
  StreamSubscription _connectionChangeStream;
  ConnectionStatusSingleton connectionStatus;
  _InspectionQuestionListState() : super(InspectionController()) {
    _con = controller;
  }
  Future checkingInternet() async
  {
      _connectionChangeStream =  connectionStatus.connectionChange.listen(connectionChanged);
    await connectionStatus.checkConnection().then((val) {
      val ? loadData() :refreshOfflineId();
      isOnline = val;
    });


  }
  Future refreshOfflineId() async {
    print("in refresh");
    _con.questionslist=[];
    setState(() {



    });
  }
  QuestionModel model;
  @override
  void initState() {
    connectionStatus = ConnectionStatusSingleton.getInstance();
    checkingInternet();
    
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _connectionChangeStream.cancel();
  }
  void connectionChanged(dynamic hasConnection) {   //later use
    setState(() {
      connectionStatus.checkConnection().then((val) {
        val ? loadData() : refreshOfflineId();
        isOnline= val;
      });
    });
  }
  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 0), onDoneLoading);
  }
  onDoneLoading() async {
    await refreshId(); //dont know about it

  }

  Future<void> refreshId() async {
    
    _con.questionslist = [];
    _con.getquestions(widget.headingid, widget.bookingid).then((value) => setState(() {}));
          
  }

  @override
  Widget build(BuildContext context) {
    print(_con.questionslist.length);
    return Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: config.Colors().scaffoldColor(1),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: config.Colors().secondColor(1),
            ),
            onPressed: () => Navigator.pop(context, true)),
        title: Text(
          'Select Questions',
          style: TextStyle( fontFamily: "AVENIRLTSTD", fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
        onPressed:()async {
          isOnline ? await refreshId() : await refreshOfflineId(); //working
        })
          //   IconButton(
          //       icon: Icon(Icons.menu),
          //         onPressed: () => _con.scaffoldKey.currentState.openDrawer()),
        ],
      ),


      body: _con.questionslist.length == 0?Center(child: isOnline?CircularProgressIndicator():
      _con.questionslist.length == 0?CircularProgressIndicator(backgroundColor: Colors.redAccent,):RefreshIndicator(
        onRefresh: refreshOfflineId,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:inpsectionQuestionList(),
        ),
      ),)

          :
      RefreshIndicator(
        onRefresh: refreshId,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:inpsectionQuestionList(),
        ),
      ),
    );
  }

  Widget inpsectionQuestionList()
  {
    return ListView.builder(
        itemCount: _con.questionslist.length,
        itemBuilder: (context, i) {
          return GestureDetector(
              child:Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  elevation: 1.0,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _con.questionslist[i]['question'],
                              style: TextStyle(
                                  fontFamily: "AVENIRLTSTD", color: Color(0xff222222),fontSize: getFontSize(context,0)),
                            ),
                          ),

                          SizedBox(height: 10,),
                          Align(
                              alignment:Alignment.centerRight,
                              child:

                              _con.questionslist[i]['ans'] == null ||
                                  _con.questionslist[i]['ans'] == "0"
                                  ? Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child:new RaisedButton(
                                      disabledElevation:0.0,

                                      onPressed:() async{
                                        
                                         await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => InspectionQuestion(i,
                                                    _con.questionslist[i], i,_con.questionslist)));
                                                    print('finish questions');
                                                    await refreshId();
                                                 
                                      },
                                      color:Colors.redAccent,
                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                      child:Text("Not Answered", style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "AVENIRLTSTD", fontSize: getFontSize(context,-3)),)
                                  )
                              ) : Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child:new RaisedButton(
                                      disabledElevation:0.0,
                                      onPressed:() async{
                                      
                                        print("4321"+_con.questionslist[i].toString());
                                         await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => InspectionQuestion(i,
                                                    _con.questionslist[0], i,_con.questionslist)));
                                                    print('finish questions');
                                                    await refreshId();
                                       
                                      },
                                      color:Color(0xff20c67e),
                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                      child:Text("Answered", style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "AVENIRLTSTD", fontSize: getFontSize(context,-3)),)
                                  )
                              )
                          ),
                        ],
                      )
                  ),
                ),
              ),
              onTap: () async{
                await
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InspectionQuestion(i,
                            _con.questionslist[i], i,_con.questionslist)));
                            isOnline ? await refreshId() : await refreshOfflineId();
                            
              }
          );
        });
  }
  // Future _submit(Map<String, dynamic> formData) async {
  //   List<Widget> children = [];
  //   formData.forEach((key, value) {
  //     children.add(Text("$key: ${value.toString()} ${value.runtimeType}"));
  //   });
  //   showDialog(
  //     context: _con.scaffoldKey.currentState.context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Form Data"),
  //         content: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start, children: children),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text("Close"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}



