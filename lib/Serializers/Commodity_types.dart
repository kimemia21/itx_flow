class Commoditytype {
  final int id;
  final String name;
  final String description;

  Commoditytype({required this.id, required this.name, required this.description});

  factory Commoditytype.fromJson(Map<String, dynamic> json) {
    return Commoditytype(
        id: json["id"], name: json["name"], description: json["description"]);
  }
}
