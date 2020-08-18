import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/models/PostBookingAnswerModel.dart';
import 'package:poolinspection/src/models/route_argument.dart';
import 'package:poolinspection/src/pages/home/SelectNoticeOrNonCompliant.dart';
import 'package:poolinspection/src/pages/inspection/inspectionquestion.dart';
import 'package:poolinspection/src/pages/utils/customradio.dart';
import 'package:poolinspection/src/repository/booking_repository.dart'
    as repository;
import 'package:strings/strings.dart';

class QuestionData {
  String comment;
  String choice;
  String headingid;

  String questionId;
  String bookingID;
  int bookingAnsId;

  List<String> imagepath=new List<String>();
  List<String> imagename=new List<String>();

  QuestionData({
    this.comment,
    this.choice,
    this.questionId,
    this.bookingID,
    this.headingid,
    this.imagename,
    this.bookingAnsId,
  });
}

class InspectionController extends ControllerMVC {
  bool confirmLoader = false;
  String bookingIdforStore;
  String headingIdforStore;
  String questionIdforStore;
  File questionImg;
  var offlineimages;
  List<String> fileName=new List<String>();
  List<String> path=new List<String>();
  //Map<String, String> paths;
  String extension;
  bool loadingPath = false;
  bool multiPick = true;
  bool hasValidMime = false;
  FileType pickingType;
  GlobalKey<ScaffoldState> scaffoldKey;
  List headingslist;

  List<QuestionData> questiondatalist =new List<QuestionData>();
  List questionslist;
  List tempquestionlist;
  List questionsCount;
  List headingQuestionsPending;
  QuestionData data;

  String offlinedatastringforappend;
  List<Asset> resultList1;

  List<RadioModel> sampleData = new List<RadioModel>();

  String error = 'No Error Dectected';
  InspectionController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    headingslist = List();
    headingQuestionsPending = List();
    questionslist = List();
    tempquestionlist=List();
    questionsCount = List();
    path=List<String>();
    fileName=List<String>();
    data = QuestionData() ;

    resultList1 = List<Asset>();
    // getAllRegulations();
    // getHeadersFromRegulationsId();
    // repository.getQuestionsFromHeadingId();
  }

  getheadings(var bookingid) async {


      repository.getHeadersFromBookingId(bookingid,context).then((onValue) {
        try {
        print("modify=" + onValue.toString());
     //   onValue!=null?StoreListDataInLocal(json.encode(onValue).toString(),bookingid.toString()):null; //important line
        setState(() {
          for (var i = 0;
          i < onValue['get_heading_from_regulationid'].length;
          i++) {
            // repository
            //   .getAllQuestionsCountFromHeading(bookingid,
            //       onValue['get_heading_from_regulationid'][i]['heading_id'])
            //   .then((val) {
            // onValue['get_heading_from_regulationid'][i]['remaining'] =
            //     val['not_answered'];
            // print(onValue);

            headingslist.add(onValue['get_heading_from_regulationid'][i]);

            print("headinglistinfo" + headingslist.toString());
            //  print("headingdescr="+headingslist[i]['heading_description'].toString());
            // });
          }
          // print(headingslist);
        });
        // print(onValue);
        }catch(e)
        {
//          Fluttertoast.showToast(
//              msg: "Error in Getting Inspection"+onValue.toString(),
//              toastLength: Toast.LENGTH_LONG,
//              gravity: ToastGravity.BOTTOM,
//              timeInSecForIosWeb: 1,
//              backgroundColor: Colors.redAccent,
//              textColor: Colors.white,
//              fontSize: getFontSize(context,-2)
//          );
        }
      }
      );

  }

  Future<void> getquestions(int headingId, int booking) async {
    repository.getQuestionsFromHeadingId(headingId, booking,context).then((onValue) {
      if(onValue!=null)storeQuestionListInLocal(json.encode(onValue).toString(),headingId.toString(),booking.toString());

      try {
        setState(() {
          for (var i = 0; i < onValue['questions_from_headingId'].length; i++) {
            questionslist.add(onValue['questions_from_headingId'][i]);
          }
          print("1234" + questionslist.toString());
        });
      }
      catch(e)
      {
        print("error in get heading because="+e.toString());
      }

    });
  }

  bool questionpending = false;
  int questionpendingcount;
  int allquestionscount;
  double percent;
  getQuestionsFilled(int jobid) {
    questionpendingcount = 0;
    allquestionscount = 0;
    percent = 0;
    questionpending = false;
    print("jobidorbookingid"+jobid.toString());
    repository.getAllQuestionsCount(jobid).then((onValue) {
      if(onValue!=null)storeQuestionNumbersInLocal(json.encode(onValue).toString(),jobid.toString());
      setState(() {
        for (var i = 0; i < onValue['questions_from_headingId'].length; i++) {
          if (onValue['questions_from_headingId'][i]['ans'] == null) {
            questionpending = true;
            questionpendingcount++;
          }
          allquestionscount++;
        }

        print(questionpending);
        print(questionpendingcount);
        print(allquestionscount);
        percent = ((allquestionscount - questionpendingcount) *
                100 /
                allquestionscount)
            .roundToDouble();
      });
    });
  }

  postMarkComplete(int bookingid, int choice, BuildContext context) {
    print(bookingid);
    print(choice);

    repository.completeMark(bookingid, choice).then((onValue) {
      Navigator.pushNamedAndRemoveUntil(context,'/Home',(Route<dynamic> route) => false);
      Navigator.of(context).pushNamed("/Certificate",
          arguments: RouteArgumentCertificate(
              id: choice+1, heroTag: choice==1?"Compliant":"Notice of Improvement")); //here choice is on drawer for all categories
      Flushbar(
        title: "Successful Submission",
        message: "Inspection Completed",
        duration: Duration(seconds: 3),
      )..show(context);
    });
  }

  bool validate = false;

  getPostQuestions(int entryIndex,int questionindex,int index,  BuildContext context,qlist,pr,{bool isDialog=false}) { //this new addition of question index can break code for online
    
    setState(() {
      sampleData.forEach((element) => element.isSelected = false);
      sampleData[index].isSelected = true;
      
      switch (index) {
        case 0:
          data.choice = "2";
          break;
        case 1:
          data.choice = "3";
          break;
        case 2:         //may be code break here
          data.choice = "1";
          break;
        case 3:
          data.choice = "10";
          break;
        case 4:         //may be code break here
          data.choice = "11";
          break;
        default:
          data.choice = "";
          break;
      }
    });

    data.imagename=[];
    data.imagepath=[];
    print("filename"+fileName.toString());
    print("data.imagename"+data.imagename.toString());

   fileName.length==0?data.imagename=null:data.imagename.addAll(fileName);
    path.length==0?data.imagepath=null:data.imagepath.addAll(path);
      print("imagePAthonController"+data.imagepath.toString());

    repository.postBookingAnswer(data,context).then((val) {
     if(val=="No Internet")
       {
         if(data.choice=="3"||data.choice=="4")
         {pr.hide();
           Navigator.of(context).pop(false);}else pr.hide();

       

         readQuestionAnswerCounter().then((onValue) {
         print("readvalue"+onValue.toString());




             if(onValue!=null && onValue.toString().isNotEmpty)
             {
               if(data.choice=="3") {
                 print("data image length"+data.imagename.length.toString());
                 print("data image path"+data.imagepath.toString());
                 String img64="";
                 for(var i = 0; i < data.imagename.length; i++) {
                   final bytes = File(data.imagepath[i]).readAsBytesSync();
                   img64='"data:image/png;base64,${base64Encode(bytes).toString()}"'+",";
                 }
                 img64=img64.toString().substring(0,img64.length-1);
                 print("imgimgimg"+img64);
                 String finalimglist="["+img64+"]";

                 print("finalimg="+finalimglist.toString());

                 storeQuestionAnswerInLocal(onValue.toString()+","+

                     {
                       '"bookin_ans_id"':data.bookingAnsId.toString(),
                       '"ans"':data.choice.toString(),
                       '"question_id"':data.questionId.toString(),
                       '"booking_id"':data.bookingID,
                       '"comment"':'"${data.comment.toString()}"',
                       '"images"':finalimglist
                     }.toString(), "questionanswer");
               }  else {

                 storeQuestionAnswerInLocal(onValue.toString()+","+

                     {
                       '"bookin_ans_id"':data.bookingAnsId.toString(),
                       '"ans"':data.choice.toString(),
                       '"question_id"':data.questionId.toString(),
                       '"booking_id"':data.bookingID,
                       '"comment"':null,
                     }.toString(), "questionanswer");
               }
             }
             else
             {

               if(data.choice=="3") {

                 print("data image length"+data.imagename.length.toString());
                 print("data image path"+data.imagepath.toString());
                 String img64="";
                 for(var i = 0; i < data.imagename.length; i++) {
                   final bytes = File(data.imagepath[i]).readAsBytesSync();
                   img64='"data:image/png;base64,${base64Encode(bytes).toString()}"'+",";
                   //  print("imgdata:"+base64Encode(bytes).toString());
                 }
                img64=img64.toString().substring(0,img64.length-1);
                 print("imgimgimg"+img64);
                 String finalimglist="["+img64+"]";
                 storeQuestionAnswerInLocal(
                     {
                       '"bookin_ans_id"':data.bookingAnsId.toString(),
                       '"ans"':data.choice.toString(),
                       '"question_id"':data.questionId.toString(),
                       '"booking_id"':data.bookingID,
                       '"comment"':'"${data.comment.toString()}"',
                       '"images"':finalimglist
                     }.toString(), "questionanswer");
               }
                 else {

                   storeQuestionAnswerInLocal(
                       {
                         '"bookin_ans_id"':data.bookingAnsId.toString(),
                         '"ans"':data.choice.toString(),
                         '"question_id"':data.questionId.toString(),
                         '"booking_id"':data.bookingID,
                         '"comment"':null,
                       }.toString(), "questionanswer");
               }
             }
         });

       }
     else
       {
        pr.hide();

         if(data.choice=="3"||data.choice=="4")
           {
             
             Navigator.of(context).pop(true);}
         PostBookingAnswerModel postBookingAnswerModel;

         try {
           postBookingAnswerModel = PostBookingAnswerModel.fromJson(val);

           if(postBookingAnswerModel.status.toString()=="compliant")
           {

             Navigator.pushNamedAndRemoveUntil(context,'/Home',(Route<dynamic> route) => false);
             Navigator.of(context).pushNamed("/Certificate",
                 arguments: RouteArgumentCertificate(
                     id: 2, heroTag:"Compliant"));
           }

           if(postBookingAnswerModel.status.toString()=="non-compliant")
           {

             Navigator.pushAndRemoveUntil(
               context,
               MaterialPageRoute(builder: (context) => SelectNoticeOrNonCompliant(data.bookingID.toString())),
               (r)=>r.isFirst
             );

           }


           if(postBookingAnswerModel.status.toString()=="pass") {
            if((questionindex+1)<(qlist.length))
                                       {
                                         
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>InspectionQuestion(entryIndex,
                                                    qlist[questionindex+1], questionindex+1,qlist)));
                                        }
                                        else
                                        
                                       {
                                         
                                          for(int i=entryIndex; i < (qlist.length);i++)
                                        Navigator.pop(context);}
           }
           else
           {
     Fluttertoast.showToast(
         msg: "Status:"+capitalize(postBookingAnswerModel.status.toString()),
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.red,
         textColor: Colors.white,
         fontSize: getFontSize(context,-2)
     );
           }


         }
         catch (e) {
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
    }


    );
  }





  storeQuestionNumbersInLocal(var onValue, String name)
  {
    bookingIdforStore=name.toString();
    writeQuestionCounter(onValue,name);


  }
  Future<String> get _localQuestionPath async {
    final directory = await getApplicationDocumentsDirectory(); //maybe for ios permission issue you have to change it into getApplicationSupportDirectorytype kuch.

    return directory.path;
  }

  Future<File> get _localQuestionFile async {
    final path = await _localQuestionPath;
    // print("pathpath="+path.toString());
    return File('$path/quesnumbers$bookingIdforStore.txt');
  }

  Future<File> writeQuestionCounter(var onValue,String name) async {
    final file = await _localQuestionFile;
    return file.writeAsString(onValue.toString());
  }
  Future<String> readQuestionCounter(String bookingId) async {

    try {
      final file = await _localQuestionFile;
      bookingIdforStore=bookingId.toString();

      // Read the file
      String contents = await file.readAsString();
     // print("questioncontent="+contents.toString());
      return contents.toString();
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }






  storeQuestionListInLocal(var onValue, String headingId,String questionId)
  {
   // print("headinglistquestionld"+headingId.toString()+questionId.toString());
   headingIdforStore=headingId;
   questionIdforStore=questionId;
    writeQuestionListCounter(onValue,headingId,questionId);


  }
  Future<String> get _localQuestionListPath async {
    final directory = await getApplicationDocumentsDirectory(); //maybe for ios permission issue you have to change it into getApplicationSupportDirectorytype kuch.

    return directory.path;
  }

  Future<File> get _localQuestionListFile async {
    final path = await _localQuestionListPath;
    // print("pathpath="+path.toString());
    return File('$path/$headingIdforStore$questionIdforStore.txt');
  }

  Future<File> writeQuestionListCounter(var onValue,String headingId,String questionid) async {
  //  print("bookbookidwrite"+headingId.toString()+questionid.toString());
    final file = await _localQuestionListFile;

    // Write the file
   // print("writedquestionlistdone="+onValue.toString());
    return file.writeAsString(onValue.toString());
  }
  Future<String> readQuestionListCounter(String headingIdread,String questionidread) async {
    headingIdforStore=headingIdread;
    questionIdforStore=questionidread;
    try {
      final file = await _localQuestionListFile;

      // Read the file
    //  print("pathpath="+file.path.toString());
     // print("bookbookidread"+headingIdforStore.toString()+questionIdforStore.toString());
      String contents = await file.readAsString();
     // print("questionlistcontent="+contents.toString());
      return contents.toString();
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }
  storeQuestionAnswerInLocal(var onValue, String name)
  {
    //print("questionanswer"+onValue.toString());
    writeQuestionAnswerCounter(onValue,name);


  }
  Future<String> get _localQuestionAnswerPath async {
    final directory = await getApplicationDocumentsDirectory(); //maybe for ios permission issue you have to change it into getApplicationSupportDirectorytype kuch.

    return directory.path;
  }

  Future<File> get _localQuestionAnswerFile async {
    final path = await _localQuestionAnswerPath;

    return File('$path/newpoolqu.txt');
  }

  Future<File> writeQuestionAnswerCounter(var onValue,String name) async {
    final file = await _localQuestionAnswerFile;

    // Write the file
    print("writequestionanswerdone="+onValue.toString());
     print("pathpath="+file.toString());
    return file.writeAsString(onValue.toString());
  }

  Future<String> readQuestionAnswerCounter() async {
    try {
      final file = await _localQuestionAnswerFile;

      // Read the file
      String contents = await file.readAsString();
      print("questionanswercontent="+contents.toString());
      return contents.toString();
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }



}