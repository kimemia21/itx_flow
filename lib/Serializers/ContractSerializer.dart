class ContractsModel {
  final int contractId;
  final int contractTypeId;
  final int commodityId;
  final int qualityGradeId;
  final DateTime deliveryDate;
  final double price;
  final String description;
  final DateTime closeDate;
  final DateTime postedOn;
  final DateTime? closedOn;
  final int id;
  final String name;
  final int user_id;
  final int commodityGradeId;
  final int commodityType;
  final String iconName;
  final String imageUrl;
  final int commodityPrimaryPackingId;
  final int userCompanyId;
  final String contractType;
  final int canBid;
  final String? companyName;
  final String? companyAddress;
  final String? companyContacts;
  final String? contract_packing;
  final int liked;
  final int bought;
  final int paid;
  final bool closed;
  final String grade_name;
  final String? contract_user;

  final int warehouse_id;
  final int? warehouse_status; // Changed to nullable
  final String? warehouse_status_message;

  ContractsModel({
    required this.contractId,
    required this.contractTypeId,
    required this.commodityId,
    required this.qualityGradeId,
    required this.deliveryDate,
    required this.price,
    required this.description,
    required this.closeDate,
    required this.postedOn,
    this.closedOn,
    required this.id,
    required this.name,
    required this.commodityGradeId,
    required this.commodityType,
    required this.iconName,
    required this.imageUrl,
    required this.commodityPrimaryPackingId,
    required this.userCompanyId,
    required this.contractType,
    required this.canBid,
    this.companyName,
    this.companyAddress,
    this.companyContacts,
    required this.liked,
    required this.bought,
    required this.paid,
    required this.closed,
    required this.contract_packing,
    required this.contract_user,
    required this.grade_name,
    required this.warehouse_id,
    this.warehouse_status,
    this.warehouse_status_message,
    required this.user_id,
  });

  // Factory method to create an instance from JSON
  factory ContractsModel.fromJson(Map<String, dynamic> json) {
    try {
      return ContractsModel(
        contractId: json['contract_id'],
        contractTypeId: json['contract_type_id'],
        commodityId: json['commodity_id'],
        qualityGradeId: json['quality_grade_id'],
        deliveryDate: DateTime.parse(json['delivery_date']),
        price: (json['price'] as num).toDouble(),
        description: json['contract_description'],
        closeDate: DateTime.parse(json['close_date']),
        postedOn: DateTime.parse(json['posted_on']),
        user_id: json["user_id"],
        closedOn: json['closed_on'] != null
            ? DateTime.parse(json['closed_on'])
            : null,
        id: json['id'],
        name: json['name'],
        commodityGradeId: json['commodity_grade_id'],
        commodityType: json['commodity_type'],
        iconName: json['icon_name'],
        imageUrl: json['image_url'],
        commodityPrimaryPackingId: json['commodity_primary_packing_id'],
        userCompanyId: json['user_company_id'],
        contractType: json['contract_type'],
        canBid: json['can_bid'],
        companyName: json['company_name'],
        companyAddress: json['company_address'],
        companyContacts: json['company_contacts'],
        liked: json['liked'],
        bought: json['bought'],
        paid: json['paid'],
        closed: json['closed'] == 1,
        contract_packing: json["contract_packing"] ?? "1kg",
        grade_name: json["grade_name"] ?? "Grade Name",
        contract_user: json["contract_user"] ?? "user contract",
        warehouse_id: json["warehouse_id"],
        warehouse_status: json["warehouse_status"],
        warehouse_status_message: json["warehouse_status_message"], 
      );
    } catch (e, stackTrace) {
      print('Error parsing ContractsModel: $e');
      print('Stack trace: $stackTrace');
      print('Problematic JSON: $json');
      rethrow; 
    }
  }
}
