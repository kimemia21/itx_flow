class PricehistoryModel {
  final int bid_id;
  final int contract_id;
  final double bid_price;
  final String bid_type;
  final String bid_date;
  final int is_highest_bid;
  final int session_open;
  final String session_close_at;
  final String user_masked_email;

  PricehistoryModel({
    required this.bid_id,
    required this.contract_id,
    required this.bid_price,
    required this.bid_type,
    required this.bid_date,
    required this.is_highest_bid,
    required this.session_open,
    required this.session_close_at,
    required this.user_masked_email,
  });

  factory PricehistoryModel.fromJson(Map<String, dynamic> json) {
    // Return the model object, mapping JSON keys to class fields
    return PricehistoryModel(
      bid_id: json['bid_id'],
      contract_id: json['contract_id'],
      bid_price: double.parse(json['bid_price'].toString()),
      bid_type: json['bid_type'],
      bid_date: json['bid_date'],
      is_highest_bid: json['is_highest_bid'],
      session_open: json['session_open'],
      session_close_at: json['session_close_at'],
      user_masked_email: json['user_masked_email'],
    );
  }
}
