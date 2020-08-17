
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/elements/drawer.dart';
import 'package:poolinspection/src/models/getinvoicelistmodel.dart';
import 'package:poolinspection/src/pages/home/MyWebView.dart';
import 'package:poolinspection/src/helpers/sharedpreferences/userpreferences.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;


class InvoiceListClass extends StatefulWidget {

  @override
  _InvoiceListClassState createState() => _InvoiceListClassState();

}
class _InvoiceListClassState extends State<InvoiceListClass> {

  List<GetInvoiceList> getInvoiceList =new List<GetInvoiceList>();
  bool isLoading = false;

  List<InvoiceList> invoiceList =new List<InvoiceList>();
 int userId;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  @mustCallSuper
  @override
  void initState() {


    UserSharedPreferencesHelper.getUserDetails().then((user) {
      setState(() {
        // print("${user.userdata.inspector.firstName } controller user id");
        userId=user.id;

      });
    });
  }

  Future<GetInvoiceList> createInvoiceList() async {
    try {
      final response = await http.get(
        'https://poolinspection.beedevstaging.com/api/beedev/invoice-list/$userId',

      );

      GetInvoiceList getinvoicelist = getInvoiceListFromJson(response.body);

      if (getinvoicelist.status == "pass") {
        return getinvoicelist;
      }
      else {
        return null;
      }
    }catch(e)
    {
      print("erroringetinvoice"+e.toString());
      return null;
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
            child:Text("Invoices",
              style: TextStyle(
                fontWeight: FontWeight.w700,
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

        body: new Center(
          child:Container(

            child: FutureBuilder<GetInvoiceList>(
              future: createInvoiceList(),
              builder: (context, snapshot) {

                if (snapshot.hasData) {
                  //     spacecrafts.add(snapshot.data.data.elementAt(0).categoryname);
                  if(snapshot.data.invoiceList.isNotEmpty)
                    {
                invoiceList.clear();
                for(var l=0;l<snapshot.data.invoiceList.length;l++) {
                  InvoiceList d = new InvoiceList();
                  d.id = snapshot.data.invoiceList
                      .elementAt(l)
                      .id;
                  d.invoiceNumber = snapshot.data.invoiceList
                      .elementAt(l)
                      .invoiceNumber;
                  d.dateString = snapshot.data.invoiceList
                      .elementAt(l)
                      .dateString;
                  d.amountDue = snapshot.data.invoiceList
                      .elementAt(l)
                      .amountDue;
                  d.contactId=snapshot.data.invoiceList.elementAt(l).contactId;
                  d.amountPaid = snapshot.data.invoiceList
                      .elementAt(l)
                      .amountPaid;
                  d.status = snapshot.data.invoiceList
                      .elementAt(l)
                      .status;

                  invoiceList.add(d);
                }
                }
                  else
                    {
                      return Text("No Invoices Found.",style: TextStyle(color: Colors.black,fontSize: getFontSize(context,2)),);
                    }


                  return  Column(
                      children: <Widget>[
                        // _createSearchView(),
                        Expanded(
                            child:ListView.builder(
                              itemCount: snapshot.data.invoiceList.length,
                              itemBuilder: _getItemUI,//one important thing to note here is parameter of itembuilder is context,index but if
                              //  itemExtent: 100.0,  //but if you giving method then they both will be treated as parameter of that method.
                              padding: EdgeInsets.all(0.0),
                            )),
                      ]);
                } else if (snapshot.hasError) {
                  return Text("No Invoices Found.",style: TextStyle(color: Colors.black,fontSize: getFontSize(context,2)),);
                }

                // By default, show a loading spinner.
                return new CircularProgressIndicator();
              },
            ),
          ),
        )
    );


  }

  Widget _getItemUI(BuildContext context, int index) {
    return new  Padding(
        padding: new EdgeInsets.fromLTRB(20, 20, 20,20),
        child:Card(
            child: Padding(
                  padding: new EdgeInsets.fromLTRB(10, 10, 10,10),
                  child:
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[

                          new Text("INVOICE NO. "+invoiceList[index].invoiceNumber, style: TextStyle(
                              fontFamily: "AVENIRLTSTD",
                              fontSize: getFontSize(context,3),
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w900),),
                          SizedBox(height: 8,),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                          new Text("Dated:"+" "+DateFormat("dd-MM-yyyy").format(DateTime.parse(invoiceList[index].dateString.toString().substring(0,10))).toString(), style: TextStyle(
                              fontFamily: "AVENIRLTSTD",
                              fontSize: getFontSize(context,-2),
                              color: Color(0xff999999),
                              fontWeight: FontWeight.normal),),


                    ButtonTheme(
                      minWidth: 22.0,
                      height: 25.0,
                      child:RaisedButton(
                        onPressed:(){

                        },
                        color: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                        child:Text(
                          invoiceList[index].status,textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getFontSize(context,-5),
                              color: Colors.white, fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.normal),
                        ),


                      ),
                    ),

                          ]
                ),



                          Padding(
                            padding: new EdgeInsets.fromLTRB(0,0, 0,0), child:new RaisedButton(
                            onPressed:() {

                            },
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                            child:GestureDetector(child:Text(
                              "View",
                              style: TextStyle(
                                  fontSize: getFontSize(context,0),
                                  color: Colors.white, fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.normal),
                            ),
                              onTap: ()
                              {

                             print("gokuxx"+invoiceList[index].contactId);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => MyWebView(
                                        title:"INVOICE NO. "+invoiceList[index].invoiceNumber ,
                                        selectedUrl:"https://poolinspection.beedevstaging.com/api/beedev/view_invoice/"+invoiceList[index].contactId,
                                      )));

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


//Create the Filtered ListView


}
//Widget _createSearchView() {
//
//  return new Container(
//      color: Theme.of(context).primaryColor,
//      child: new Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: new Card(
//          child: new ListTile(
//            leading: new Icon(Icons.search),
//            title: new TextField(
//              controller: _searchview,
//              decoration: new InputDecoration(
//                  hintText: 'Searh', border: InputBorder.none),
//            ),
//            trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
//              _searchview.clear();
//            },),
//          ),
//        ),
//      ));
//}