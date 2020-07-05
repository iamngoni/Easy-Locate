class Id {
  String id;
  bool status;
  Id({this.id, this.status});
  factory Id.fromJson(Map<String, dynamic> json) {
    return Id(id: json['id'], status: json['status']);
  }
}
