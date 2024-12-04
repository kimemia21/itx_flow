class CntSwap {
  final String agreementDate;
  final String partyAName;
  final String partyAAddress;
  final String partyAContactPerson;
  final String partyAEmail;
  final String partyAPhone;
  final String partyBName;
  final String partyBAddress;
  final String partyBContactPerson;
  final String partyBEmail;
  final String partyBPhone;
  
  // New attributes from the HTML document
  final String fixedRate;
  final String floatingRate;
  final String referenceRate;
  final String notionalAmountTerm;
  final String dayCountConvention;
  final String paymentDatesTerm;
  final String paymentCurrency;
  final String commodities;
  final String swapRate;
  final String effectiveDateTerm;
  final String terminationDateTerm;
  final String earlyTerminationNotice;
  final String noticeOfDefault;
  final String curePeriod;
  
  // Signature and witness details
  final String partyASignature;
  final String partyANameInWitness;
  final String partyATitle;
  final String partyBSignature;
  final String partyBNameInWitness;
  final String partyBTitle;

  CntSwap({
    this.agreementDate = '',
    this.partyAName = '',
    this.partyAAddress = '',
    this.partyAContactPerson = '',
    this.partyAEmail = '',
    this.partyAPhone = '',
    this.partyBName = '',
    this.partyBAddress = '',
    this.partyBContactPerson = '',
    this.partyBEmail = '',
    this.partyBPhone = '',
    
    // New attributes with default empty string
    this.fixedRate = '',
    this.floatingRate = '',
    this.referenceRate = '',
    this.notionalAmountTerm = '',
    this.dayCountConvention = '',
    this.paymentDatesTerm = '',
    this.paymentCurrency = '',
    this.commodities = '',
    this.swapRate = '',
    this.effectiveDateTerm = '',
    this.terminationDateTerm = '',
    this.earlyTerminationNotice = '',
    this.noticeOfDefault = '',
    this.curePeriod = '',
    
    // Signature and witness details
    this.partyASignature = '',
    this.partyANameInWitness = '',
    this.partyATitle = '',
    this.partyBSignature = '',
    this.partyBNameInWitness = '',
    this.partyBTitle = '',
  });
}