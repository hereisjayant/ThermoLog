import 'package:app/models/store.dart';
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

  Future<void> userCreate({
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

  Future<User> userById(String id) async {
    return User.fromJson(await _apiService
        .get(ApiConstants.user + id + ApiConstants.userByEmailOrId));
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