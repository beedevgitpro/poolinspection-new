import 'package:poolinspection/src/models/user.dart';

class RouteArgument {
  String id;
  String heroTag;
  dynamic param;

  RouteArgument({this.id, this.heroTag, this.param});

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}

class RouteArgumentReport {
  int id;
  String heroTag;
  dynamic param;

  RouteArgumentReport({this.id, this.heroTag, this.param});

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}

class RouteArgumentCertificate {
  int id;
  String heroTag;
  dynamic param;

  RouteArgumentCertificate({this.id, this.heroTag, this.param});

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}

class RouteArgumentHome {
  int id;
  int role;
  int companyid;
  dynamic param;

  RouteArgumentHome({this.id, this.role, this.param, this.companyid});

  @override
  String toString() {
    return '{id: $id, heroTag:${role.toString()}}';
  }
}

// class ListDetailArgument {
//   InvoiceModel invoice;
//   bool readonly;
//   ListDetailArgument({this.invoice, this.readonly});

//   @override
//   String toString() {
//     return '{merchant: $invoice}}';
//   }
// }

class SignUpInsideCompany {
  Company company;
  bool inside;
  SignUpInsideCompany({this.company, this.inside});

  @override
  String toString() {
    return '{merchant: $inside}}';
  }
}
