class User {
  int? phone;
  String? photoUrl;
  int? lastTime;
  int? safeTime;
  List<dynamic>? storeIds;
  String? userId;
  String? notificationToken;
  String? email;
  String? name;

  User(
      { this.phone,
        this.photoUrl,
        this.lastTime,
        this.safeTime,
        this.userId,
        this.notificationToken,
        this.email,
        this.name,
        });

  User.fromJson(Map<String, dynamic> json) {
    phone = json["phone"];
    photoUrl = json["photoUrl"];
    lastTime = json["lastTime"];
    safeTime = json["safeTime"];
    if (json["storeIds"] != null) {
      storeIds = [];
      json["storeIds"].forEach((v) {
        storeIds?.add(v);
      });
    }
    userId = json["_id"];
    notificationToken = json["notificationToken"];
    email = json["email"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["phone"] = phone;
    map["photoUrl"] = photoUrl;
    map["lastTime"] = lastTime;
    map["safeTime"] = safeTime;
    if (storeIds != null) {
      map["storeIds"] = storeIds?.map((v) => v.toString()).toList();
    } else {
      map["storeIds"] = [];
    }
    map["_id"] = userId;
    map["notificationToken"] = notificationToken;
    map["email"] = email;
    map["name"] = name;
    return map;
  }
}

class StoreMap {
  String? storeId;
  bool? isUsed;

  StoreMap({this.storeId, this.isUsed});

  StoreMap.fromJson(dynamic json) {
    storeId = json["couponId"];
    isUsed = json["isUsed"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["storeId"] = storeId;
    map["isUsed"] = isUsed;
    return map;
  }
}