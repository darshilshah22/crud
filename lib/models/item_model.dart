class ItemModel {
  String? id;
  String? title;
  String? description;
  String? imageUrl;
  String? createdAt;

  ItemModel({this.id, this.title, this.description, this.imageUrl, this.createdAt});

  ItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = imageUrl;
    data['created_at'] = createdAt;

    return data;
  }
}
