import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:poolinspection/src/elements/inputdecoration.dart';
import 'package:poolinspection/src/elements/radiobutton.dart';
import 'package:poolinspection/src/elements/textfield.dart';
import 'package:poolinspection/src/elements/textlabel.dart';
import 'package:poolinspection/src/models/reportmodel.dart';
import 'package:poolinspection/config/app_config.dart' as config;
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

final Dio dio = new Dio();

class WebClient {
  const WebClient();

  Future<void> download(
      String url, savePath, ProgressCallback onProgress) async {
    try {
      await dio.download(url, savePath, onReceiveProgress: onProgress);
    } catch (e) {
      throw ('An error occurred');
    }
  }
}

final WebClient http = new WebClient();

class ReportDetailWidget extends StatefulWidget {
  CompliantReportList routeArgument;
  ReportDetailWidget({Key key, this.routeArgument}) : super(key: key);
  //   DetailWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _ReportDetailWidgetState createState() => _ReportDetailWidgetState();
}

class _ReportDetailWidgetState extends State<ReportDetailWidget> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  var data;
  bool autoValidate = true;
  bool readOnly = true;
  List regulationdata;
  double _percentage = 0.0;
  bool _progressDone = false;
  bool progressCircular = false;

  @override
  void initState() {
    
    print(widget.routeArgument.id);
    super.initState();
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
    
      var percentage = (received / total * 100);
      setState(() {
        if (percentage < 100) {
          _percentage = percentage;
        } else {
          _progressDone = true;
          progressCircular = false;
        }
      });
    }
    print(_percentage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Reports Detail",
            style: TextStyle(
              fontFamily: "Muli",
            ),
          ),
          actions: <Widget>[
            progressCircular
                ? Center(child: CircularProgressIndicator())
                : IconButton(
                    icon: Icon(Icons.cloud_download),
                    onPressed: () async {
                      setState(() {
                        _percentage = 0;
                        _progressDone = false;
                        progressCircular = true;
                      });

                      // create temp file
                      final String dir =
                          (await getApplicationDocumentsDirectory()).path;
                     

                      // -------

                      //download 25mb image
                      await http.download(
                        'http://poolinspection.beedevstaging.com/developer/public/api/beedev/compliance/${widget.routeArgument.id}',
                        '$dir/CERTIFICATE${widget.routeArgument.id}.pdf',
                        showDownloadProgress,
                      );
                    },
                  ),
            _progressDone?
              RaisedButton(
                child: Text("Share"),
                onPressed: () async {
                  // get file from local store
                  final String dir =
                      (await getApplicationDocumentsDirectory()).path;
                  final String path =
                      '$dir/CERTIFICATE${widget.routeArgument.id}.pdf';

                  ShareExtend.share(path, "file");
                },
              ):Container(),
          ],
          leading: IconButton(
              color: config.Colors().secondColor(1),
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              elevation: 1.0,
              child: SingleChildScrollView(
                  child: bookingForm(context, widget.routeArgument))),
        ));
  }

  FormBuilder bookingForm(BuildContext context, CompliantReportList pre) {
    print(pre.bookingDateTime);
    return FormBuilder(
      key: _fbKey,
      readOnly: readOnly,
      initialValue: {
        "owner_land": pre.ownerLand,
        "phonenumber": pre.phonenumber,
        "email_owner": pre.emailOwner,
        "address": pre.address,
        "name_relevant_council": pre.nameRelevantCouncil,
        // "email_relevant_council": pre.emailRelevantCouncil,
        "swi_pool_spa":
            pre.swiPoolSpa == "swimming_pool" ? "Swimming Pool" : "Spa",
        "permnt_relocate":
            pre.permntRelocate == "relocatable" ? "Relocatable" : "Permanent",
        // "certificateofnoncomplianceissued": pre.certificateNonCompliance,
        // "poolfoundnoncompliant": pre.,
        "payment_paid": pre.paymentPaid == "yes" ? "Yes" : "No",
        "inspection_fee": pre.inspectionFee,
        "notice_registration": pre.noticeRegistration,
        // "company_list": "5",
        // "Council_due_date": DateTime.parse(pre.councilDueDate),
        "booking_date_time": DateTime.parse(pre.bookingDateTime),
        "council_regis_date": DateTime.parse(pre.councilRegisDate),
        "inspector_name": pre.inspectorName,
        "street_road": pre.street,
        "postcode": pre.postcode,
        "city_suburb": pre.city,
        "municipal_district": pre.district
      },
      autovalidate: autoValidate,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: listView(context, pre),
      ),
    );
  }

  Column listView(BuildContext context, CompliantReportList pre) {
    final sizedbox =
        SizedBox(height: config.App(context).appVerticalPadding(2));
    return Column(
      children: <Widget>[
        sizedbox,
        textLabel("Name of Owner of land",context),
        CustomFormBuilderTextField(
          attribute: "owner_land",
          decoration: buildInputDecoration(context, "", "Sumit Das"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.max(70),
          ],
        ),
        sizedbox,
        textLabel("Contact phone number",context),
        CustomFormBuilderTextField(
          attribute: "phonenumber",
          maxLength: 10,
          decoration: buildInputDecoration(
              context, "Contact phone number", "9004818637"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(10),
            FormBuilderValidators.numeric(),
          ],
        ),
        sizedbox,
        textLabel("Email of Owner",context),
        CustomFormBuilderTextField(
          attribute: "email_owner",
          decoration: buildInputDecoration(
              context, "Email of Owner", "sdas220496@gmail.com"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ],
        ),
       
        sizedbox,
        sizedbox,
        textLabel("Street/Road",context),
        FormBuilderTextField(
          // maxLines: 3,
          attribute: "street_road",
          decoration:
              buildInputDecoration(context, "Address", "Enter Street/Road"),
          keyboardType: TextInputType.text,
          validators: [
            FormBuilderValidators.maxLength(50),
            FormBuilderValidators.required()
          ],
        ),
        sizedbox,
        textLabel("City/Suburb",context),
        FormBuilderTextField(
          // maxLines: 3,
          attribute: "city_suburb",
          decoration:
              buildInputDecoration(context, "Address", "Enter City/Suburb"),
          keyboardType: TextInputType.text,
          validators: [
            FormBuilderValidators.maxLength(20),
            FormBuilderValidators.required()
          ],
        ),
        // sizedbox,
        // textLabel("District"),
        // FormBuilderTextField(
        //   // maxLines: 3,
        //   attribute: "municipal_district",
        //   decoration:
        //       buildInputDecoration(context, "Address", "Enter District"),
        //   keyboardType: TextInputType.text,
        //   validators: [
        //     FormBuilderValidators.maxLength(20),
        //     FormBuilderValidators.required()
        //   ],
        // ),
        sizedbox,
        textLabel("Postcode",context),
        FormBuilderTextField(
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          maxLength: 4,
          attribute: "postcode",
          decoration:
              buildInputDecoration(context, "Address", "Enter Postcode"),
          keyboardType: TextInputType.number,
          validators: [
            FormBuilderValidators.numeric(),
            FormBuilderValidators.maxLength(4),
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.required()
          ],
        ),
        sizedbox,
        textLabel(
            "The name of the relevant Council that issued \nthe Notice of Registration",context),
        CustomFormBuilderTextField(
          attribute: "name_relevant_council",
          decoration: buildInputDecoration(
              context,
              "The name of the relevant Council that issued \nthe Notice of Registration",
              "XYZ Council"),
          keyboardType: TextInputType.text,
          validators: [
            // FormBuilderValidators.min(3),
            // FormBuilderValidators.max(70),
            FormBuilderValidators.required()
          ],
        ),

        // sizedbox,
        // textLabel("The email address of the relevant Council"),
        // CustomFormBuilderTextField(
        //   attribute: "email_relevant_council",
        //   decoration: buildInputDecoration(
        //       context,
        //       "The email address of the relevant Council",
        //       "sdas220496@gmail.com"),
        //   validators: [
        //     FormBuilderValidators.required(),
        //     FormBuilderValidators.email(),
        //   ],
        // ),
        sizedbox,
        textLabel(
            "What is the date of construction of the pool \nin the Council Registration",context),
        FormBuilderDateTimePicker(
          attribute: "council_regis_date",
          inputType: InputType.date,
          validators: [FormBuilderValidators.required()],
          format: DateFormat("yyyy-MM-dd"),
          decoration: buildInputDecoration(
              context,
              "What is the date of construction of the pool \nin the Council Registration",
              "2020-02-05"),
        ),
        sizedbox,
        // textLabel(
        //     "What does the Notice of Registration specify \nas the applicable Australian Standard?"),
        // CustomFormBuilderTextField(
        //   attribute: "notice_registration",
        //   decoration: buildInputDecoration(
        //       context,
        //       "The email address of the relevant Council",
        //       "sdas220496@gmail.com"),
        //   validators: [
        //     FormBuilderValidators.required(),
        //     FormBuilderValidators.email(),
        //   ],
        // ),
        //         sizedbox,
        // textLabel(
        //     "What does the Notice of Registration specify \nas the applicable Australian Standard?"),
        // CustomFormBuilderDropdown(
        //   attribute: "notice_registration",
        //   // initialValue: 'Male',
        //   hint: Text('Select Regulation'),
        //   validators: [FormBuilderValidators.required()],
        //   items: _con.regulationdata
        //       .map((item) => DropdownMenuItem(
        //           value: item['regulation_id'],
        //           child: Text("${item['regulation_name']}")))
        //       .toList(),
        // ),
        // sizedbox,
        // textLabel(
        //     "When is the Compliance Certificate required \nby Council due?"),
        // CustomFormBuilderTextField(
        //   attribute: "Council_due_date",
        //   decoration: buildInputDecoration(
        //       context,
        //       "The email address of the relevant Council",
        //       "sdas220496@gmail.com"),
        //   validators: [
        //     FormBuilderValidators.required(),
        //     FormBuilderValidators.email(),
        //   ],
        // ),
        sizedbox,
        textLabel("Is it a swimming pool or spa?",context),
        CustomFormBuilderRadio(
          decoration: buildInputDecoration(
              context, "Is it a swimming pool or spa?", "yes or no"),
          attribute: "swi_pool_spa",
          validators: [FormBuilderValidators.required()],
          options: ["Swimming Pool", "Spa"]
              .map((lang) => FormBuilderFieldOption(value: lang))
              .toList(growable: false),
        ),
        sizedbox,
        textLabel("Is the pool/spa permanent or relocatable?",context),
        CustomFormBuilderRadio(
          decoration: buildInputDecoration(context,
              "Is the pool/spa permanent or relocatable?", "yes or no"),
          attribute: "permnt_relocate",
          validators: [FormBuilderValidators.required()],
          options: ["Permanent", "Relocatable"]
              .map((lang) => FormBuilderFieldOption(value: lang))
              .toList(growable: false),
        ),
        sizedbox,
        // textLabel("Was a the Pool recently found to be \nnon-Compliant?"),
        // CustomFormBuilderRadio(
        //   decoration: buildInputDecoration(context,
        //       "Was a the Pool recently found to be non-Compliant", "yes or no"),
        //   attribute: "certificateofnoncomplianceissued",
        //   validators: [FormBuilderValidators.required()],
        //   options: ["Yes", "No"]
        //       .map((lang) => FormBuilderFieldOption(value: lang))
        //       .toList(growable: false),
        // ),
        // sizedbox,
        textLabel(
            "What is the requested booking date and time \nof the inspection? ",context),
        FormBuilderDateTimePicker(
          attribute: "booking_date_time",
          validators: [FormBuilderValidators.required()],
          inputType: InputType.date,
          format: DateFormat("yyyy-MM-dd"),
          decoration: buildInputDecoration(
              context,
              "What is the requested booking date and time \nof the inspection? ",
              "2020-02-05"),
        ),
        // textLabel(
        //     "What is the requested booking date and time \nof the inspection? "),
        // CustomFormBuilderTextField(
        //   attribute: "booking_date_time",
        //   decoration: buildInputDecoration(
        //       context,
        //       "The email address of the relevant Council",
        //       "sdas220496@gmail.com"),
        //   validators: [
        //     FormBuilderValidators.required(),
        //     FormBuilderValidators.email(),
        //   ],
        // ),
        sizedbox,
        textLabel("What is the Fee for this inspection?",context),
        CustomFormBuilderTextField(
          attribute: "inspection_fee",
          decoration: buildInputDecoration(
              context, "What is the Fee for this inspection?", "120"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
          ],
        ),
        sizedbox,
        textLabel("Has the inspection fee payment been made?",context),
        CustomFormBuilderRadio(
          decoration: buildInputDecoration(context,
              "Has the inspection fee payment been made?", "yes or no"),
          attribute: "payment_paid",
          validators: [FormBuilderValidators.required()],
          options: ["Yes", "No"]
              .map((lang) => FormBuilderFieldOption(value: lang))
              .toList(growable: false),
        ),
        sizedbox,
        textLabel("Inspector's Name",context),
        CustomFormBuilderTextField(
          attribute: "inspector_name",
          decoration: buildInputDecoration(
              context, "What is the Fee for this inspection?", "120"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
          ],
        ),
      ],
    );
  }
}
