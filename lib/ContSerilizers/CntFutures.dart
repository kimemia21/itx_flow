class CntFutures {
  // Contract Details
  final String detailsOfTransaction;
  final String commodity;
  final String contractCode;

  // Parties
  final String sellerDetails;
  final String buyerDetails;

  // Contract Specifications
  final String quantity;
  final String quality;
  final String deliveryLocation;
  final String deliveryDate;
  final String price;

  // Settlement
  final String settlementType;
  final String settlementDate;

  // Margin Requirements
  final String initialMargin;
  final String maintenanceMargin;

  // Price Limits/Stabilization
  final String dailyPriceLimits;

  // Trading Hours
  final String tradingHours;

  // Contract Expiration
  final String expirationDate;
  final String lastTradingDay;

  // Default and Remedies
  final String noticeOfDefault;
  final String curePeriod;

  // Seller Details
  final String sellerName;
  final String sellerTitle;
  final String sellerDate;
  final String sellerSign;

  // Buyer Details
  final String buyerName;
  final String buyerTitle;
  final String buyerDate;
  final String buyerSign;

  // Witness 1 Details
  final String witness1Name;
  final String witness1Title;
  final String witness1Date;
  final String witness1Sign;

  // Witness 2 Details
  final String witness2Name;
  final String witness2Title;
  final String witness2Date;
  final String witness2Sign;

    CntFutures({
    this.detailsOfTransaction = '',
    this.commodity = '',
    this.contractCode = '',
    this.sellerDetails = '',
    this.buyerDetails = '',
    this.quantity = '',
    this.quality = '',
    this.deliveryLocation = '',
    this.deliveryDate = '',
    this.price = '',
    this.settlementType = '',
    this.settlementDate = '',
    this.initialMargin = '',
    this.maintenanceMargin = '',
    this.dailyPriceLimits = '',
    this.tradingHours = '',
    this.expirationDate = '',
    this.lastTradingDay = '',
    this.noticeOfDefault = '',
    this.curePeriod = '',
    this.sellerName = '',
    this.sellerTitle = '',
    this.sellerDate = '',
    this.sellerSign = '',
    this.buyerName = '',
    this.buyerTitle = '',
    this.buyerDate = '',
    this.buyerSign = '',
    this.witness1Name = '',
    this.witness1Title = '',
    this.witness1Date = '',
    this.witness1Sign = '',
    this.witness2Name = '',
    this.witness2Title = '',
    this.witness2Date = '',
    this.witness2Sign = '',
  });
}
