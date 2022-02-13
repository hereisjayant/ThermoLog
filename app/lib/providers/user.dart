import 'package:app/models/store.dart';
import 'package:app/models/user.dart';
import 'package:app/services/api_service.dart';
import 'package:app/utils/api_constants.dart';
import 'package:app/utils/remove_null_and_empty_params.dart';

class UserProvider {
  final _apiService = ApiService();

  Future<List<User>> userGetAll({int limit = 30}) async {
    List<User> newsList = [];
    // Map<String, dynamic> query = {
    //   "limit": "$limit"
    // };
    var res = await _apiService.get(
        ApiConstants.user + ApiConstants.userGetAll);
    res.forEach((element) {
      newsList.add(User.fromJson(element));
    });
    return newsList;
  } //

  Future<bool> userCreate({
    int? phone,
    String? photoUrl,
    int? lastTime,
    int? safeTime,
    List<dynamic>? storeIds,
    String? notificationToken,
    String? email,
    String? name,
  }) async {
    Map<String, dynamic> body = Map<String, dynamic>.from({
      "phone": phone,
      "photoUrl": photoUrl,
      "lastTime": lastTime,
      "safeTime": safeTime,
      "notificationToken": notificationToken,
      "email": email,
      "name": name,
    });
    body = removeNullAndEmptyParams(body)!;
    return await _apiService.post(
        ApiConstants.user + ApiConstants.userCreate,
        body: body);
  }

  Future<User?> userByEmailOrId({String? email, String? userId}) async {
    if (email == null && userId == null)
      throw Exception("please use email or name");
    Map<String, dynamic> query = {};
    if (email != null) {
      query['email'] = email;
    } else {
      query['userId'] = userId;
    }
    var route = ApiConstants.user + ApiConstants.userByEmailOrId;
    var response = await _apiService.get(route, query: query);
    return response == null ? null : User.fromJson(response);
  }

  Future<bool> userUpdate({
    int? phone,
    String? photoUrl,
    int? lastTime,
    int? safeTime,
    List<dynamic>? storeIds,
    required String userId,
    String? notificationToken,
    String? email,
    String? name,
  }) async {
    Map<String, dynamic> body = Map<String, dynamic>.from({
      "phone": phone,
      "photoUrl": photoUrl,
      "lastTime": lastTime,
      "safeTime": safeTime,
      "email": email,
      "name": name,
    });
    body = removeNullAndEmptyParams(body)!;
    return await _apiService
        .post(ApiConstants.user +userId+ ApiConstants.userUpdate, body: body);
  }

  Future<bool> userDeleteUser(String id) async {
    return await _apiService.delete(
        ApiConstants.user + id + ApiConstants.userDeleteUser);
  }
}