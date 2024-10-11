class Commodity {
  final int? id;
  final String? name;
  final int? commodityGradeId;
  final int? commodityType;
  final String? description;
  final String? iconName;
  final String? imageUrl;
  final int? commodityPrimaryPackingId;
  final int? userCompanyId;
  final String? typeName;
  final String? typeDescription;
  final String? packagingName;
  final String? companyName;
  final String? companyAddress;
  final String? companyContacts;
  

  Commodity({
    this.id,
    this.name,
    this.commodityGradeId,
    this.commodityType,
    this.description,
    this.iconName,
    this.imageUrl,
    this.commodityPrimaryPackingId,
    this.userCompanyId,
    this.typeName,
    this.typeDescription,
    this.packagingName,
    this.companyName,
    this.companyAddress,
    this.companyContacts,
  });

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      id: json['id'] as int?,
      name: json['name'] as String?,
      commodityGradeId: json['commodity_grade_id'] as int?,
      commodityType: json['commodity_type'] as int?,
      description: json['description'] as String?,
      iconName: json['icon_name'] as String? ?? "iconname",
      imageUrl: json['image_url'] as String?,
      commodityPrimaryPackingId: json['commodity_primary_packing_id'] as int?,
      userCompanyId: json['user_company_id'] as int?,
      typeName: json['type_name'] as String?,
      typeDescription: json['type_description'] as String?,
      packagingName: json['packaging_name'] as String?,
      companyName: json['company_name'] as String?,
      companyAddress: json['company_address'] as String?,
      companyContacts: json['company_contacts'] as String?,
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
