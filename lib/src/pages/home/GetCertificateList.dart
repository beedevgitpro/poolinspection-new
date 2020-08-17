import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/elements/drawer.dart';
import 'package:poolinspection/src/models/getcertificatemodel.dart';
import 'package:poolinspection/src/pages/home/PermissionHandler.dart';
import 'package:poolinspection/src/pages/utils/signaturepad.dart';
import 'package:poolinspection/src/helpers/sharedpreferences/userpreferences.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/models/route_argument.dart';
import 'package:poolinspection/src/elements/custom_progress_dialog.dart';
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;




class CertificateListClass extends StatefulWidget {
  final RouteArgumentCertificate routeArgument;

  CertificateListClass({Key key, this.routeArgument}) : super(key: key);

  @override
  _CertificateListClassState createState() => _CertificateListClassState();

}
class _CertificateListClassState extends State<CertificateListClass> {


  List<GetCertificateModel> cleaner =new List<GetCertificateModel>();
  bool isLoading = false;

  bool progressCircular = false;
  List<ListElement> certificate =new List<ListElement>();
 int userId;
  String category;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future refreshId() async {
    setState(() {




    });
  }


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


  Future downloadpdf(idofcertificate) async
  {
 ProgressDialog pr;
    pr = ProgressDialog(context,isDismissible: false);
    //final bytes = await .File(dataimage).readAsBytes();



    final Directory directory = await getApplicationSupportDirectory();
    final String path = directory.path;
    final File file = File('$path/certificate$idofcertificate.pdf');
    try {
      pr.show();
      print("directory"+directory.toString());
      print("file"+file.toString());
//      Fluttertoast.showToast(
//          msg: "Opening Certificate, Please Wait..",
//          toastLength: Toast.LENGTH_LONG,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIosWeb: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white,
//          fontSize: getFontSize(context,-2)
//      );
      final response = await http.get("https://poolinspection.beedevstaging.com/api/beedev/generate_certificate/$idofcertificate");
      await file.writeAsBytes(response.bodyBytes);

     pr.hide();
      print("certificateresponse"+file.path.toString());
   //   await pr.hide();

    }catch(e)
    {
      pr.hide();
     // await pr.hide();
      print("errorincertificatebackend"+e.toString());
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

try{

  final result = await OpenFile.open(file.path.toString());


  if(!mounted)  return;
  setState(() {
    print( "type=${result.type}  message=${result.message}");
  });
}
catch(e)
    {

    }
  }


  Future<GetCertificateModel> createCertificateList() async{
   print("qqqwer"+userId.toString());
    widget.routeArgument.heroTag.toString()=="Compliant"?category="compliant":widget.routeArgument.heroTag.toString()=="Non Compliant"?category="non-compliant":category="notice";
     final response = await http.get('https://poolinspection.beedevstaging.com/api/beedev/$category/$userId',

    );

    GetCertificateModel getcertifcatelist= getCertificateModelFromJson(response.body);


    if(getcertifcatelist.status=="pass")
      {

        return getcertifcatelist;
      }
    else
      {

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
            child:Text("Certificate",
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
                icon: Icon(Icons.refresh),
                onPressed: refreshId,
              ),
              //   IconButton(
              //       icon: Icon(Icons.menu),
              //         onPressed: () => _con.scaffoldKey.currentState.openDrawer()),

            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState.openEndDrawer())
          ],
        ),

        body:RefreshIndicator(
          onRefresh: refreshId,
          child: new Center(
          child:Container(

            child: FutureBuilder<GetCertificateModel>(
              future: createCertificateList(),
              builder: (context, snapshot) {

                if (snapshot.hasData) {
                  if(snapshot.data.list.isNotEmpty)
                    {
                certificate.clear();
                for(var l=0;l<snapshot.data.list.length;l++) {
                  ListElement certificateElement = new ListElement();
                  certificateElement.id = snapshot.data.list
                      .elementAt(l)
                      .id;
                  certificateElement.ownerLand = snapshot.data.list
                      .elementAt(l)
                      .ownerLand;
                  certificateElement.ownerLand = snapshot.data.list
                      .elementAt(l)
                      .ownerLand;
                  certificateElement.postcode = snapshot.data.list
                      .elementAt(l)
                      .postcode;
                  certificateElement.bookingTime=snapshot.data.list
                      .elementAt(l).
                       bookingTime;
                  certificateElement.bookingDateTime = snapshot.data.list
                      .elementAt(l)
                      .bookingDateTime;

                  certificateElement.status= snapshot.data.list
                      .elementAt(l)
                      .status;

                  certificateElement.isCertificateGenerated = snapshot.data.list  //1 for generated
                      .elementAt(l)
                      .isCertificateGenerated;
                  certificate.add(certificateElement);
                }
                }
                  else
                    {
                      return Text("No Certificates Found.",style: TextStyle(color: Colors.black,fontSize: getFontSize(context,2)),);
                    }


                  return  Column(
                      children: <Widget>[
                       
                        Expanded(
                            child:ListView.builder(
                              itemCount: snapshot.data.list.length,
                              reverse: true,
                              itemBuilder: certificateCard,//one important thing to note here is parameter of itembuilder is context,index but if
                              //  itemExtent: 100.0,  //but if you giving method then they both will be treated as parameter of that method.
                              padding: EdgeInsets.all(0.0),
                            )),
                      ]);
                } else if (snapshot.hasError) {


                  return Text("No Certificates Found.",style: TextStyle(color: Colors.black,fontSize: getFontSize(context,2)),);
                }

                // By default, show a loading spinner.
                return new CircularProgressIndicator();
              },
            ),
          ),
        ),
    )
    );


  }

  Widget certificateCard(BuildContext context, int index) {
    return new  Padding(
        padding: new EdgeInsets.all(8),
        child:Card(
            child:Center(
              child:  Padding(
                  padding: new EdgeInsets.fromLTRB(20, 20, 20,20),
                  child:
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[

                          new Text(certificate[index].ownerLand.replaceFirst(certificate[index].ownerLand[0],certificate[index].ownerLand[0].toUpperCase()), style: TextStyle(
                              fontFamily: "AVENIRLTSTD",
                              fontSize: getFontSize(context,3),
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w900),),
                          SizedBox(height: 8,),

                          new Text("Dated:"+" "+DateFormat("dd-MM-yyyy").format(DateTime.parse(certificate[index].bookingDateTime.toString().substring(0,10))).toString(), style: TextStyle(
                              fontFamily: "AVENIRLTSTD",
                              fontSize: getFontSize(context,-3),
                              color: Color(0xff999999),
                              fontWeight: FontWeight.normal),),


                      Padding(
                        padding: new EdgeInsets.fromLTRB(0, 20, 0,0),
                        child:   Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text("Post Code", style: TextStyle(
                                  fontFamily: "AVENIRLTSTD",
                                  fontSize: getFontSize(context,2),
                                  color: Color(0xff222222),
                                  fontWeight: FontWeight.normal),),

                              new Text(certificate[index].postcode, style: TextStyle(
                                  fontFamily: "AVENIRLTSTD",
                                  fontSize: getFontSize(context,2),
                                  color: Color(0xff999999),
                                  fontWeight: FontWeight.w900),),
                            ]
                        ),
                      ),

                          Padding(
                            padding: new EdgeInsets.fromLTRB(0, 0, 0,0),
                            child:   Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                              new Text("Status", style: TextStyle(
                                  fontFamily: "AVENIRLTSTD",
                                  fontSize: getFontSize(context,2),
                                  color: Color(0xff222222),
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
                                        category=="notice"?"Notice of Improvement":category.replaceFirst(category[0],category[0].toUpperCase()),textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: getFontSize(context,-2),
                                            color: Colors.white, fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),

                                ]
                            ),
                          ),

                          Padding(
                            padding: new EdgeInsets.fromLTRB(0,10, 0,0), child:new RaisedButton(
                            onPressed:() {
                              if(certificate[index].isCertificateGenerated==1) Permission.values
                                  .where((Permission permission) {
                                if (Platform.isIOS) {
                                  return permission != Permission.storage ;


                                } else {
                                  return permission != Permission.storage;
                                }
                              })
                                  .map((permission) => PermissionWidget(permission))
                                  .toList();
                                print("certificate generated?"+certificate[index].isCertificateGenerated.toString());
                                certificate[index].isCertificateGenerated==1
                                ?downloadpdf(certificate[index].id.toString()): Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignCertificateScreen(certificate[index].id.toString(),category,certificate[index].bookingDateTime.toString(),certificate[index].bookingTime.toString())),
                                );


                            },
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                            child:GestureDetector(child:Text(
                              certificate[index].isCertificateGenerated==1?"Open":"View",
                              style: TextStyle(
                                  fontSize: getFontSize(context,0),
                                  color: Colors.white, fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.normal),
                            ),
                              onTap: ()
                              {
                                if(certificate[index].isCertificateGenerated==1)  Permission.values
                                    .where((Permission permission) {
                                  if (Platform.isIOS) {
                                    return permission != Permission.storage ;


                                  } else {
                                    return permission != Permission.storage;
                                  }
                                })
                                    .map((permission) => PermissionWidget(permission))
                                    .toList();


                                certificate[index].isCertificateGenerated==1? downloadpdf(certificate[index].id.toString()): Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignCertificateScreen(certificate[index].id.toString(),category,certificate[index].bookingDateTime.toString(),certificate[index].bookingTime.toString())),
                                ).then((value) =>    setState(() {
                                  refreshId();
                                })
                                );


                             refreshId();

                              }
                              ,
                            )


                          ),
                          ),
                        ],
                      ),



              ),
            )
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