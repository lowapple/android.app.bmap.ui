class ParkDetail {
  String? parkCode;
  String? parkName;
  String? newAddr;
  String? latitude;
  String? longitude;
  String? parkState;
  String? nowParkCount;
  String? maxParkCount;

  ParkDetail(
      {this.parkCode,
      this.parkName,
      this.newAddr,
      this.latitude,
      this.longitude,
      this.parkState,
      this.maxParkCount,
      this.nowParkCount});

  ParkDetail.fromJson(Map<String, dynamic> json) {
    parkCode = json['parkCode'];
    parkName = json['parkName'];
    newAddr = json['newAddr'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    parkState = json['parkState'];
    nowParkCount = json['nowParkCount'];
    maxParkCount = json['maxParkCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parkCode'] = parkCode;
    data['parkName'] = parkName;
    data['newAddr'] = newAddr;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['parkState'] = parkState;
    data['nowParkCount'] = nowParkCount;
    data['maxParkCount'] = maxParkCount;
    return data;
  }
}
