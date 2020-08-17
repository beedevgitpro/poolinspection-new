import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:poolinspection/src/components/responsive_text.dart';

class CustomFormBuilderRadio extends StatefulWidget {
  final String attribute;
  final List<FormFieldValidator> validators;
  final dynamic initialValue;
  final bool readOnly;
  final TextStyle textStyle;
  final InputDecoration decoration;
  final ValueChanged onChanged;
  final ValueTransformer valueTransformer;
  final bool leadingInput;

  final List<FormBuilderFieldOption> options;

  final MaterialTapTargetSize materialTapTargetSize;

  final Color activeColor;
  final FormFieldSetter onSaved;

  CustomFormBuilderRadio({
    Key key,
    @required this.attribute,
    @required this.options,
    this.initialValue,
    this.validators = const [],
    this.readOnly = false,
    this.decoration = const InputDecoration(),
    this.onChanged,
    this.textStyle= const TextStyle(fontSize: 28),
    this.valueTransformer,
    this.leadingInput = false,
    this.materialTapTargetSize,
    this.activeColor,
    this.onSaved,
  }) : super(key: key);

  @override
  _CustomFormBuilderRadioState createState() => _CustomFormBuilderRadioState();
}

class _CustomFormBuilderRadioState extends State<CustomFormBuilderRadio> {
  bool _readOnly = false;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  FormBuilderState _formState;
  dynamic _initialValue;

  @override
  void initState() {
    _formState = FormBuilder.of(context);
    _formState?.registerFieldKey(widget.attribute, _fieldKey);
    _initialValue = widget.initialValue ??
        (_formState.initialValue.containsKey(widget.attribute)
            ? _formState.initialValue[widget.attribute]
            : null);
    super.initState();
  }

  @override
  void dispose() {
    _formState?.unregisterFieldKey(widget.attribute);
    super.dispose();
  }

  Widget _radio(FormFieldState<dynamic> field, int i) {
    return Radio<dynamic>(

      value: widget.options[i].value,
      groupValue: field.value,
      materialTapTargetSize: widget.materialTapTargetSize,
      activeColor: widget.activeColor,
      onChanged: _readOnly
          ? null
          : (dynamic value) {
              FocusScope.of(context).requestFocus(FocusNode());
              field.didChange(value);
              if (widget.onChanged != null) widget.onChanged(value);
            },
    );
  }


  Widget _trailing(FormFieldState<dynamic> field, int i) {
    if (!widget.leadingInput) return _radio(field, i);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _readOnly = (_formState?.readOnly == true) ? true : widget.readOnly;

    return FormField(

      key: _fieldKey,
      enabled: !_readOnly,
      initialValue: _initialValue,
      validator: (val) {
        for (int i = 0; i < widget.validators.length; i++) {
          if (widget.validators[i](val) != null)
            return widget.validators[i](val);
        }
        return null;
      },
      onSaved: (val) {
        var transformed;
        if (widget.valueTransformer != null) {
          transformed = widget.valueTransformer(val);
          _formState?.setAttributeValue(widget.attribute, transformed);
        } else
          _formState?.setAttributeValue(widget.attribute, val);
        if (widget.onSaved != null) {
          widget.onSaved(transformed ?? val);
        }
      },
      builder: (FormFieldState<dynamic> field) {
        List<Widget> radioList = [];
        // for (int i = 0; i < widget.options.length; i++) {
        radioList.addAll([
          // SizedBox(height: 20,),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[  //bbecause of this text font of radio changing
                Row(
                  children: [
                    _trailing(field, 0),
                    Text(widget.options[0].value,style: TextStyle(fontSize: getFontSize(context,0),fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(width:MediaQuery.of(context).size.width/6),
               Row(
                 children: [
                   _trailing(field, 1),
                   Text(widget.options[1].value,style: TextStyle(fontSize: getFontSize(context,0),fontFamily: "AVENIRLTSTD",fontWeight: FontWeight.bold),)
                 ],
               ),
                
                  
              ],
            ),
            onTap: _readOnly
                ? null
                : () {
                    field.didChange(widget.options[0].value);
                    if (widget.onChanged != null)
                      widget.onChanged(widget.options[0].value);
                  },
          ),
          // Divider(
          //   height: 0.0,
          // ),
        ]);
        // }
        return InputDecorator(

          decoration: widget.decoration.copyWith(

            enabled: !_readOnly,
            errorText: field.errorText,
          ),
          child: Column(
            children: radioList,
          ),
        );
      },
    );
  }
}
