import 'package:flutter/material.dart';

class ApiConstants {
  // Shared Preferences

  static const CACHED_USER_DATA = 'CACHED_USER_DATA';

  // developer url
  static String developerBaseUrl = "heroku-391.herokuapp.com";
  static String developerPath = "";

  // local url
  // static String localBaseUrl = "http://localhost:8080";
  // static String localPath = "/dev/api/";

  // header settings
  static Map<String, String> headers = {
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8',
    'Accept': 'application/json',
  };

  // auth routes
  static String auth = "auth/";
  static String authAuthPing = "auth-ping"; // get request
  static String authGoogle = "google"; // post request
  static String logout = "logout"; // get request

  // dyne_user routes
  static String user = "user/";
  static String userByEmailOrId = "byEmailOrId"; // get request
  static String userSimilarName = "similarName"; // get request
  static String userList = "list"; //  get request

  // dyne_user routes
  static String store = "store/";
  static String storeSimilarName = "similarName"; // get request
  static String storeFetchLivestream = "fetchLivestream"; // post request

  static void removeFocusFromEditText({required BuildContext context}) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
