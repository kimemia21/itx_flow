class ContractsModel {
  final int contractId;
  final int contractTypeId;
  final int commodityId;
  final int qualityGradeId;
  final DateTime deliveryDate;
  final double price;
  final String description;
  final int id;
  final String contractType;
  final String name;
  final int commodityType;
  final String iconName;
  final String imageUrl;
  final int commodityPrimaryPackingId;
  final int userCompanyId;

  ContractsModel({
    required this.contractId,
    required this.contractTypeId,
    required this.commodityId,
    required this.qualityGradeId,
    required this.deliveryDate,
    required this.price,
    required this.description,
    required this.id,
    required this.contractType,
    required this.name,
    required this.commodityType,
    required this.iconName,
    required this.imageUrl,
    required this.commodityPrimaryPackingId,
    required this.userCompanyId,
  });

  // Factory method to create an instance from JSON
  factory ContractsModel.fromJson(Map<String, dynamic> json) {
    return ContractsModel(
      contractId: json['contract_id'],
      contractTypeId: json['contract_type_id'],
      commodityId: json['commodity_id'],
      qualityGradeId: json['quality_grade_id'],
      deliveryDate: DateTime.parse(json['delivery_date']),
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      id: json['id'],
      contractType: json['contract_type'],
      name: json['name'],
      commodityType: json['commodity_type'],
      iconName: json['icon_name'],
      imageUrl: json['image_url'],
      commodityPrimaryPackingId: json['commodity_primary_packing_id'],
      userCompanyId: json['user_company_id'],
    );
  }

  // Method to validate the data
  // void validate() {
  //   if (price <= 0) {
  //     throw Exception("Price must be greater than zero.");
  //   }

  //   if (deliveryDate.isBefore(DateTime.now())) {
  //     throw Exception("Delivery date must be in the future.");
  //   }
  // }
}
