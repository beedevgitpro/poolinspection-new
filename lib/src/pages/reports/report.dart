import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/report_controller.dart';
import 'package:poolinspection/src/models/reportmodel.dart';
import 'package:poolinspection/src/models/route_argument.dart';
import 'package:poolinspection/src/repository/user_repository.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:strings/strings.dart';

class NoticeReport extends StatefulWidget {
  final RouteArgumentReport routeArgument;
  NoticeReport({Key key, this.routeArgument}) : super(key: key);

  @override
  _NoticeReportState createState() => _NoticeReportState();
}

class _NoticeReportState extends StateMVC<NoticeReport> {
  ReportController _con;
  ReportModel model = new ReportModel();
  _NoticeReportState() : super(ReportController()) {
    _con = controller;
  }
  @override
  void initState() {
    _con.choice = widget.routeArgument.id;

    _con.reportsList(user.id, widget.routeArgument.id-4).then((onValue) {
      setState(() {
        _con.noticeofcompliant = onValue;
        print(onValue);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: config.Colors().scaffoldColor(1),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: config.Colors().secondColor(1),
            ),
            onPressed: () => Navigator.pop(context)),
            centerTitle: true,
        title: Text(
          widget.routeArgument.heroTag,
          style: TextStyle(
            fontFamily: "AVENIRLTSTD",
          ),
        ),
        actions: [Image.asset(
            "assets/img/app-iconwhite.jpg",
            // fit: BoxFit.cover,
            fit: BoxFit.fitWidth,
          )],
      
      ),
      body: RefreshIndicator(
        onRefresh: _con.onRefresh,
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: _con.noticeofcompliant == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _con.noticeofcompliant['compliant_report_list'].length == 0
                  ? Center(child: Text("No Records Found.",style: TextStyle(color: Colors.black,fontSize: getFontSize(context,2)),))
                  : ListView.builder(
                      itemCount: _con
                          .noticeofcompliant['compliant_report_list'].length,
                      itemBuilder: (context, i) => Card(
                            child: Container(
                              child: ListTile(
                                // leading: CircleAvatar(
                                //     child: Text(
                                //         "${model.compliantReportList[i].id}")),
                                onTap: () {
//                                  ReportModel model = ReportModel.fromJson(
//                                      _con.noticeofcompliant);
//                                  Navigator.push(
//                                    context,
//                                    MaterialPageRoute(
//                                        builder: (context) =>
//                                            ReportDetailWidget(
//                                              routeArgument:
//                                                  model.compliantReportList[i],
//                                            )),
//                                    // );
//                                  );
                                },
                                trailing: Card(
                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                    
                                  color: Colors.blueAccent,
                                  child: Padding(
                                    padding:  EdgeInsets.all(5.0),
                                    child: Text(
                                        "${DateFormat("yMMMMd").format(DateTime.parse(_con.noticeofcompliant['compliant_report_list'][i]['booking_date_time']))}",
                                        style: TextStyle(
                                            fontSize: getFontSize(context,-2),
                                            fontFamily: "AVENIRLTSTD",
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                ),
                                title:Padding(
                                  padding:  EdgeInsets.all(5.0),
                                  child:  Text(
                                    capitalize("${_con.noticeofcompliant['compliant_report_list'][i]['owner_name'].toString()}"),
                                    style: TextStyle(
                                        fontSize: getFontSize(context,2),
                                        color: Color(0xff222222),
                                        fontFamily: "AVENIRLTSTD",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                                  child: Text(
                                    "${_con.noticeofcompliant['compliant_report_list'][i]['email_owner']}",
                                    style: TextStyle(
                                        fontSize: getFontSize(context,0),
                                        color: Color(0xff222222),
                                        fontFamily: "AVENIRLTSTD",
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )),
        ),
      ),
    );
  }
}
