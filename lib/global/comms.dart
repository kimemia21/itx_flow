import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itx/ContSerilizers/CntForwards.dart';
import 'package:itx/ContSerilizers/CntFutures.dart';
import 'package:itx/ContSerilizers/CntOptions.dart';
import 'package:itx/ContSerilizers/CntSwap.dart';
import 'package:itx/Serializers/User.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

UserModel currentUser = UserModel(
    user_id: 0,
    user_email: "",
    user_type: 0,
    authorized: 0,
    token: "",
    user_type_name: "");

CntSwap cntSwap = CntSwap(
   agreementDate: '15 March 2024',
  
  // Party A Details
  partyAName: 'Global Investments Ltd',
  partyAAddress: '123 Financial District, New York, NY 10001, USA',
  partyAContactPerson: 'John Smith',
  partyAEmail: 'john.smith@globalinvestments.com',
  partyAPhone: '+1 (212) 555-7890',
  
  // Party B Details
  partyBName: 'Pacific Trading Corporation',
  partyBAddress: '456 Market Street, San Francisco, CA 94105, USA',
  partyBContactPerson: 'Emily Chen',
  partyBEmail: 'emily.chen@pacifictrading.com',
  partyBPhone: '+1 (415) 555-2345',
  
  // Swap Contract Specifics
  fixedRate: '3.5%',
  floatingRate: 'LIBOR + 2.0%',
  referenceRate: '3-Month LIBOR',
  notionalAmountTerm: 'USD 5,000,000',
  dayCountConvention: '30/360',
  paymentDatesTerm: 'Quarterly on the 15th of March, June, September, and December',
  paymentCurrency: 'United States Dollars (USD)',
  commodities: 'Interest Rate Swap',
  swapRate: '1.25 conversion value',
  
  // Dates
  effectiveDateTerm: '1 April 2024',
  terminationDateTerm: '31 March 2029',
  earlyTerminationNotice: '30 calendar days written notice',
  
  // Default and Cure Details
  noticeOfDefault: '10 business days',
  curePeriod: '15 business days',
  
  // Signature and Witness Details
  partyASignature: 'John Smith',
  partyANameInWitness: 'John Smith',
  partyATitle: 'Chief Financial Officer',
  
  partyBSignature: 'Emily Chen',
  partyBNameInWitness: 'Emily Chen',
  partyBTitle: 'Head of Trading',
);



  CntFutures cntFutures = CntFutures(
    detailsOfTransaction: "Purchase of 100 metric tons of wheat",
    commodity: "Wheat",
    contractCode: "WHT202412",
    sellerDetails: "Seller Co. Ltd, Address XYZ",
    buyerDetails: "Buyer Co. Ltd, Address ABC",
    quantity: "100 metric tons",
    quality: "Grade A",
    deliveryLocation: "Warehouse 12, Port City",
    deliveryDate: "2024-12-15",
    price: "500 USD/ton",
    settlementType: "Cash Settlement",
    settlementDate: "2024-12-20",
    initialMargin: "10,000 USD",
    maintenanceMargin: "5,000 USD",
    dailyPriceLimits: "±10%",
    tradingHours: "09:00 AM - 03:00 PM",
    expirationDate: "2024-12-20",
    lastTradingDay: "2024-12-18",
    noticeOfDefault: "Immediate notice via email",
    curePeriod: "5 business days",
    sellerName: "John Doe",
    sellerTitle: "Director",
    sellerDate: "2024-12-01",
    sellerSign: "JohnDoeSignature",
    buyerName: "Jane Smith",
    buyerTitle: "CEO",
    buyerDate: "2024-12-01",
    buyerSign: "JaneSmithSignature",
    witness1Name: "Alice Johnson",
    witness1Title: "Legal Advisor",
    witness1Date: "2024-12-01",
    witness1Sign: "AliceJohnsonSignature",
    witness2Name: "Bob Williams",
    witness2Title: "Notary Public",
    witness2Date: "2024-12-01",
    witness2Sign: "BobWilliamsSignature",
  );




  CntOPtions cntOptions = CntOPtions(
    contractTitle: "Dummy Options Contract",
    contractNumber: "12345",
    dateOfIssue: "2024-01-01",
    expirationDate: "2024-12-31",
    optionWriterName: "John Doe",
    optionWriterAddress: "123 Writer's Lane, Writerstown",
    optionWriterPhone: "123-456-7890",
    optionWriterEmail: "writer@example.com",
    optionHolderName: "Jane Smith",
    optionHolderAddress: "456 Holder's Avenue, Holderville",
    optionHolderPhone: "987-654-3210",
    optionHolderEmail: "holder@example.com",
    commodityDescription: "Gold",
    commodityQuality: "High",
    commodityQuantity: "100 ounces",
    callOption: "Available",
    putOption: "Not Available",
    strikePrice: "2000 USD",
    premium: "100 USD",
    americanStyle: "Yes",
    europeanStyle: "No",
    physicalDelivery: "Yes",
    cashSettlement: "No",
    deliveryLocation: "Warehouse A",
    deliveryStartDate: "2024-02-01",
    deliveryEndDate: "2024-02-10",
    settlementDate: "2024-02-15",
    referencePriceSource: "Market Index",
    notificationMethod: "Email",
    noticePeriod: "3 days",
    jurisdiction: "Kenya",
    arbitration: "Yes",
    arbitrationBody: "International Arbitration Body",
    arbitrationLocation: "Nairobi",
    noticeOfDefault: "7 days",
    curePeriod: "7 days",
    optionWriterSign: "John Doe's Signature",
    optionWriterDate: "2024-01-01",
    optionHolderSign: "Jane Smith's Signature",
    optionHolderDate: "2024-01-01",
    additionalTerms: "No additional terms.",
  );


  CntForwards cntForwards = CntForwards(
    effectiveDay: "15",
    effectiveMonth: "August",
    effectiveYear: "23",
    sellerName: "John Doe",
    sellerAddress: "123 Main St, Nairobi, Kenya",
    sellerContact: "john.doe@example.com",
    buyerName: "Jane Smith",
    buyerAddress: "456 Elm St, Mombasa, Kenya",
    buyerContact: "jane.smith@example.com",
    commodityType: "Coffee Beans",
    commodityQuality: "Grade A",
    commodityQuantity: "1000",
    unitPrice: "200.50",
    totalPrice: "200500.00",
    currency: "KES",
    paymentTerms: "30 days from delivery",
    paymentMethod: "Bank Transfer",
    deliveryDate: "DateTime(2024, 9, 1)",
    deliveryLocation: "Nairobi Warehouse",
    deliveryMethod: "Truck",
    riskTitleTransfer: "Upon Delivery",
    inspectionRights: "Buyer reserves the right to inspect the goods upon delivery",
    qualityAssurance: "ISO Certified Quality Standards",
    defaultEvents: "Non-payment or late delivery",
    remedies: "Termination, damages, or specific performance",
    noticeOfDefault: "10",
    curePeriod: "15",
    sellerSignature: "John Doe",
    sellerSignatureName: "John Doe",
    sellerSignatureTitle: "Director",
    buyerSignature: "Jane Smith",
    buyerSignatureName: "Jane Smith",
    buyerSignatureTitle: "Purchasing Manager",
  );












 Map<String, String> swapIds = {};
 Map<String, String> futureIds = {};
  Map<String, String> forwardsIds = {};
 Map<String, String> optionsIds = {};




var grace_ip = "http://185.141.63.56:3067/api/v1/chats/unread";
var grace_html = "http://185.141.63.56:3067/api/v1/contracts/type/";

Map<String, dynamic> stringToMap(String eventString) {
  try {
    return jsonDecode(eventString) as Map<String, dynamic>;
  } catch (e) {
    print('Error decoding JSON: $e');
    return {};
  }
}

Widget loading = LoadingAnimationWidget.staggeredDotsWave(
  color: Colors.green,
  size: 30,
);
