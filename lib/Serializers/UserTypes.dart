class UserTypeModel {
  final int id;
  final String name;
  final String description;

  UserTypeModel(
    {
     required this.name,
    required  this.description, 
    required this.id,
    
  });

  factory UserTypeModel.fromJson(Map<String, dynamic> json) {
    // Check for missing keys or null values and print if found
    final requiredFields = [
      'id','name','description'

    ];
    for (var field in requiredFields) {
      if (!json.containsKey(field) || json[field] == null) {
        print('Error: Missing or null field: $field');
      }
    }

    // Deserialize
    return UserTypeModel(
      id: json['id'] ?? 0,
      name: json["name"]??"name",
      description: json["description"]??"desc"
      

    );
  }

  // static List<CompanyModel> fromJsonList(List<dynamic> jsonList) {
  //   return jsonList.map((json) => CompanyModel.fromJson(json)).toList();
  // }
}
