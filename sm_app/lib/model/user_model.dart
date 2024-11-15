// ignore_for_file: prefer_collection_literals, unnecessary_this

class UserModel {
  Data? data;

  UserModel({this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? username;
  String? email;
  String? bio;
  String? avatar;

  Data({this.username, this.email, this.bio, this.avatar});

  Data.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    bio = json['bio'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['bio'] = this.bio;
    data['avatar'] = this.avatar;
    return data;
  }
}
