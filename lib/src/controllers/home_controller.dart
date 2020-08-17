import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/user_controller.dart';
import 'package:poolinspection/src/helpers/sharedpreferences/userpreferences.dart';
import 'package:poolinspection/src/models/user.dart';
import 'package:poolinspection/src/repository/user_repository.dart'
    as repository;
import 'package:http/http.dart' as http;


class HomeController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  var listdata;


  HomeController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  fetchData() {
    UserSharedPreferencesHelper.getUserDetails().then((user) {
      if (user != null) {
        repository.user = user;
        dashBoardBloc(user.id).then((onValue) {


          setState(() {
            listdata = onValue;


          //  print("onValuedrawer="+onValue.toString());
            if (listdata == 1) {
              Navigator.of(scaffoldKey.currentContext)
                  .pushReplacementNamed('/Login');
            }
          });
        });
        getInspector(user.id).then((onValue) {
          print(onValue);
          repository.inspector =
              Inspector.fromJSON(onValue['get_logged_in_user_data'][0]);
        });
      } else {
        Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Login');
      }
    });
  }

  Future dashBoardBloc(int userid) async {
    print("ID"+userid.toString());
    final String apiToken = 'beedev';
   try {
     final String url =
         '${GlobalConfiguration().getString(
         'api_base_url')}$apiToken/dashboard_list/$userid';
     final response = await http.get(url);
     if (response.statusCode == 200) {
       storeListDataInLocal(response.body,"listdata");

       return json.decode(response.body);
     } else {
       return 1;
     }
   }
   on TimeoutException catch (_) {
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
   on SocketException catch (_) {
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
    // }
  }

  Future getInspector(int userid) async {
    final String urlInspector =
        '${GlobalConfiguration().getString('api_base_url')}$apiToken/get_logged_in_user_data/$userid';
    final response = await http.get(urlInspector);
    if (response.statusCode == 200) {
      // print(response.body);
      return json.decode(response.body);
    } else {
      return Exception('Failed to load post');
    }
    // }
  }

  storeListDataInLocal(var onValue, String name)
  {

    writeCounter(onValue,name);


  }
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory(); //maybe for ios permission issue you have to change it into getApplicationSupportDirectorytype kuch.

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
   // print("pathpath="+path.toString());
    return File('$path/listdataa.json');
  }

  Future<File> writeCounter(var onValue,String name) async {
    final file = await _localFile;

    // Write the file
   // print("writeddone="+onValue.toString());
    return file.writeAsString(onValue.toString());
  }
  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
    // print("content="+contents.toString());
      return contents.toString();
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }
}

