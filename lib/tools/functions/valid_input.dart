import 'package:get/get.dart';

validInput(
  String val,
  int min,
  int max,
  String type,
) {
  if (type == "username") {
    if (min >= val.length && val.length >= max) {
      return "not valid username";
    }
  }
  if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "not valid email";
    }
  }
  if (type == "phone") {
    if (val.isEmpty) {
    } else {
      if (!GetUtils.isPhoneNumber(val)) {
        return "not valid phone";
      }
    }
  }
  if (type == "age") {
    if (!GetUtils.isNumericOnly(val)) {
      return "not valid age";
    }
  }
  if (type == "NOPeopler") {
    if (!GetUtils.isNumericOnly(val)) {
      return "not valid Number";
    }
  }
  if (type == "checkbox") {
    if (val == "false") {
      return "Checkbox must be checked";
    }
  }
  if (type == "subject") {}
  if (type == "description") {}

  if (val.isEmpty) {
    if (type == "phone" && val.isEmpty) {
    } else {
      return "can't be Empty";
    }
  }
  if (val.length < min) {
    if (type == "phone" && val.isEmpty) {
    } else {
      return "can't be less than $min";
    }
  }
  if (val.length > max) {
    return "can't be larger than $max";
  }
}
