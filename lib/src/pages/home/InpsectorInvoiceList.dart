import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/elements/drawer.dart';
import 'package:poolinspection/src/models/getinpsectorinovicelist.dart';
import 'package:poolinspection/src/models/selectCompliantOrNotice.dart';
import 'package:poolinspection/src/elements/custom_progress_dialog.dart';
import 'package:poolinspection/src/helpers/sharedpreferences/userpreferences.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;
import 'package:poolinspection/constants.dart';


class InspectorInvoiceListClass extends StatefulWidget {

  @override
  _InspectorInvoiceListClassState createState() => _InspectorInvoiceListClassState();

}
class _InspectorInvoiceListClassState extends State<InspectorInvoiceListClass> {

  List<GetInspectorInvoiceList> cleaner =new List<GetInspectorInvoiceList>();
  bool isLoading = false;

  List<ListElement> inovoice =new List<ListElement>();
  String message="Send Email";
  int userId;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {


    UserSharedPreferencesHelper.getUserDetails().then((user) {
      setState(() {
        userId=user.id;

      });
    });
  }


  Future sendEmail(id) async
  {
    ProgressDialog pr;
    pr = ProgressDialog(context,isDismissible: false);


    try {
      pr.show();
      print("inspectorid"+id.toString());
      final response = await http.get("$baseUrl/send_inspector_invoice/$id");
      print("responsee"+response.body.toString());

      SelectNonCompliantOrNotice selectNonCompliantOrNotice= selectNonCompliantOrNoticeFromJson(response.body);



      if(selectNonCompliantOrNotice.error==0) {
        await pr.hide();
        Fluttertoast.showToast(
            msg: selectNonCompliantOrNotice.messages.toString()+" Succesfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor:
            Theme.of(context).hintColor,
            textColor: Colors.white,
            fontSize: getFontSize(context,-2)
        );

      }
      else
        {
          await pr.hide();
        }


    }catch(e)
    {
      pr.hide();
      print("errorfrombackend"+e.toString());
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


  Future<GetInspectorInvoiceList> createInvoiceList() async {
    try {
      final response = await http.get(
        '$baseUrl/beedev/inspector_invoice/$userId',

      );
      print("hellllo"+response.body.toString());
      GetInspectorInvoiceList getinvoicelist = getInspectorInvoiceListFromJson(response.body);

      if (getinvoicelist.status == "pass") {
        return getinvoicelist;
      }
      else {
        return null;
      }
    }catch(e)
    {
      
      print("Backend Error"+e.toString());
      return null;
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
            child:Text(" Inspector Invoices",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: "AVENIRLTSTD", 
                fontSize: getFontSize(context,2),
                color: Color(0xff222222),
              ),
            ),

          ),
          actions: <Widget>[
            // IconButton(
            //     icon: Icon(Icons.menu),
            //     onPressed: () => _scaffoldKey.currentState.openEndDrawer())
            Image.asset(
            "assets/img/app-iconwhite.jpg",
            // fit: BoxFit.cover,
            fit: BoxFit.fitWidth,
          )
          ],
        ),

        body: new Center(
          child:Container(

            child: FutureBuilder<GetInspectorInvoiceList>(
              future: createInvoiceList(),
              builder: (context, snapshot) {

                if (snapshot.hasData) {
                  if(snapshot.data.list.isNotEmpty)
                  {
                    inovoice.clear();
                    for(var l=0;l<snapshot.data.list.length;l++) {
                      ListElement d = new ListElement();
                      d.id = snapshot.data.list
                          .elementAt(l)
                          .id;
                      d.ownerName = snapshot.data.list
                          .elementAt(l)
                          .ownerName;
                      d.ownerEmail = snapshot.data.list
                          .elementAt(l)
                          .ownerEmail;
                      d.bookingDate = snapshot.data.list
                          .elementAt(l)
                          .bookingDate;
                      d.bookingTime = snapshot.data.list
                          .elementAt(l)
                          .bookingTime;
                      d.invoiceName = snapshot.data.list
                          .elementAt(l)
                          .invoiceName;
                      d.invoicePath = snapshot.data.list
                          .elementAt(l)
                          .invoicePath;
                      d.inspectorId = snapshot.data.list
                          .elementAt(l)
                          .inspectorId;

                      inovoice.add(d);
                    }
                  }
                  else
                  {
                    return Text("No Inspector Invoices Found.",style: TextStyle(color: Colors.black,fontSize: getFontSize(context,2)),);
                  }


                  return  Column(
                      children: <Widget>[
                        // _createSearchView(),
                        Expanded(
                            child:ListView.builder(
                              itemCount: snapshot.data.list.length,
                              itemBuilder: _getItemUI,//one important thing to note here is parameter of itembuilder is context,index but if
                              //  itemExtent: 100.0,  //but if you giving method then they both will be treated as parameter of that method.
                              padding: EdgeInsets.all(0.0),
                            )),
                      ]);
                } else if (snapshot.hasError) {
                  return Text("Invoices not found.",style: TextStyle(color: Colors.black,fontSize: getFontSize(context,2)),);
                }

                return new CircularProgressIndicator();
              },
            ),
          ),
        )
    );


  }

  Widget _getItemUI(BuildContext context, int index) {
    return new  Padding(
        padding: new EdgeInsets.all(10),
        child:Card(
          child: Padding(
              padding: new EdgeInsets.fromLTRB(10, 10, 10,10),
              child:
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[

                  new Text(inovoice[index].ownerName.toString().substring(0,1).toUpperCase()+inovoice[index].ownerName.toString().substring(1,inovoice[index].ownerName.length).toString(), style: TextStyle(
                      fontFamily: "AVENIRLTSTD",
                      fontSize: getFontSize(context,0),
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w900),),
                  SizedBox(height: 8,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 5),
                    child: Text(
                      inovoice[index].ownerEmail.toString(),textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: getFontSize(context,0),
                          color: Color(0xff999999), fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.normal),
                    ),
                  ),

                  new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: <Widget>[
                        new Text("Dated:"+" "+DateFormat("dd-MM-yyyy").format(DateTime.parse(inovoice[index].bookingDate.toString().substring(0,10))).toString(), style: TextStyle(
                            fontFamily: "AVENIRLTSTD",
                            fontSize: getFontSize(context,-2),
                            color: Color(0xff999999),
                            fontWeight: FontWeight.normal),),
                      ]
                  ),



                  Padding(
                    padding: new EdgeInsets.fromLTRB(0,6, 0,0), child:new RaisedButton(
                      onPressed:() {
                        sendEmail(inovoice[index].id.toString());
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                      child:GestureDetector(child:Text(
                        message,
                        style: TextStyle(
                            fontSize: getFontSize(context,-2),
                            color: Colors.white, fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.normal),
                      ),
                        onTap: ()
                        {
                          sendEmail(inovoice[index].id.toString());

                        }
                        ,
                      )


                  ),
                  ),


                ],
              )
          ),
        )

    );
  }


}
