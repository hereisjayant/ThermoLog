import 'package:app/models/store.dart';
import 'package:app/services/api_service.dart';
import 'package:app/utils/api_constants.dart';
import 'package:app/utils/remove_null_and_empty_params.dart';

class StoreProvider {
  final _apiService = ApiService();

  Future<List<Store>> storeGetAll({int limit = 30}) async {
    List<Store> newsList = [];
    // Map<String, dynamic> query = {
    //   "limit": "$limit"
    // };
    var res = await _apiService.get(ApiConstants.store);
    res.forEach((element) {
      newsList.add(Store.fromJson(element));
    });
    return newsList;
  } //

  Future<void> storeCreate({
    int? capacity,
    int? customerCount,
    bool? isSafe,
    List<double>? temperatures,
    String? name,
    List<String>? liveStreamIds,
  }) async {
    Map<String, dynamic> body = Map<String, dynamic>.from({
      "capacity": capacity,
      "customerCount": customerCount,
      "isSafe": isSafe,
      "temperatures": temperatures,
      "name": name,
      "liveStreamIds": liveStreamIds,
    });
    body = removeNullAndEmptyParams(body)!;
    return await _apiService.post(ApiConstants.store, body: body);
  }

  Future<Store> storeById(String id) async {
    return Store.fromJson(await _apiService.get(ApiConstants.store + id));
  }

  Future<dynamic> storeFetchLivestream(String liveStreamId) async {
    Map<String, dynamic> query = {"liveStreamId": liveStreamId};
    return Store.fromJson(await _apiService.get(
        ApiConstants.store + ApiConstants.storeFetchLivestream,
        query: query));
  }

  Future<bool> storeUpdate({
    required String storeId,
    int? capacity,
    int? customerCount,
    bool? isSafe,
    List<double>? temperatures,
    List<int>? highTempTimes,
    String? name,
    List<String>? liveStreamIds,
  }) async {
    Map<String, dynamic> body = Map<String, dynamic>.from({
      "capacity": capacity,
      "customerCount": customerCount,
      "isSafe": isSafe,
      "temperatures": temperatures,
      "highTempTimes": highTempTimes,
      "name": name,
      "liveStreamId": liveStreamIds,
    });
    body = removeNullAndEmptyParams(body)!;
    return await _apiService.put(ApiConstants.store + storeId, body: body);
  }

  Future<bool> storeDeleteStore(String id) async {
    return await _apiService.delete(ApiConstants.store + id);
  }
}
