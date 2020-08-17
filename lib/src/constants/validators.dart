import 'package:flutter/material.dart';

class CustomFormBuilderValidators {
  static FormFieldValidator charOnly({
    Pattern pattern = r'^\D+$',
    String errorText = "Characters only",
  }) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.isNotEmpty) {
        if (!RegExp(pattern).hasMatch(valueCandidate)) return errorText;
      }
      return null;
    };
  }

  static FormFieldValidator addressOnly({
    Pattern pattern = r'^[#.0-9a-zA-Z\s,-]+$',
    String errorText = "Invalid Characters",
  }) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.isNotEmpty) {
        if (!RegExp(pattern).hasMatch(valueCandidate)) return errorText;
      }
      return null;
    };
  }

  static FormFieldValidator regNumber({
    Pattern pattern = r'^[0-9]*$',
    String errorText = "Accept ",
  }) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.isNotEmpty) {
        if (!RegExp(pattern).hasMatch(valueCandidate)) return errorText;
      }
      return null;
    };
  }


  static FormFieldValidator strongPassCheck({
    Pattern pattern =
        r'^.*(?=.{6,})((?=.*[!@#$%^&*()\-_=+{};:,<.>]){1})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$',
    String errorText =
        "Password should contain atleast one Uppercase, Lowercase, \nNumeric & Special Character \nExample: Password@123",
  }) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.isNotEmpty) {
        if (!RegExp(pattern).hasMatch(valueCandidate)) return errorText;
      }
      return null;
    };
  }

  static FormFieldValidator numOnly({
    Pattern pattern = r'^\D+$',
    String errorText = "Characters only",
  }) {
    return (valueCandidate) {
      if (valueCandidate != null && valueCandidate.isNotEmpty) {
        if (!RegExp(pattern).hasMatch(valueCandidate)) return errorText;
      }
      return null;
    };
  }
}
