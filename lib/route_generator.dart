import 'package:flutter/material.dart';

import 'package:poolinspection/src/pages/home/AddBankDetails.dart';
import 'package:poolinspection/src/pages/home/AddCardDetails.dart';
import 'package:poolinspection/src/pages/home/GetCertificateList.dart';
import 'package:poolinspection/src/pages/home/GetInvoiceList.dart';
import 'package:poolinspection/src/pages/home/InpsectorInvoiceList.dart';
import 'package:poolinspection/src/pages/home/ManageBookings.dart';
import 'src/models/route_argument.dart';
import 'src/pages/booking/bookingform.dart';
import 'src/pages/home/home.dart';
import 'src/pages/login/login.dart';
import 'src/pages/reports/report.dart';
import 'src/pages/signup/signup.dart';
import 'src/pages/splashscreen/splash_screen.dart';
import 'src/pages/utils/addinspector.dart';
import 'src/pages/utils/forgotpassword.dart';
import 'src/pages/utils/updatepassword.dart';

class RouteGenerator {
  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/UpdatePassword':
        return MaterialPageRoute(builder: (_) => UpdatePasswordWidget());
      case '/Home':
        return MaterialPageRoute(
            builder: (_) =>
                HomeWidget(routeArgument: args as RouteArgumentHome));

      case '/AddCardDetail':
        return MaterialPageRoute(builder: (_) => AddCardDetailWidget());
      case '/BankDetails':
        return MaterialPageRoute(builder: (_) => AddBankDetailWidget());
      case '/GetInvoiceList':
        return MaterialPageRoute(builder: (_) => InvoiceListClass());

      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case '/AddInspector':
        return MaterialPageRoute(builder: (_) => AddInspectorWidget());

      case '/ManageBookings':

        return MaterialPageRoute(
            builder: (_) =>
                ManageBookingWidget());


      case '/InspectorInvoice':
        return MaterialPageRoute(builder: (_) => InspectorInvoiceListClass());
      case '/NoticeReport':
        return MaterialPageRoute(
            builder: (_) =>
                NoticeReport(routeArgument: args as RouteArgumentReport));

      case '/Certificate':
        return MaterialPageRoute(
            builder: (_) =>
                CertificateListClass(routeArgument: args as RouteArgumentCertificate));

      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());

      case '/BookingForm':
        return MaterialPageRoute(builder: (_) => BookingFormWidget());
    }
  }

}
