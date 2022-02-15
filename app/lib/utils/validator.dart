// matching various patterns for kinds of data
import 'package:get/get.dart';

class Validator {
  Validator();

  static String capitalize(String string) {
    return "${string[0].toUpperCase()}${string.substring(1)}";
  }

  String? email(String? value) {
    String pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!.trim()))
      return 'validator.email'.tr;
    else
      return null;
  }

  String? password(String? value) {
    String pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!.trim()))
      return 'validator.password'.tr;
    else
      return null;
  }

  String? name(String? value) {
    String pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!.trim()))
      return 'Invalid Display Name'.tr;
    else
      return null;
  }

  String? number(String? value) {
    String pattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!.trim()))
      return 'Invalid Phone Number'.tr;
    else
      return null;
  }

  String? amount(String? value) {
    String pattern = r'^\d+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!.trim()))
      return 'validator.amount'.tr;
    else
      return null;
  }

  String? notEmpty(String? value) {
    String pattern = r'^\S+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!.trim()))
      return 'validator.notEmpty'.tr;
    else
      return null;
  }
}
