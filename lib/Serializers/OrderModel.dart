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
    required this.closeDate,
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

  // Factory method to create a `Contract` object from JSON data
  factory UserOrders.fromJson(Map<String, dynamic> json) {
    print(("[\\n order json $json]"));
    return UserOrders(
      contractId: json['contract_id'],
      bidId: json['bid_id'],
      orderId: json['order_id'],
      wonAt: json['won_at'].toDouble(),
      orderType: json['order_type'],
      orderDate: DateTime.parse(json['order_date']),
      userId: json['user_id'],
      orderStatus: json['order_status'],
      bidPrice: json['bid_price'].toDouble(),
      bidType: json['bid_type'],
      bidDate: DateTime.parse(json['bid_date']),
      maxPrice: json['max_price'] != null ? json['max_price'].toDouble() : null,
      sessionOpen: json['session_open'],
      isHighestBid: json['is_highest_bid'],
      sessionCloseAt: json['session_close_at'] != null
          ? DateTime.parse(json['session_close_at'])
          : null,
      contractTypeId: json['contract_type_id'],
      commodityId: json['commodity_id'],
      qualityGradeId: json['quality_grade_id'],
      deliveryDate: DateTime.parse(json['delivery_date']),
      price: json['price'].toDouble(),
      description: json['description'],
      closeDate: DateTime.parse(json['close_date']),
      postedOn: DateTime.parse(json['posted_on']),
      closed: json['closed'],
      id: json['id'],
      name: json['name'],
      commodityGradeId: json['commodity_grade_id'],
      commodityType: json['commodity_type'],
      iconName: json['icon_name'],
      imageUrl: json['image_url'],
      commodityPrimaryPackingId: json['commodity_primary_packing_id'],
      userCompanyId: json['user_company_id'],
    );
  }
}
