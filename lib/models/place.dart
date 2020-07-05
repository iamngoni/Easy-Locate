class PlaceMe {
  String country;
  String name;
  PlaceMe({this.name, this.country});
  factory PlaceMe.fromJson(Map<String, dynamic> json) {
    return PlaceMe(name: json["name"], country: json["country"]);
  }
}
