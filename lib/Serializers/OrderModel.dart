class UserOrders {
  final int contractId;
  final int bidId;
  final int orderId;
  final double wonAt;
  final String orderType;
  final DateTime orderDate;
  final int userId;
  final String orderStatus;
  final double bidPrice;
  final String bidType;
  final DateTime bidDate;
  final double? maxPrice;
  final int sessionOpen;
  final int isHighestBid;
  final DateTime? sessionCloseAt;
  final int contractTypeId;
  final int commodityId;
  final int qualityGradeId;
  final DateTime deliveryDate;
  final double price;
  final String description;
  final DateTime? closeDate;
  final DateTime postedOn;
  final int closed;
  final int id;
  final String name;
  final int? commodityGradeId;
  final int commodityType;
  final String iconName;
  final String imageUrl;
  final int commodityPrimaryPackingId;
  final int userCompanyId;

  UserOrders({
    required this.contractId,
    required this.bidId,
    required this.orderId,
    required this.wonAt,
    required this.orderType,
    required this.orderDate,
    required this.userId,
    required this.orderStatus,
    required this.bidPrice,
    required this.bidType,
    required this.bidDate,
    this.maxPrice,
    required this.sessionOpen,
    required this.isHighestBid,
    this.sessionCloseAt,
    required this.contractTypeId,
    required this.commodityId,
    required this.qualityGradeId,
    required this.deliveryDate,
    required this.price,
    required this.description,
    this.closeDate,
    required this.postedOn,
    required this.closed,
    required this.id,
    required this.name,
    this.commodityGradeId,
    required this.commodityType,
    required this.iconName,
    required this.imageUrl,
    required this.commodityPrimaryPackingId,
    required this.userCompanyId,
  });

  // Factory method to create a `UserOrders` object from JSON data
  factory UserOrders.fromJson(Map<String, dynamic> json) {
    print("[\\n order json $json]");

    return UserOrders(
      contractId: json['contract_id'] ?? 0,
      bidId: json['bid_id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      wonAt: (json['won_at'] ?? 0).toDouble(),
      orderType: json['order_type'] ?? '',
      orderDate: json['order_date'] != null ? DateTime.parse(json['order_date']) : DateTime.now(),
      userId: json['user_id'] ?? 0,
      orderStatus: json['order_status'] ?? '',
      bidPrice: (json['bid_price'] ?? 0).toDouble(),
      bidType: json['bid_type'] ?? '',
      bidDate: json['bid_date'] != null ? DateTime.parse(json['bid_date']) : DateTime.now(),
      maxPrice: json['max_price']?.toDouble(),
      sessionOpen: json['session_open'] ?? 0,
      isHighestBid: json['is_highest_bid'] ?? 0,
      sessionCloseAt: json['session_close_at'] != null ? DateTime.parse(json['session_close_at']) : null,
      contractTypeId: json['contract_type_id'] ?? 0,
      commodityId: json['commodity_id'] ?? 0,
      qualityGradeId: json['quality_grade_id'] ?? 0,
      deliveryDate: json['delivery_date'] != null ? DateTime.parse(json['delivery_date']) : DateTime.now(),
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      closeDate: json['close_date'] != null ? DateTime.parse(json['close_date']) : null,
      postedOn: json['posted_on'] != null ? DateTime.parse(json['posted_on']) : DateTime.now(),
      closed: json['closed'] ?? 0,
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      commodityGradeId: json['commodity_grade_id'],
      commodityType: json['commodity_type'] ?? 0,
      iconName: json['icon_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      commodityPrimaryPackingId: json['commodity_primary_packing_id'] ?? 0,
      userCompanyId: json['user_company_id'] ?? 0,
    );
  }
}