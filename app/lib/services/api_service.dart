import 'dart:convert';
import 'dart:io';

import 'package:app/utils/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'app_exception.dart';

class ApiService {
  /// Use this for development
  static String _baseUrl = ApiConstants.developerBaseUrl;
  static String _path = ApiConstants.developerPath;

  /// Use this for deployment
  // static String _baseUrl = ApiConstants.productionBaseUrl;
  // static String _pathUrl = ApiConstants.productionPath;

  Future<dynamic> get(String route, {Map<String, dynamic>? query}) async {
    var responseJson;
    try {
      var response;
      if (query == null) {
        response = await http.get(Uri.https(_baseUrl, _path + route),
            headers: ApiConstants.headers);
      } else {
        response = await http.get(Uri.https(_baseUrl, _path + route, query),
            headers: ApiConstants.headers);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String route,
      {Map<String, dynamic>? body, Map<String, dynamic>? query}) async {
    var responseJson;
    try {
      var response;
      if (query == null) {
        response = await http.post(Uri.https(_baseUrl, _path + route),
            body: jsonEncode(body), headers: ApiConstants.headers);
      } else {
        response = await http.post(Uri.https(_baseUrl, _path + route, query),
            body: jsonEncode(body), headers: ApiConstants.headers);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String route,
      {Map<String, dynamic>? body, Map<String, dynamic>? query}) async {
    var responseJson;
    try {
      var response;
      if (body == null && query == null) {
        response = await http.put(Uri.https(_baseUrl, _path + route),
            headers: ApiConstants.headers);
      } else if (query == null) {
        response = await http.put(Uri.https(_baseUrl, _path + route),
            body: jsonEncode(body), headers: ApiConstants.headers);
      } else {
        print(Uri.http(_baseUrl, _path + route, query));
        response = await http.put(Uri.https(_baseUrl, _path + route, query),
            body: jsonEncode(body), headers: ApiConstants.headers);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String route, {Map<String, dynamic>? query}) async {
    var responseJson;
    try {
      var response;
      if (query == null) {
        response = await http.delete(Uri.https(_baseUrl, _path + route));
      } else {
        response = await http.delete(Uri.https(_baseUrl, _path + route),
            headers: ApiConstants.headers);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @visibleForTesting
  static dynamic returnResponse(http.Response response) {
    // print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 201:
        return jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        throw BadRequestException(response.body);
      case 401:
        throw BadRequestException(response.body);
      case 403:
        throw UnauthorisedException(response.body);
      case 500:
        throw UnauthorisedException(response.body);
      case 404:
        throw BadRequestException(response.body);
      default:
        throw FetchDataException(
            'Error occurred while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}
