// Main response model
import 'package:itx/Serializers/CommodityModel.dart';

class CommodityResponse {
  final bool rsp;
  final String msg;
  final List<Commodity> data;
  final List<PriceHistory> priceHistory;

  CommodityResponse({
    required this.rsp,
    required this.msg,
    required this.data,
    required this.priceHistory,
  });

  factory CommodityResponse.fromJson(Map<String, dynamic> json) {
    return CommodityResponse(
      rsp: json['rsp'],
      msg: json['msg'],
      data: List<Commodity>.from(
          json['data'].map((item) => Commodity.fromJson(item))),
      priceHistory: List<PriceHistory>.from(
          json['pricehistory'].map((item) => PriceHistory.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rsp': rsp,
      'msg': msg,
      'data': data.map((item) => item.toJson()).toList(),

      'pricehistory': priceHistory.map((item) => item.toJson()).toList(),
    };
  }
}


// Price history model
class PriceHistory {
  final int priceHistoryId;
  final int commodityId;
  final DateTime priceDate;
  final double price;

  PriceHistory({
    required this.priceHistoryId,
    required this.commodityId,
    required this.priceDate,
    required this.price,
  });

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    return PriceHistory(
      priceHistoryId: json['price_history_id'],
      commodityId: json['commodity_id'],
      priceDate: DateTime.parse(json['price_date']),
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price_history_id': priceHistoryId,
      'commodity_id': commodityId,
      'price_date': priceDate.toIso8601String(),
      'price': price,
    };
  }
}