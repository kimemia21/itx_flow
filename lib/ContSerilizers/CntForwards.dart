class CntForwards {
  // Contract Effective Date
  String effectiveDay;
  String effectiveMonth;
  String effectiveYear;

  // Party A (Seller) Information
  String sellerName;
  String sellerAddress;
  String sellerContact;

  // Party B (Buyer) Information
  String buyerName;
  String buyerAddress;
  String buyerContact;

  // Commodity Description
  String commodityType;
  String commodityQuality;
  String commodityQuantity;

  // Price and Payment
  String unitPrice;
  String totalPrice;
  String currency;
  String paymentTerms;
  String paymentMethod;

  // Delivery Terms
  String deliveryDate;
  String deliveryLocation;
  String deliveryMethod;
  String riskTitleTransfer;

  // Inspection and Quality Assurance
  String inspectionRights;
  String qualityAssurance;

  // Default and Remedies
  String defaultEvents;
  String remedies;

  // Force Majeure
  String noticeOfDefault;
  String curePeriod;

  // Signatures
  String sellerSignature;
  String sellerSignatureName;
  String sellerSignatureTitle;
  String buyerSignature;
  String buyerSignatureName;
  String buyerSignatureTitle;

  // Constructor
  CntForwards({
    this.effectiveDay="",
    this.effectiveMonth="",
    this.effectiveYear="",
    this.sellerName="",
    this.sellerAddress="",
    this.sellerContact="",
    this.buyerName="",
    this.buyerAddress="",
    this.buyerContact="",
    this.commodityType="",
    this.commodityQuality="",
    this.commodityQuantity="",
    this.unitPrice="",
    this.totalPrice="",
    this.currency="",
    this.paymentTerms="",
    this.paymentMethod="",
    this.deliveryDate="",
    this.deliveryLocation="",
    this.deliveryMethod="",
    this.riskTitleTransfer="",
    this.inspectionRights="",
    this.qualityAssurance="",
    this.defaultEvents="",
    this.remedies="",
    this.noticeOfDefault="",
    this.curePeriod="",
    this.sellerSignature="",
    this.sellerSignatureName="",
    this.sellerSignatureTitle="",
    this.buyerSignature="",
    this.buyerSignatureName="",
    this.buyerSignatureTitle="",
  });

}
