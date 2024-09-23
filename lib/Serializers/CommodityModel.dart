class Commodity {
  final int id;
  final String name;
  final int commodityGradeId;
  final int commodityType;
  final String description;
  final String iconName;
  final String imageUrl;
  final int commodityPrimaryPackingId;
  final int userCompanyId;
  final String typeName;
  final String typeDescription;
  final String packagingName;
  final String companyName;
  final String companyAddress;
  final String companyContacts;

  Commodity({
    required this.id,
    required this.name,
    required this.commodityGradeId,
    required this.commodityType,
    required this.description,
    required this.iconName,
    required this.imageUrl,
    required this.commodityPrimaryPackingId,
    required this.userCompanyId,
    required this.typeName,
    required this.typeDescription,
    required this.packagingName,
    required this.companyName,
    required this.companyAddress,
    required this.companyContacts,
  });

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      id: json['id'],
      name: json['name'],
      commodityGradeId: json['commodity_grade_id'],
      commodityType: json['commodity_type'],
      description: json['description'],
      iconName: json['icon_name'],
      imageUrl: json['image_url'],
      commodityPrimaryPackingId: json['commodity_primary_packing_id'],
      userCompanyId: json['user_company_id'],
      typeName: json['type_name'],
      typeDescription: json['type_description'],
      packagingName: json['packaging_name'],
      companyName: json['company_name'],
      companyAddress: json['company_address'],
      companyContacts: json['company_contacts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'commodity_grade_id': commodityGradeId,
      'commodity_type': commodityType,
      'description': description,
      'icon_name': iconName,
      'image_url': imageUrl,
      'commodity_primary_packing_id': commodityPrimaryPackingId,
      'user_company_id': userCompanyId,
      'type_name': typeName,
      'type_description': typeDescription,
      'packaging_name': packagingName,
      'company_name': companyName,
      'company_address': companyAddress,
      'company_contacts': companyContacts,
    };
  }
}
