class TaskModel {
  int? id;
  String? title;
  String? description;
  String? imagePath;
  String? createdAt;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.imagePath,
    this.createdAt,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
  }
}