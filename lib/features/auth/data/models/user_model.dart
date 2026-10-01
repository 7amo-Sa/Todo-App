class UserModel {
  int? id;
  String? imagePath;
  String? username;

  UserModel({this.id, this.username, this.imagePath});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    imagePath = json['image_path'] ?? json['image'] ?? json['imagePath'];
  }
}
