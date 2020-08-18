

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poolinspection/src/components/responsive_text.dart';

import 'package:poolinspection/src/controllers/inspection_controller.dart';
import 'package:poolinspection/src/elements/custom_progress_dialog.dart';

import 'package:poolinspection/src/pages/home/PermissionHandler.dart';


class MyDialogTablet extends StatefulWidget {
  final InspectionController _inspectionController;
  var question;
  int i;
  var qlist;
  final int indexofrectiornoncomp;
  MyDialogTablet(this.i,this._inspectionController,this.indexofrectiornoncomp,this.question,this.qlist);
  @override
  _MyDialogTabletState createState() => new _MyDialogTabletState(i,_inspectionController,indexofrectiornoncomp,question);
}

class _MyDialogTabletState extends State<MyDialogTablet> {
  InspectionController _inspectionController;
  var question;
  int i;
  bool photoselected=false;
  int indexofrectiornoncomp;
  int counter=0;
  final GlobalKey<FormState> _formKey =  GlobalKey<FormState>();

  _MyDialogTabletState(i,_controller,indexofrectiornoncomp,question)
  {
    this.i=i;
    this._inspectionController=_controller;
    this.indexofrectiornoncomp=indexofrectiornoncomp;
    this.question=question;
  }

  void _onImageButtonPressed() async {

    if (_inspectionController.pickingType != FileType.custom || _inspectionController.hasValidMime) {


      setState(() => _inspectionController.loadingPath = true);
      try {
        // _con.paths = null;
        final pickedImage=await ImagePicker().getImage(
          source: ImageSource.camera,
          maxWidth: 150,
          maxHeight: 150,
        );
        final File image=   File(pickedImage.path);
        if (image == null) return;
        // getting a directory path for saving
        // Step 3: Get directory where we can duplicate selected file.
        final Directory directory = await getExternalStorageDirectory();
        final String path = directory.path;
        // using your method of getting an image
        final File newImage = await image.copy(path+"/image${++counter}.png");
        setState(() {

          _inspectionController.loadingPath = false;

          // print("addedimagepath"+_con.path.toString());
          //_con.path.add("hello");
          _inspectionController.path.add(newImage.path.toString().substring(0,newImage.path.length));

          _inspectionController.fileName.add("image$counter.png");


          //   print("goku is godimagepathinques"+newImage.toString());
          print("newaddpath"+_inspectionController.path.toString());
          print("newaddimages"+_inspectionController.fileName.toString());

        });


      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

    }

    Flushbar(
      title: "Image selected",
      message: "Please Submit Answer",
      duration: Duration(seconds: 3),
    )..show(context);



  }

  @override
  Widget build(BuildContext context1) {
    return AlertDialog(

      backgroundColor:Color(0xffe9e9e9),
      content: Padding(
        padding: EdgeInsets.all(0.0),
        child: Container(
          height:MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width*0.8,
          child:Card(

            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Container(

                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding:EdgeInsets.fromLTRB(20, 20, 10, 0),
                        child:Form(
                          key: _formKey,
                          child: TextFormField(
                            style: TextStyle(color:Color(0xff000000),fontSize: getFontSize(context,2),

                              fontFamily: "AVENIRLTSTD",),
                            initialValue: widget.question['comment'],
                            textInputAction: TextInputAction.done,
                            validator: (text) {
                              if (text == null || text.isEmpty ||text.trim().isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              enabledBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xfffffff)
                                ),
                              ),
// and:

                              hintText: "Enter Comments",
                              hintStyle: TextStyle(
                                fontSize: getFontSize(context,2),
                                color: Color(0xff999999),
                                fontFamily: "AVENIRLTSTD",
                              ),
// labelText: 'Enter the Value',
                              errorText: _inspectionController.validate
                                  ? 'Value Can\'t Be Empty'
                                  : null,
                            ),
                            onChanged: (abc) => _inspectionController.data.comment = abc,
                            onFieldSubmitted: (abc) => _inspectionController.data.comment = abc,
// onEditingComplete: ()=>print(abc),

                            maxLines: 20,
                          ),
                        )
                    ),),
                ),



                Expanded(flex:1,child:Divider()),

                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              RaisedButton(
                                onPressed:(){
                                  if(_formKey.currentState.validate())
                                  {
                                    final pr=ProgressDialog(context);
                                      pr.show();
                                    _inspectionController.getPostQuestions(widget.i,indexofrectiornoncomp, context,widget.qlist,pr,isDialog:true);
                                    // Navigator.pop(context);
                                  }
                                },
                                color:Theme.of(context).accentColor,
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                child:Text(
                                  "Submit",
                                  style: TextStyle(
                                      fontSize: getFontSize(context,0),
                                      color: Colors.white, fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.normal),
                                ),


                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child:RaisedButton(
                                    onPressed:(){
                                      Navigator.of(context).pop();
                                    },
                                    color:Color(0xffe9e9e9),
                                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                    child:Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontSize: getFontSize(context,0),
                                          color: Colors.black87, fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.normal),
                                    ),


                                  ),),
                              )
                            ]
                        ),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              photoselected==false?Padding(
                                padding: EdgeInsets.fromLTRB(3, 0, 0, 2),
                                child:  Icon(Icons.camera_alt,color: Colors.grey,size: 25,),
                              ):Padding(
                                padding: EdgeInsets.fromLTRB(3, 0, 0, 2),
                                child:  Icon(Icons.add_a_photo,color: Colors.grey,size: 25,),
                              ),
                              GestureDetector(
                                onTap: () async{
                                  Permission.values
                                      .where((Permission permission) {
                                    if (Platform.isIOS) {
                                      return permission != Permission.storage &&
                                          permission != Permission.camera ;


                                    } else {
                                      return permission != Permission.storage &&
                                          permission != Permission.camera;
                                    }
                                  })
                                      .map((permission) => PermissionWidget(permission))
                                      .toList();
                                  if(counter.toString()=="5")
                                  {
                                    Fluttertoast.showToast(
                                        msg: "5 Photos Selected",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Theme.of(context).hintColor,
                                        textColor: Colors.white,
                                        fontSize: getFontSize(context,-2)
                                    );
                                  }
                                  else
                                     _onImageButtonPressed();


                                  setState(() {
                                    photoselected=true;
                                  });
                                },
                                child:Text(
                                  photoselected==false?" Take Photo":" Selected "+counter.toString()+"/5",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: getFontSize(context,3),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "AVENIRLTSTD",
                                      color: Theme.of(context).accentColor),

                                ),
                              ),
                              



                            ]
                        ),
                      ],
                    ),

                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
