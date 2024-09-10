class CommodityModel {
  final int id;
  final String name;
  final int commodityType;
  final String description;
  final String iconName;
  final String imageUrl;
  final int commodityPrimaryPackingId;
  final int userCompanyId;
  final String? typeName;
  final String? typeDescription;
  final String packagingName;
  final String companyName;
  final String companyAddress;
  final String companyContacts;

  CommodityModel({
    required this.id,
    required this.name,
    required this.commodityType,
    required this.description,
    required this.iconName,
    required this.imageUrl,
    required this.commodityPrimaryPackingId,
    required this.userCompanyId,
    this.typeName,
    this.typeDescription,
    required this.packagingName,
    required this.companyName,
    required this.companyAddress,
    required this.companyContacts,
  });

  factory CommodityModel.fromJson(Map<String, dynamic> json) {
    // List of expected keys
    List<String> expectedKeys = [
      'id',
      'name',
      'commodity_type',
      'description',
      'icon_name',
      'image_url',
      'commodity_primary_packing_id',
      'user_company_id',
      'type_name',
      'type_description',
      'packaging_name',
      'company_name',
      'company_address',
      'company_contacts'
    ];

    // Check for missing keys
    for (String key in expectedKeys) {
      if (!json.containsKey(key)) {
        print("Missing key: $key");
      }
    }

    // Return the model object, checking for each key
    return CommodityModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      commodityType: json['commodity_type'] ?? 0,
      description: json['description'] ?? 'No description available',
      iconName: json['icon_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      commodityPrimaryPackingId: json['commodity_primary_packing_id'] ?? 0,
      userCompanyId: json['user_company_id'] ?? 0,
      typeName: json['type_name'],
      typeDescription: json['type_description'],
      packagingName: json['packaging_name'] ?? '',
      companyName: json['company_name'] ?? '',
      companyAddress: json['company_address'] ?? '',
      companyContacts: json['company_contacts'] ?? '',
    );
  }
}
