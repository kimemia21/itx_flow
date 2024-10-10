class Grade {
  final int id;
  final String gradeName;
  final String gradeDescription;
  final int commodityId;

  Grade({
    required this.id,
    required this.gradeName,
    required this.gradeDescription,
    required this.commodityId,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      gradeName: json['grade_name'],
      gradeDescription: json['grade_description'],
      commodityId: json['commodity_id'],
    );
  }

}
