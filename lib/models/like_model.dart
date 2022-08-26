class LikeModel {
  int? id;
  String? type;
  String? likeName;
  String? likeAddress;

  LikeModel({this.id, this.type, this.likeName, this.likeAddress});

  LikeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    likeName = json['likeName'];
    likeAddress = json['likeAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['likeName'] = likeName;
    data['likeAddress'] = likeAddress;
    return data;
  }
}
