import 'package:flutter/material.dart';
import 'package:poolinspection/src/components/responsive_text.dart';

import 'package:poolinspection/src/helpers/sharedpreferences/userpreferences.dart';
import 'package:poolinspection/src/models/route_argument.dart';
import 'package:poolinspection/src/repository/user_repository.dart' as userRepo;


class DrawerList {
  final IconData icon;
  final Text text;
  final int id;
  final String widgeturl;
  DrawerList({this.icon, this.text, this.id,this.widgeturl});
}

// final List<DrawerList> _listViewDate = [
//   DrawerList(
//       id:5,
//       icon: Icons.arrow_right,
//       text: Text("Compliant Report",
//           style: TextStyle(
//               fontSize: getFontSize(context,1),
//               fontFamily: "AVENIRLTSTD",
//               // fontWeight: FontWeight.bold,
//               color: Color(0xff222222))),
//       widgeturl: "/NoticeReport"),
//   DrawerList(
//       id:6,
//       icon: Icons.arrow_right,
//       text: Text("Non Compliant Report",
//           style: TextStyle(
//               fontSize: getFontSize(context,1),
//               fontFamily: "AVENIRLTSTD",
//               // fontWeight: FontWeight.bold,
//               color: Color(0xff222222))),
//       widgeturl: "/NoticeReport"),
//   DrawerList(
//       id:7,
//       icon: Icons.arrow_right,
//       text:  Text("Notice of Improvement",
//           style: TextStyle(
//               fontSize: getFontSize(context,1),
//               fontFamily: "AVENIRLTSTD",
//               // fontWeight: FontWeight.bold,
//               color: Color(0xff222222))),
//       widgeturl: "/NoticeReport"),

// ];
// final List<DrawerList> _certificateListViewDate = [
//   DrawerList(
//     id:2,
//       icon: Icons.arrow_right,
//       text: Text("Compliant",
//           style: TextStyle(
//               fontSize: getFontSize(context,1),
//               fontFamily: "AVENIRLTSTD",
//               // fontWeight: FontWeight.bold,
//               color: Color(0xff222222))),
//       widgeturl: "/Certificate"),
//   DrawerList(
//       id:3,
//       icon: Icons.arrow_right,
//       text: Text("Non Compliant",
//           style: TextStyle(
//               fontSize: getFontSize(context,1),
//               fontFamily: "AVENIRLTSTD",
//               // fontWeight: FontWeight.bold,
//               color: Color(0xff222222))),
//       widgeturl: "/Certificate"),
//   DrawerList(
//       id:4,
//       icon: Icons.arrow_right,
//       text:  Text("Notice of Improvement",
//           style: TextStyle(
//               fontSize: getFontSize(context,1),
//               fontFamily: "AVENIRLTSTD",
//               // fontWeight: FontWeight.bold,
//               color: Color(0xff222222))),
//       widgeturl:"/Certificate"),

// ];


Widget drawerData(BuildContext context, int rolesManage) {


//If any problem comes with report page, just see id of previous drawer dart file we are passing it , if there is problem , that will be of before , i didint changed anything because i ma passing same id flow.
  List<ExpansionTile> _listOfExpansionsCertificate = List<ExpansionTile>.generate(
      1,
          (i) => ExpansionTile(
        leading: Icon(Icons.library_books),
        title: Align(alignment:Alignment.centerLeft,child:Text("Certificate                     ",
            style: TextStyle(
                fontSize: getFontSize(context,2),
                fontFamily: "AVENIRLTSTD",
                // fontWeight: FontWeight.bold,
                color: Color(0xff222222))),),

        children: [
  DrawerList(
    id:2,
      icon: Icons.arrow_right,
      text: Text("Compliant",
          style: TextStyle(
              fontSize: getFontSize(context,1),
              fontFamily: "AVENIRLTSTD",
              // fontWeight: FontWeight.bold,
              color: Color(0xff222222))),
      widgeturl: "/Certificate"),
  DrawerList(
      id:3,
      icon: Icons.arrow_right,
      text: Text("Non Compliant",
          style: TextStyle(
              fontSize: getFontSize(context,1),
              fontFamily: "AVENIRLTSTD",
              // fontWeight: FontWeight.bold,
              color: Color(0xff222222))),
      widgeturl: "/Certificate"),
  DrawerList(
      id:4,
      icon: Icons.arrow_right,
      text:  Text("Notice of Improvement",
          style: TextStyle(
              fontSize: getFontSize(context,1),
              fontFamily: "AVENIRLTSTD",
              // fontWeight: FontWeight.bold,
              color: Color(0xff222222))),
      widgeturl:"/Certificate"),

]
            .map((data) => ListTile(

            leading: Icon(data.icon),
            title: data.text,
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Home', (Route<dynamic> route) => false);
              Navigator.of(context).pushNamed(data.widgeturl,
                  arguments: RouteArgumentCertificate(
                      id: data.id, heroTag: data.text.data));
            }
        ),)
            .toList(),
      ));
  List<ExpansionTile> _listOfExpansions = List<ExpansionTile>.generate(
      1,
          (i) => ExpansionTile(
           leading: Icon(Icons.report),
            title: Align(alignment:Alignment.centerLeft,child:Text("Manage Reports",
                style: TextStyle(
                    fontSize: getFontSize(context,2),
                    fontFamily: "AVENIRLTSTD",
                    // fontWeight: FontWeight.bold,
                    color: Color(0xff222222))),),

        children: [
  DrawerList(
      id:5,
      icon: Icons.arrow_right,
      text: Text("Compliant Report",
          style: TextStyle(
              fontSize: getFontSize(context,1),
              fontFamily: "AVENIRLTSTD",
              // fontWeight: FontWeight.bold,
              color: Color(0xff222222))),
      widgeturl: "/NoticeReport"),
  DrawerList(
      id:6,
      icon: Icons.arrow_right,
      text: Text("Non Compliant Report",
          style: TextStyle(
              fontSize: getFontSize(context,1),
              fontFamily: "AVENIRLTSTD",
              // fontWeight: FontWeight.bold,
              color: Color(0xff222222))),
      widgeturl: "/NoticeReport"),
  DrawerList(
      id:7,
      icon: Icons.arrow_right,
      text:  Text("Notice of Improvement",
          style: TextStyle(
              fontSize: getFontSize(context,1),
              fontFamily: "AVENIRLTSTD",
              // fontWeight: FontWeight.bold,
              color: Color(0xff222222))),
      widgeturl: "/NoticeReport"),

]
            .map((data) => ListTile(

            leading: Icon(data.icon),
            title: data.text,
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Home', (Route<dynamic> route) => false);
              Navigator.of(context).pushNamed(data.widgeturl,
                  arguments: RouteArgumentReport(
                      id: data.id, heroTag: data.text.data));
            }
        ),)
            .toList(),
      ));
      List<DrawerList> drawerlist = [
  DrawerList(      icon: Icons.home, text:  Text("Dashboard",
      style: TextStyle(
          fontSize: getFontSize(context,2),
          fontFamily: "AVENIRLTSTD",
          // fontWeight: FontWeight.bold,
          color: Color(0xff222222))), widgeturl: "/Home"  ,id:0,),
  DrawerList(
      icon: Icons.add, text:  Text("Add Inspector",
      style: TextStyle(
          fontSize: getFontSize(context,2),
          fontFamily: "AVENIRLTSTD",
          // fontWeight: FontWeight.bold,
          color: Color(0xff222222))), widgeturl: "/AddInspector"),

  DrawerList(
      id:8,
      icon: Icons.book,
      text:  Text("Manage Bookings",
          style: TextStyle(
              fontSize: getFontSize(context,2),
              fontFamily: "AVENIRLTSTD",
              // fontWeight: FontWeight.bold,
              color: Color(0xff222222))),
      widgeturl: "/ManageBookings"),
  DrawerList(
      id:9,
      icon: Icons.library_books,
      text:  Text("Inspector Invoice",
          style: TextStyle(
              fontSize: getFontSize(context,2),
              fontFamily: "AVENIRLTSTD",
              // fontWeight: FontWeight.bold,
              color: Color(0xff222222))),
      widgeturl: "/InspectorInvoice"),
  DrawerList(
      id:10,
      icon: Icons.credit_card,
      text:  Text("Card Details",
          style: TextStyle(
              fontSize: getFontSize(context,2),
              fontFamily: "AVENIRLTSTD",
              // fontWeight: FontWeight.bold,
              color: Color(0xff222222))),
      widgeturl: "/AddCardDetail"),
  DrawerList(
      id:11,
      icon: Icons.account_balance,
      text:  Text("Bank Details",
          style: TextStyle(
              fontSize: getFontSize(context,2),
              fontFamily: "AVENIRLTSTD",
              // fontWeight: FontWeight.bold,
              color: Color(0xff222222))),
      widgeturl: "/BankDetails"),
  DrawerList(
      id:12,
      icon: Icons.library_books,
      text:  Text("Your Invoices",
          style: TextStyle(
              fontSize: getFontSize(context,2),
              fontFamily: "AVENIRLTSTD",
              // fontWeight: FontWeight.bold,
              color: Color(0xff222222))),
      widgeturl: "/GetInvoiceList"),
  // DrawerList(icon: Icons.list, text: "Enquiry List", widgeturl: "Home"),
  DrawerList(         icon: Icons.input, text: Text("Log Out",
      style: TextStyle(
          fontSize: getFontSize(context,2),
          fontFamily: "AVENIRLTSTD",
          // fontWeight: FontWeight.bold,
          color: Color(0xff222222))), widgeturl: "",  id:13,)
];
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          // width: MediaQuery.of(context).size.width * 1 / 4,
          height: MediaQuery.of(context).size.height * 1 / 4,
          child: DrawerHeader(
            child: Image.asset(
              "assets/img/logo.png",
              // fit: BoxFit.cover,
              fit: BoxFit.contain,
            ),
           
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height * 2 / 3,
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,

            children: <Widget>[


              ListTile(
                  leading: Icon(drawerlist[0].icon),
                  title: (drawerlist[0].text),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, drawerlist[0].widgeturl,(Route<dynamic> route) => false);
                  }),
              rolesManage == 2
                  ? ListTile(
                      leading: Icon(drawerlist[1].icon),
                      title: drawerlist[1].text,
                      onTap: () {
                        Navigator.pushNamed(context, drawerlist[1].widgeturl);
                      })
                  : Container(),
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children:
                _listOfExpansionsCertificate.map((expansionTile) => expansionTile).toList(),
              ),
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children:
                _listOfExpansions.map((expansionTile) => expansionTile).toList(),
              ),

              ListTile(
                  leading: Icon(drawerlist[2].icon),
                  title: drawerlist[2].text,
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Home', (Route<dynamic> route) => false);
                    Navigator.of(context).pushNamed('/ManageBookings',
                        arguments: RouteArgumentHome(
                            id: 5, role: 1));
                  }),

              ListTile(
                  leading: Icon(drawerlist[3].icon),
                  title: drawerlist[3].text,
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Home', (Route<dynamic> route) => false);
                    Navigator.of(context).pushNamed('/InspectorInvoice',
                        arguments: RouteArgumentReport(
                            id: 6, heroTag: drawerlist[3].text.data));
                  }),

              ListTile(
                  leading: Icon(drawerlist[4].icon),
                  title: drawerlist[4].text,
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Home', (Route<dynamic> route) => false);
                    Navigator.of(context).pushNamed('/AddCardDetail',
                        arguments: RouteArgumentReport(
                            id: 7, heroTag: drawerlist[4].text.data));
                  }),
              ListTile(
                  leading: Icon(drawerlist[5].icon),
                  title: drawerlist[5].text,
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Home', (Route<dynamic> route) => false);
                    Navigator.of(context).pushNamed('/BankDetails',
                        arguments: RouteArgumentReport(
                            id: 8, heroTag: drawerlist[5].text.data));
                  }),
              ListTile(
                  leading: Icon(drawerlist[6].icon),
                  title: (drawerlist[6].text),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Home', (Route<dynamic> route) => false);
                    Navigator.of(context).pushNamed('/GetInvoiceList',
                        arguments: RouteArgumentReport(
                            id: 9, heroTag: drawerlist[6].text.data));
                  }),
              ListTile(
                  leading: Icon(drawerlist[7].icon),
                  title: drawerlist[7].text,
                  onTap: () {
                    UserSharedPreferencesHelper.logout().then((val) {
                      userRepo.token=null;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/Login', (Route<dynamic> route) => false);

                    });
                  })
            ],
          ),
        ),
      ],
    ),
  );
}
