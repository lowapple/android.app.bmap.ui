class ParkDetail {
  String? parkCode;
  String? parkName;
  String? newAddr;
  double? latitude;
  double? longitude;

  ParkDetail(
      {this.parkCode,
      this.parkName,
      this.newAddr,
      this.latitude,
      this.longitude});

  ParkDetail.fromJson(Map<String, dynamic> json) {
    parkCode = json['parkCode'];
    parkName = json['parkName'];
    newAddr = json['newAddr'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parkCode'] = parkCode;
    data['parkName'] = parkName;
    data['newAddr'] = newAddr;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
