class PostModel {
  List<Data>? data;

  PostModel({this.data});

  PostModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? title;
  String? description;
  String? image;
  String? user;
  List<dynamic>? likes;

  Data({this.title, this.description, this.image, this.user, this.likes});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    user = json['user'];
    if (json['likes'] != null) {
      likes = List<dynamic>.from(json['likes']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'];
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['user'] = user;
    if (likes != null) {
      data['likes'] = likes;
    }
    return data;
  }
}
