class CntOPtions {
  String contractTitle;
  String contractNumber;
  String dateOfIssue;
  String expirationDate;

  String optionWriterName;
  String optionWriterAddress;
  String optionWriterPhone;
  String optionWriterEmail;

  String optionHolderName;
  String optionHolderAddress;
  String optionHolderPhone;
  String optionHolderEmail;

  String commodityDescription;
  String commodityQuality;
  String commodityQuantity;

  String callOption;
  String putOption;
  String strikePrice;
  String premium;

  String americanStyle;
  String europeanStyle;

  String physicalDelivery;
  String cashSettlement;

  String deliveryLocation;
  String deliveryStartDate;
  String deliveryEndDate;

  String settlementDate;
  String referencePriceSource;

  String notificationMethod;
  String noticePeriod;

  String jurisdiction;

  String arbitration;
  String arbitrationBody;
  String arbitrationLocation;

  String noticeOfDefault;
  String curePeriod;

  String optionWriterSign;
  String optionWriterDate;

  String optionHolderSign;
  String optionHolderDate;

  String additionalTerms;

  CntOPtions({
    this.contractTitle="",
    this.contractNumber="",
    this.dateOfIssue="",
    this.expirationDate="",
    this.optionWriterName="",
    this.optionWriterAddress="",
    this.optionWriterPhone="",
    this.optionWriterEmail="",
    this.optionHolderName="",
    this.optionHolderAddress="",
    this.optionHolderPhone="",
    this.optionHolderEmail="",
    this.commodityDescription="",
    this.commodityQuality="",
    this.commodityQuantity="",
    this.callOption="",
    this.putOption="",
    this.strikePrice="",
    this.premium="",
    this.americanStyle="",
    this.europeanStyle="",
    this.physicalDelivery="",
    this.cashSettlement="",
    this.deliveryLocation="",
    this.deliveryStartDate="",
    this.deliveryEndDate="",
    this.settlementDate="",
    this.referencePriceSource="",
    this.notificationMethod="",
    this.noticePeriod="",
    this.jurisdiction="",
    this.arbitration="",
    this.arbitrationBody="",
    this.arbitrationLocation="",
    this.noticeOfDefault="",
    this.curePeriod="",
    this.optionWriterSign="",
    this.optionWriterDate="",
    this.optionHolderSign="",
    this.optionHolderDate="",
    this.additionalTerms="",
  });
}
