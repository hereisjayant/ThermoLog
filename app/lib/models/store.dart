class Store {
  int? capacity;
  int? customerCount;
  bool? isSafe;
  List<double>? temperatures;
  String? storeId;
  String? name;
  String? liveStreamId;

  Store(
      { this.capacity,
        this.customerCount,
        this.isSafe,
        this.temperatures,
        this.storeId,
        this.name,
        this.liveStreamId,
      });

  Store.fromJson(Map<String, dynamic> json) {
    capacity = json["capacity"];
    customerCount = json["customerCount"];
    isSafe = json["isSafe"];
    storeId = json["_id"];
    name = json["name"];
    liveStreamId = json["liveStreamId"];
    temperatures = [];
    json["temperatures"].forEach((v) {
      temperatures?.add(v);
    });
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["capacity"] = capacity;
    map["customerCount"] = customerCount;
    map["isSafe"] = isSafe;
    map["_id"] = storeId;
    map["name"] = name;
    map["liveStreamId"] = liveStreamId;
    if (temperatures != null) {
      map["temperatures"] = temperatures?.map((v) => v.toString()).toList();
    } else {
      map["temperatures"] = [];
    }
    return map;
  }
}

