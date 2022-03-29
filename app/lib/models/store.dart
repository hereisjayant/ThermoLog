class Store {
  int? capacity;
  int? customerCount;
  bool? isSafe;
  List<double>? temperatures;
  List<int>? highTempTimes;
  String? storeId;
  String? name;
  List<String>? liveStreamIds;
  String? streamUrl;

  Store({
    this.capacity,
    this.customerCount,
    this.isSafe,
    this.temperatures,
    this.storeId,
    this.name,
    this.liveStreamIds,
    this.streamUrl,
  });

  Store.fromJson(Map<String, dynamic> json) {
    capacity = json["capacity"];
    customerCount = json["customerCount"];
    isSafe = json["isSafe"];
    storeId = json["_id"]["\$oid"];
    name = json["name"];
    streamUrl = json["streamUrl"];
    liveStreamIds = [];
    if (json["liveStreamIds"] != null) {
      json["liveStreamIds"].forEach((v) {
        liveStreamIds?.add(v);
      });
    }
    highTempTimes = [];
    if (json["highTempTimes"] != null) {
      json["highTempTimes"].forEach((v) {
        highTempTimes?.add(v);
      });
    }
    temperatures = [];
    json["temperatures"].forEach((v) {
      double temp = v.toDouble();
      temperatures?.add(temp);
    });
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["capacity"] = capacity;
    map["customerCount"] = customerCount;
    map["isSafe"] = isSafe;
    map["_id"] = storeId;
    map["name"] = name;
    map["streamUrl"] = streamUrl;
    if (liveStreamIds != null) {
      map["liveStreamIds"] = liveStreamIds?.map((v) => v.toString()).toList();
    } else {
      map["liveStreamIds"] = [];
    }
    if (highTempTimes != null) {
      map["highTempTimes"] = highTempTimes?.map((v) => v.toString()).toList();
    } else {
      map["highTempTimes"] = [];
    }
    if (temperatures != null) {
      map["temperatures"] = temperatures?.map((v) => v.toString()).toList();
    } else {
      map["temperatures"] = [];
    }
    return map;
  }
}
