
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:poolinspection/constants.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/components/responsive_text.dart';
import 'package:poolinspection/src/controllers/inspection_controller.dart';
import 'package:poolinspection/src/models/DeleteImageModel.dart';
import 'package:poolinspection/src/pages/utils/MyDialogMobile.dart';
import 'package:poolinspection/src/pages/utils/MyDialogTablet.dart';
import 'package:poolinspection/src/pages/utils/customradio.dart';
import 'package:poolinspection/src/elements/custom_progress_dialog.dart';


class InspectionQuestion extends StatefulWidget {
  
  var question;
  int i;
  var questionsList;

  InspectionQuestion(this.question, this.i,this.questionsList);

  @override
  _InspectionQuestionState createState() => _InspectionQuestionState();
}

class _InspectionQuestionState extends StateMVC<InspectionQuestion> {
  InspectionController _inspectionController;


  int showCommentAndImages=0;
  int indexOfRectificationorNonCompliance=-1;
  bool filter = false;
  List<String> parts=[];
  List<String> partImageName=[];

  _InspectionQuestionState() : super(InspectionController()) {
    _inspectionController = controller;
  }



  Future clearImage(int bookingAnswerId, image,int bookingId,int indexofimage) async
  {
    ProgressDialog pr;
    pr = ProgressDialog(context,isDismissible: false);
   
    try {
      pr.show();

      final response = await http.post(
          '$baseUrl/beedev/remove-booking-ans-image',
          body: {
            'booking_ans_id': bookingAnswerId.toString(),
            'image':image,
            'booking_id':bookingId.toString(),

          }
      );

      DeleteImageModel imagedelete = deleteImageModelFromJson(response.body);


     if(imagedelete.status=="success") {
       pr.hide();

             Fluttertoast.showToast(
          msg: "Image Deleted Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );

       setState(() {

         partImageName.removeAt(indexofimage);

       });
     }else
       {
         pr.hide();
         Fluttertoast.showToast(
             msg: imagedelete.messages.toString(),
             toastLength: Toast.LENGTH_LONG,
             gravity: ToastGravity.BOTTOM,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.blue,
             textColor: Colors.white,
             fontSize: getFontSize(context,-2)
         );

       }

    }catch(e)
    {
      pr.hide();
      print("ErrorInDeleteImageBackend"+e.toString());
      Fluttertoast.showToast(
          msg: "ErrorInDeleteImageBackend"+e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getFontSize(context,-2)
      );
    }

  }


  @override
  void initState() {
    super.initState();
    print('Index: '+widget.i.toString());
    print("soclose"+widget.question['heading_id'].toString());
    if(widget.question['images']=='')widget.question['images']=null;
    _inspectionController.data.bookingAnsId = widget.question['id'];
    _inspectionController.data.comment = widget.question['comment'];
    _inspectionController.data.bookingID=widget.question['booking_id'].toString();
    _inspectionController.data.questionId=widget.question['quesion_id'].toString();
    _inspectionController.data.headingid=widget.question['heading_id'].toString();
    String input = "qqqqq";
    String imagetemp = "";
    widget.question['file_name']!=null?input=GlobalConfiguration().getString('api_question_image').toString()+widget.question['hint_img_destination'].toString()+"/"+widget.question['file_name'].toString():input="qwww";
    if(widget.question['images']!=null)imagetemp=widget.question['images'];
    parts = input.split(",");
    partImageName= imagetemp==""?[]:imagetemp.split(",");

    print("totalImage$partImageName");
    print("totalImagelength${partImageName.length}");
   // print("hintbaseurl"+GlobalConfiguration().getString('api_question_image').toString()+widget.question['hint_img_destination'].toString()+"/"+parts[0].toString());
    switch (widget.question['ans']) {
      case "2":
        print("${widget.question['ans']} compliant");
        _inspectionController.sampleData.add(new RadioModel(true, 'Compliant', 'April 18'));
    //    _con.sampleData.add(new RadioModel(false, 'Rectification Required', 'April 17'));
        _inspectionController.sampleData.add(new RadioModel(false, 'Non Compliant', 'April 17'));
        _inspectionController.sampleData
            .add(new RadioModel(false, 'Not Applicable', 'April 16'));
        break;
      case "3":
        print("${widget.question['ans']} noncompliant");

        _inspectionController.sampleData.add(new RadioModel(false, 'Compliant', 'April 18'));
       // _con.sampleData.add(new RadioModel(false, 'Rectification Required', 'April 17'));
        _inspectionController.sampleData.add(new RadioModel(true, 'Non Compliant', 'April 17'));
        _inspectionController.sampleData
            .add(new RadioModel(false, 'Not Applicable', 'April 16'));
        break;
      case "1":
        print("${widget.question['ans']} not applicable");

        _inspectionController.sampleData.add(new RadioModel(false, 'Compliant', 'April 18'));
       // _con.sampleData.add(new RadioModel(false, 'Rectification Required', 'April 17'));
        _inspectionController.sampleData.add(new RadioModel(false, 'Non Compliant', 'April 17'));
        _inspectionController.sampleData.add(new RadioModel(true, 'Not Applicable', 'April 16'));
        break;

      case "10":
        print("${widget.question['ans']} yes");
        _inspectionController.sampleData.add(new RadioModel(false, 'Compliant', 'April 18'));
        // _con.sampleData.add(new RadioModel(false, 'Rectification Required', 'April 17'));
        _inspectionController.sampleData.add(new RadioModel(false, 'Non Compliant', 'April 17'));
        _inspectionController.sampleData.add(new RadioModel(false, 'Not Applicable', 'April 16'));
        _inspectionController.sampleData.add(new RadioModel(true, 'Yes', 'April 18'));
        // _con.sampleData.add(new RadioModel(false, 'Rectification Required', 'April 17'));
        _inspectionController.sampleData.add(new RadioModel(false, 'No', 'April 17'));
        break;

      case "11":
        print("${widget.question['ans']} no");
        _inspectionController.sampleData.add(new RadioModel(false, 'Compliant', 'April 18'));
        // _con.sampleData.add(new RadioModel(false, 'Rectification Required', 'April 17'));
        _inspectionController.sampleData.add(new RadioModel(false, 'Non Compliant', 'April 17'));
        _inspectionController.sampleData.add(new RadioModel(false, 'Not Applicable', 'April 16'));
        _inspectionController.sampleData.add(new RadioModel(false, 'Yes', 'April 18'));
        // _con.sampleData.add(new RadioModel(false, 'Rectification Required', 'April 17'));
        _inspectionController.sampleData.add(new RadioModel(true, 'No', 'April 17'));

        break;
      default:
        _inspectionController.sampleData.add(new RadioModel(false, 'Compliant', 'April 18'));
       // _con.sampleData.add(new RadioModel(false, 'Rectification Required', 'April 17'));
        _inspectionController.sampleData.add(new RadioModel(false, 'Non Compliant', 'April 17'));
        _inspectionController.sampleData
            .add(new RadioModel(false, 'Not Applicable', 'April 16'));
        _inspectionController.sampleData.add(new RadioModel(false, 'Yes', 'April 18'));
        // _con.sampleData.add(new RadioModel(false, 'Rectification Required', 'April 17'));
        _inspectionController.sampleData.add(new RadioModel(false, 'No', 'April 17'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.Colors().scaffoldColor(1),
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: config.Colors().secondColor(1),
            ),
            onPressed: () => Navigator.pop(context,true)),
        title: Align(alignment: Alignment.topCenter,
          child:Text("Building Regulations              ",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: "AVENIRLTSTD",
              fontSize: getFontSize(context,2),
              color: Color(0xff222222),
            ),
          ),

        ),
        actions: <Widget>[
          Image.asset(
            "assets/img/app-iconwhite.jpg",
            // fit: BoxFit.cover,
            fit: BoxFit.fitWidth,
          )

        ],
      ),


      body: widget.question == null
          ? CircularProgressIndicator()
          : Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 10,
            child: SingleChildScrollView(
              child: Container(

                  decoration: BoxDecoration(color: Colors.white),
                  child:  Padding(
                    padding: EdgeInsets.fromLTRB(18, 10,10, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child:Text("REGULATION NAME: "+widget.question['regulation_name'].toString(),style: TextStyle(fontSize: getFontSize(context,3), color: Colors.black,  fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.w700),),
                    ),
                  )
              ),
            ),
          ),

          SizedBox(height: 20,),
          Flexible(
           flex: 8,
         child:SingleChildScrollView(
           child:  Padding(
             padding: EdgeInsets.fromLTRB(20, 8, 8, 8),
             child:Text(widget.question['heading_name'].toString(),
               style: TextStyle(fontSize: getFontSize(context,2), color: Colors.black,  fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.w700),),),
         )

         ),
          MediaQuery.of(context).size.width<=600?Expanded(
            flex: 40,
            child: Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child:  Container(
                  color: Theme.of(context).primaryColor,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                     SizedBox(height: 10,),
                     ListTile(
                         title: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Expanded(child:Align(

                               child: Padding(
                                 padding: EdgeInsets.fromLTRB(8, 4, 8, 6),
                                 child: Text(
                                   ("Q${widget.i + 1}.").toString()+" "+widget.question['question'],
                                   // demo,
                                   textAlign: TextAlign.left,
                                   style: TextStyle(
                                       fontSize: getFontSize(context,3),
                                       // fontWeight: FontWeight.w500,
                                       fontFamily: "AVENIRLTSTD",
                                       color: Color(0xff222222)),
                                 ),
                               ),
                               alignment: Alignment.centerLeft,
                             )
                             ),

                           ],),

                         subtitle:Padding(
                           padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                           child: GestureDetector(
                             onTap: ()
                             {
                               bool show=false;

                                 showDialog(
                                   context: context,
                                   builder: (BuildContext context) {
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
                                              child:  Text(
                                                widget.question['hint']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontFamily: "AVENIRLTSTD",
                                                    color: Colors.black,
                                                    fontSize: getFontSize(context,0)),
                                              ),
                                            )
                                             ),
                                             SizedBox(height: 20,),
                                             widget.question['file_name']!=null?Flexible(
                                                 child: GestureDetector(

                                                   child: Text(
                                                     "Show Image",
                                                     style: TextStyle(
                                                         fontFamily: "AVENIRLTSTD",
                                                         color: Colors.blueAccent,
                                                         fontSize: getFontSize(context,0)),
                                                   ),
                                                   onTap: () {
                             setState(() {
                               print("imgend"+GlobalConfiguration().getString('api_question_image').toString()+widget.question['destination'].toString()+widget.question['file_name'].toString());
                              
                               show == false
                                   ? show = true
                                   : show = false;
                             });
                                                   },

                                                 )
                                             ):Container(),
                                             show==true?Flexible(child: show == true
                                                 ? Divider(thickness: 2,)
                                                 : Container(),):Container(),


                                             show==true?show == true
                                                     ?Container(

                                               child: Image.network(
                                                   parts[0].toString(),

                                                   fit: BoxFit.fitWidth)
                                             )


                                                     : Container()
                                             :Container(),

                                             show==true && parts.length>1?show == true
                                                 ?Container(

                                                 child: Image.network(
                                       GlobalConfiguration().getString('api_question_image').toString()+widget.question['hint_img_destination'].toString()+"/"+ parts[1].toString(),

                                                     fit: BoxFit.fitWidth)
                                             )


                                                 : Container()
                                                 :Container()

                                           ],
                                         ),
                                       )
                                       );
                                     }
                             );

                                   },
                                 );





                             },
                             child: Text(

                               "More Info.",

                               // demo,
                               textAlign: TextAlign.left,
                               style: TextStyle(

                                   fontSize: getFontSize(context,2),
                                   fontWeight: FontWeight.w700,
                                   // fontWeight: FontWeight.w500,
                                   fontFamily: "AVENIRLTSTD",
                                   color: Colors.blueAccent),

                             ),
                           ),
                         )

                       ),

                        MediaQuery.of(context).size.width<=600?SizedBox(height: 30):SizedBox(height: 90,),


                        _inspectionController.confirmLoader
                            ? SizedBox(
                            width: 35,
                            child: Center(child: CircularProgressIndicator()))
                            : Container(
                          
                          height: config.App(context).appHeight(widget.question['ans'].toString()=="3"?(
                              partImageName.length==0?55:partImageName.length==1?85:partImageName.length==2?125:partImageName.length==3?155:partImageName.length==4?215:215
                          ):55),
                          child: Column(

                            children: <Widget>[                        
                              Expanded(

                                child: ListView.builder(

                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _inspectionController.sampleData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return new InkWell(

                                  
                                    onTap: () {

                                     if(_inspectionController.sampleData[index].buttonText=="Rectification Required"||
                                          _inspectionController.sampleData[index].buttonText=="Non Compliant") MediaQuery.of(context).size.width<=600?showdialogmobile(1,index):showdialogtablet(1, index);
                                     else
                                      { 
                                        final pr=ProgressDialog(context);
                                        pr.show();
                                        _inspectionController.getPostQuestions(widget.i,index, context,widget.questionsList,pr);
                                        
                                       
                                      }
                                      

                                    },

                                    child:widget.question['question_type'].toString()=="0"?index<=2?new RadioItem(_inspectionController.sampleData[index]):Container()
                                    :index>=3?new RadioItem(_inspectionController.sampleData[index]):Container(),

                                  );
                                },
                              ),
                              ),

                              partImageName.length>=1&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 25, 15),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child:
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: GestureDetector(
                                      child: Icon(Icons.cancel,size: 30,color: Colors.blue,),
                                      onTap: () async{
                                        await clearImage(widget.question['id'],partImageName[0].toString(),widget.question['booking_id'],0);
                                      },
                                    ),
                                  ),
                                ),
                              ):Container(),
                              partImageName.length>=1&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Expanded(
                                  child:   Image.network(
                                    "${GlobalConfiguration().getString('api_question_image')}${widget.question['destination']}/${partImageName[0]}",
                                    fit: BoxFit.fill,


                                  )
                              ):Container(),

                              partImageName.length>=2&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 25, 0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child:
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: GestureDetector(
                                      child: Icon(Icons.cancel,size: 30,color: Colors.blue,),
                                      onTap: () async{
                                        await clearImage(widget.question['id'],partImageName[1].toString(),widget.question['booking_id'],1);
                                      },
                                    ),
                                  ),
                                ),
                              ):Container(),
                              partImageName.length>=2&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Expanded(
                                  child:   Image.network(
                                    "${GlobalConfiguration().getString('api_question_image')}${widget.question['destination']}/${partImageName[1]}",
                                    fit: BoxFit.fill,


                                  )
                              ):Container(),


                              partImageName.length>=3&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 25, 0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child:
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: GestureDetector(
                                      child: Icon(Icons.cancel,size: 30,color: Colors.blue,),
                                      onTap: () async{
                                        await clearImage(widget.question['id'],partImageName[2].toString(),widget.question['booking_id'],2);
                                      },
                                    ),
                                  ),
                                ),
                              ):Container(),
                              partImageName.length>=3&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Expanded(
                                  child:   Image.network(
                                    "${GlobalConfiguration().getString('api_question_image')}${widget.question['destination']}/${partImageName[2]}",
                                    fit: BoxFit.fill,


                                  )
                              ):Container(),


                              partImageName.length>=4&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 25, 0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child:
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: GestureDetector(
                                      child: Icon(Icons.cancel,size: 30,color: Colors.blue,),
                                      onTap: () async{
                                        await clearImage(widget.question['id'],partImageName[3].toString(),widget.question['booking_id'],3);
                                      },
                                    ),
                                  ),
                                ),
                              ):Container(),
                              partImageName.length>=4&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Expanded(
                                  child:   Image.network(
                                    "${GlobalConfiguration().getString('api_question_image')}${widget.question['destination']}/${partImageName[3]}",
                                    fit: BoxFit.fill,


                                  )
                              ):Container(),

                              partImageName.length>=5&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 25, 0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child:
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: GestureDetector(
                                      child: Icon(Icons.cancel,size: 30,color: Colors.blue,),
                                      onTap: () async{
                                        await clearImage(widget.question['id'],partImageName[4].toString(),widget.question['booking_id'],4);
                                      },
                                    ),
                                  ),
                                ),
                              ):Container(),
                              partImageName.length>=5&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Expanded(
                                  child:   Image.network(
                                    "${GlobalConfiguration().getString('api_question_image')}${widget.question['destination']}/${partImageName[4]}",
                                    fit: BoxFit.fill,


                                  )
                              ):Container(),


                            ],
                          )

                        ),

                      ],
                    ),
                  ),
                )
            ),
            ): Expanded(    //this for tablet
            flex: 90,
            child: Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child:  Container(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10,),
                      ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(child:Align(

                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(8, 4, 8, 6),
                                  child: Text(
                                    ("Q${widget.i + 1}.").toString()+" "+widget.question['question'],
                                 
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: getFontSize(context,3),
                                      
                                        fontFamily: "AVENIRLTSTD",
                                        color: Color(0xff222222)),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              )
                              ),

                            ],),

                          subtitle:Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: GestureDetector(
                              onTap: ()
                              {
                                bool show=false;

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
                                                      child:  Text(
                                                        widget.question['hint']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily: "AVENIRLTSTD",
                                                            color: Colors.black,
                                                            fontSize: getFontSize(context,0)),
                                                      ),
                                                    )
                                                    ),
                                                    SizedBox(height: 20,),
                                                    widget.question['file_name']!=null?Flexible(
                                                        child: GestureDetector(

                                                          child: Text(
                                                            "Show Image",
                                                            style: TextStyle(
                                                                fontFamily: "AVENIRLTSTD",
                                                                color: Colors.blueAccent,
                                                                fontSize: getFontSize(context,0)),
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              print("imgend"+GlobalConfiguration().getString('api_question_image').toString()+widget.question['destination'].toString()+widget.question['file_name'].toString());
                                                              // print("urlofimagehint"+GlobalConfiguration().toString()+"/"+widget.question['destination'].toString()+"/"+widget.question['images'].toString());
                                                              show == false
                                                                  ? show = true
                                                                  : show = false;
                                                            });
                                                          },

                                                        )
                                                    ):Container(),
                                                    show==true?Flexible(child: show == true
                                                        ? Divider(thickness: 2,)
                                                        : Container(),):Container(),


                                                    show==true?show == true
                                                        ?Container(

                                                        child: Image.network(
                                                            parts[0].toString(),

                                                            fit: BoxFit.fitWidth)
                                                    )


                                                        : Container()
                                                        :Container(),

                                                    show==true && parts.length>1?show == true
                                                        ?Container(

                                                        child: Image.network(
                                                            GlobalConfiguration().getString('api_question_image').toString()+widget.question['hint_img_destination'].toString()+"/"+ parts[1].toString(),

                                                            fit: BoxFit.fitWidth)
                                                    )


                                                        : Container()
                                                        :Container()

                                                  ],
                                                ),
                                              )
                                          );
                                        }
                                    );

                                  },
                                );





                              },
                              child: Text(

                                "More Info.",

                                // demo,
                                textAlign: TextAlign.left,
                                style: TextStyle(

                                    fontSize: getFontSize(context,2),
                                    fontWeight: FontWeight.w700,
                                    // fontWeight: FontWeight.w500,
                                    fontFamily: "AVENIRLTSTD",
                                    color: Colors.blueAccent),

                              ),
                            ),
                          )

                      ),

                      MediaQuery.of(context).size.width<=600?SizedBox(height: 30):SizedBox(height: 90,),


                      _inspectionController.confirmLoader
                          ? SizedBox(
                          width: 35,
                          child: Center(child: CircularProgressIndicator()))
                          : Container(
                        // alignment: Alignment.bottomCenter,
                          height: config.App(context).appHeight(widget.question['ans'].toString()=="3"?(
                              partImageName.length==0?55:partImageName.length==1?85:partImageName.length==2?125:partImageName.length==3?155:partImageName.length==4?215:215
                          ):55),
                          child: Column(

                            children: <Widget>[

//                              showCommentAndImages==1?
//
//                               :Container(),
                              Expanded(

                                child: ListView.builder(

                                 
                                  itemCount: _inspectionController.sampleData.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new InkWell(

                                      onTap: () {



                                        if(_inspectionController.sampleData[index].buttonText=="Rectification Required"||
                                            _inspectionController.sampleData[index].buttonText=="Non Compliant") MediaQuery.of(context).size.width<=600?showdialogmobile(1,index):showdialogtablet(1, index);
//
                                            else
                                            {final pr=ProgressDialog(context);
                                            pr.show();
                                        _inspectionController.getPostQuestions(widget.i,index, context,widget.questionsList,pr);}


                                      },

                                      child:widget.question['question_type'].toString()=="0"?index<=2?new RadioItem(_inspectionController.sampleData[index]):Container()
                                          :index>=3?new RadioItem(_inspectionController.sampleData[index]):Container(),

                                    );
                                  },
                                ),
                              ),

                              partImageName.length>=1&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 25, 15),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child:
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: GestureDetector(
                                      child: Icon(Icons.cancel,size: 30,color: Colors.blue,),
                                      onTap: () async{
                                        await clearImage(widget.question['id'],partImageName[0].toString(),widget.question['booking_id'],0);
                                      },
                                    ),
                                  ),
                                ),
                              ):Container(),
                              partImageName.length>=1&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Expanded(
                                  child:   Image.network(
                                    "${GlobalConfiguration().getString('api_question_image')}${widget.question['destination']}/${partImageName[0]}",
                                    fit: BoxFit.fill,


                                  )
                              ):Container(),

                              partImageName.length>=2&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 25, 0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child:
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: GestureDetector(
                                      child: Icon(Icons.cancel,size: 30,color: Colors.blue,),
                                      onTap: () async{
                                        await clearImage(widget.question['id'],partImageName[1].toString(),widget.question['booking_id'],1);
                                      },
                                    ),
                                  ),
                                ),
                              ):Container(),
                              partImageName.length>=2&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Expanded(
                                  child:   Image.network(
                                    "${GlobalConfiguration().getString('api_question_image')}${widget.question['destination']}/${partImageName[1]}",
                                    fit: BoxFit.fill,


                                  )
                              ):Container(),


                              partImageName.length>=3&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 25, 0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child:
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: GestureDetector(
                                      child: Icon(Icons.cancel,size: 30,color: Colors.blue,),
                                      onTap: () async{
                                        await clearImage(widget.question['id'],partImageName[2].toString(),widget.question['booking_id'],2);
                                      },
                                    ),
                                  ),
                                ),
                              ):Container(),
                              partImageName.length>=3&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Expanded(
                                  child:   Image.network(
                                    "${GlobalConfiguration().getString('api_question_image')}${widget.question['destination']}/${partImageName[2]}",
                                    fit: BoxFit.fill,


                                  )
                              ):Container(),


                              partImageName.length>=4&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 25, 0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child:
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: GestureDetector(
                                      child: Icon(Icons.cancel,size: 30,color: Colors.blue,),
                                      onTap: () async{
                                        await clearImage(widget.question['id'],partImageName[3].toString(),widget.question['booking_id'],3);
                                      },
                                    ),
                                  ),
                                ),
                              ):Container(),
                              partImageName.length>=4&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Expanded(
                                  child:   Image.network(
                                    "${GlobalConfiguration().getString('api_question_image')}${widget.question['destination']}/${partImageName[3]}",
                                    fit: BoxFit.fill,


                                  )
                              ):Container(),

                              partImageName.length>=5&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 25, 0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child:
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: GestureDetector(
                                      child: Icon(Icons.cancel,size: 30,color: Colors.blue,),
                                      onTap: () async{
                                        await clearImage(widget.question['id'],partImageName[4].toString(),widget.question['booking_id'],4);
                                      },
                                    ),
                                  ),
                                ),
                              ):Container(),
                              partImageName.length>=5&&(widget.question['ans'].toString()!="1"&&
                                  widget.question['ans'].toString()!="2")?Expanded(
                                  child:   Image.network(
                                    "${GlobalConfiguration().getString('api_question_image')}${widget.question['destination']}/${partImageName[4]}",
                                    fit: BoxFit.fill,


                                  )
                              ):Container(),

                            ],
                          )

                      ),

                    ],
                  ),
                )
            ),
          )
        ],
      )
    );


  }



  showdialogtablet(showCommentAndImagesLocal,indexOfRectificationorNonComplianceLocal)
  {
    setState(() {
      showCommentAndImages = showCommentAndImages;
      indexOfRectificationorNonCompliance = indexOfRectificationorNonComplianceLocal;
      _inspectionController.sampleData.forEach((element) => element.isSelected = false);
      _inspectionController.sampleData[indexOfRectificationorNonCompliance].isSelected = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyDialogTablet(widget.i,_inspectionController,indexOfRectificationorNonCompliance,widget.question,widget.questionsList);
      },
    );
  }

  showdialogmobile(showCommentAndImageslocal,indexOfRectificationorNonComplianceLocal)
  {
    setState(() {
      showCommentAndImages = showCommentAndImages;
      indexOfRectificationorNonCompliance = indexOfRectificationorNonComplianceLocal;
      _inspectionController.sampleData.forEach((element) => element.isSelected = false);
      _inspectionController.sampleData[indexOfRectificationorNonCompliance].isSelected = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyDialogMobile(widget.i,_inspectionController,indexOfRectificationorNonCompliance,widget.question,widget.questionsList);
      },
    );
  }



}




