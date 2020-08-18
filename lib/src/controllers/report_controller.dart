import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:poolinspection/constants.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/src/repository/user_repository.dart';

class ReportController extends ControllerMVC {
  var noticeofcompliant;
  int choice;
  double percentage;
  bool progressDone;
  ReportController() {
    percentage = 0.0;
    progressDone = false;
  }
  Future reportsList(int userid, int choice) async {
    final String _apiToken = 'beedev';
    final String url =
        '$publicBaseUrl$_apiToken/compliant_report_list/$userid/$choice';
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
       print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      return Exception('Failed to load post');
    }
  }

  Future onRefresh() async {
    reportsList(user.id, choice).then((onValue) {
      setState(() {
        noticeofcompliant = onValue;
        print(noticeofcompliant);
      });
    });
  }

}
