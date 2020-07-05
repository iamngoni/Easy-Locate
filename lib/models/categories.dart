class Category {
  String name;
  String image;
  Category({this.name, this.image});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json["name"], image: json["image"]);
  }
}
