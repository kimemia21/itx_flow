
class Packing {
  final int packaging_id;

  final String packaging_name;

  Packing({required this.packaging_id, required this.packaging_name});

  factory Packing.fromJson(Map<String, dynamic> Json) {
    return Packing(
        packaging_id: Json["packaging_id"],
        packaging_name: Json["packaging_name"]);
  }
}
