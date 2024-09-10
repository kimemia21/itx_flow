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
    print("hello");

    return CommodityModel(
      id: json.containsKey('id') ? json['id'] : 0,
      name: json.containsKey('name') ? json['name'] : 'Unknown',
      commodityType:
          json.containsKey('commodity_type') ? json['commodity_type'] : 0,
      description: json.containsKey('description')
          ? json['description']
          : 'No description available',
      iconName: json.containsKey('icon_name') ? json['icon_name'] : '',
      imageUrl: json.containsKey('image_url') ? json['image_url'] : '',
      commodityPrimaryPackingId:
          json.containsKey('commodity_primary_packing_id')
              ? json['commodity_primary_packing_id']
              : 0,
      userCompanyId:
          json.containsKey('user_company_id') ? json['user_company_id'] : 0,
      typeName: json.containsKey('type_name') ? json['type_name'] : null,
      typeDescription: json.containsKey('type_description')
          ? json['type_description']
          : null,
      packagingName:
          json.containsKey('packaging_name') ? json['packaging_name'] : '',
      companyName: json.containsKey('company_name') ? json['company_name'] : '',
      companyAddress:
          json.containsKey('company_address') ? json['company_address'] : '',
      companyContacts:
          json.containsKey('company_contacts') ? json['company_contacts'] : '',
    );
  }
}
