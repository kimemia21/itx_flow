

class CompanyModel {
  final int id;
  final int userId;
  final String companyName;
  final String companyAddress;
  final String companyContacts;

  CompanyModel({
    required this.id,
    required this.userId,
    required this.companyName,
    required this.companyAddress,
    required this.companyContacts,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    // Check for missing keys or null values and print if found
    final requiredFields = ['id', 'user_id', 'company_name', 'company_address', 'company_contacts'];
    for (var field in requiredFields) {
      if (!json.containsKey(field) || json[field] == null) {
        print('Error: Missing or null field: $field');
      }
    }

    // Deserialize
    return CompanyModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      companyName: json['company_name'] ?? 'Unknown Company',
      companyAddress: json['company_address'] ?? 'Unknown Address',
      companyContacts: json['company_contacts'] ?? 'Unknown Contact',
    );
  }

  static List<CompanyModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CompanyModel.fromJson(json)).toList();
  }
}