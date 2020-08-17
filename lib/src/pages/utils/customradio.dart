import 'package:flutter/material.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:poolinspection/src/components/responsive_text.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top:5.0),
      child: new Container(
        height: config.App(context).appHeight(10),

        width: 50.0,
        child: new Center(
          child: new Text(_item.buttonText,
              style: new TextStyle(
                  fontFamily: "AVENIRLTSTD",
                  fontWeight: FontWeight.w800,
                  color: _item.isSelected
                      ? Colors.white
                      : Color(0xff0ba1d9),
                  //fontWeight: FontWeight.bold,
                  fontSize: getFontSize(context,3))),
        ),
        decoration:_item.buttonText.toString()=="Rectification Required" || _item.buttonText.toString()=="Non Compliant"?
        new BoxDecoration(
          
          color: _item.isSelected
              ? Colors.red
              : Colors.transparent,
          border: new Border(bottom:BorderSide(
              width: 2.0,
              color: _item.isSelected
                  ? Colors.transparent
                  : config.Colors().scaffoldColor(1)),
          // borderRadius: BorderRadius.all(Radius.circular(100)),
        ),

      ):new BoxDecoration(

          color: _item.isSelected
              ? Theme.of(context).accentColor
              : Colors.transparent,
          border: new Border(bottom:BorderSide(
              width: 2.0,
              color: _item.isSelected
                  ? Colors.transparent
                  : config.Colors().scaffoldColor(1)),
            // borderRadius: BorderRadius.all(Radius.circular(100)),
          ),

        ),
    ));
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}
