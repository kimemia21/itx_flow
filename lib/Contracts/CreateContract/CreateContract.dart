import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Commodities.dart/ComDropDown.dart';
import 'package:itx/Contracts/CreateContract/Grade.dart';
import 'package:itx/DropDowns.dart/CustomDropDown.dart';
import 'package:itx/Contracts/CreateContract/PackingDropDown.dart';
import 'package:itx/DropDowns.dart/WareHouseDropDown.dart';
import 'package:itx/Serializers/CommParams.dart';
import 'package:itx/Temp/htmltest.dart';
import 'package:itx/global/comms.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class CreateContract extends StatefulWidget {
  @override
  _CreateContractState createState() => _CreateContractState();
}

class _CreateContractState extends State<CreateContract>
    with TickerProviderStateMixin {
  List<CommParams> params = [];
  Map<int, TextEditingController> controllers = {};
  bool isLoading = true;
  String? errorMessage;
  int selectedCommodityId = 0;
  String? selectedQuality;
  DateTime? selectedDate;
  String? selectedMetric;
  int? selectedWareHouseId;
  String selectedGradeName = "";
  String selectedCommodityName = "";
  String selectedWareHouseName = "";

  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final metricController = TextEditingController();
  String selectedTabName = 'Futures';
  String? _packingMetrics;

  late TabController _tabController;
  List<DeliveryMilestone> deliveryMilestones = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTabName = getTabName(_tabController.index);
      });
    });
    _fetchParams();
  }

  String getTabName(int index) {
    List<String> tabNames = ['Futures', 'Forwards', 'Options', 'Swaps', 'Spot'];
    return tabNames[index];
  }

  Future<void> _fetchParams() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      params = await CommodityService.getPrams(
          context: context, id: selectedCommodityId);
      for (var param in params) {
        controllers[param.id] = TextEditingController();
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching params: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: Text('Create Contract',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Futures'),
                Tab(text: 'Forwards'),
                Tab(text: 'Options'),
                Tab(text: 'Swaps'),
                Tab(text: "Spot")
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              isScrollable: true,
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchParams,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      return Scrollbar(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add $selectedTabName Contract info ',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommodityDropdown(
                          isForAppBar: false,
                          onCommoditySelected: (commodity, commodityname) {
                            setState(() {
                              selectedCommodityId = int.parse(commodity.toString());
                              selectedCommodityName = commodityname.toString();
                              print(selectedCommodityId);
                            });
                          },
                        ),
                        Text(selectedCommodityName)
                      ],
                    ),
                    if (selectedCommodityId != null) ...[
                      SizedBox(height: 16),
                      Visibility(
                        visible: context.watch<appBloc>().commId != 0,
                        child: GradeDropdown(
                          onGradeSelectedId: (onGradeSelected, name) {
                            setState(() {
                              selectedQuality = onGradeSelected;
                              selectedGradeName = name!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      PackingDropdown(
                          onPackingSelected: (packingId, packingName) {
                        setState(() {
                          _packingMetrics = packingName;
                        });
                        final String packingVolume =
                            '${quantityController.text} ${_packingMetrics ?? ''}';
                        print(packingVolume);
                      }),
                      SizedBox(height: 16),
                      Visibility(
                        visible: _packingMetrics != null,
                        child: buildTextField(
                          controller: quantityController,
                          title: 'Quantity in ${_packingMetrics}s',
                          icon: Icons.production_quantity_limits,
                          isTextField: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a quantity';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Visibility(
                        visible: _packingMetrics != null,
                        child: buildTextField(
                          controller: priceController,
                          title: 'Enter Price Per $_packingMetrics',
                          icon: Icons.attach_money,
                          isTextField: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a  price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      buildTextField(
                        controller: descriptionController,
                        title: 'Description (Additional info)',
                        icon: Icons.description,
                        maxLines: 4,
                        isTextField: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length < 10) {
                            return 'Description should be at least 10 characters long';
                          }
                          return null;
                        },
                      ),
                    ],
                    SizedBox(height: 20),
                    WarehouseSearchDropdown(
                      onWarehouseSelected: (WareHouseId, name) {
                        setState(() {
                          selectedWareHouseId = WareHouseId;
                          selectedWareHouseName = name;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              buildDeliveryMilestoneWidget(),
              SizedBox(height: 16),
              Column(
                children: deliveryMilestones
                    .map(
                      (milestone) => ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        title: Text(
                          'Date: ${DateFormat('yyyy-MM-dd').format(milestone.date)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quantity: ${milestone.quantity}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              SizedBox(height: 4.0),
                              // Text(
                              //   'Metric: ${milestone.metric}',
                              //   style: TextStyle(color: Colors.grey[600]),
                              // ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              deliveryMilestones.remove(milestone);
                            });
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: context.watch<appBloc>().isLoading
                    ? LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white, size: 20)
                    : Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      );
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String title,
    int maxLines = 1,
    IconData? icon,
    required bool isTextField,
    String? Function(String?)? validator,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.04,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              keyboardType:
                  isTextField ? TextInputType.name : TextInputType.phone,
              controller: controller,
              maxLines: maxLines,
              inputFormatters:
                  isTextField ? [] : [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: icon != null
                    ? Icon(
                        icon,
                        color: Colors.green,
                        size: screenWidth * 0.06,
                      )
                    : null,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: 12,
                ),
              ),
              validator: validator,
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget buildDeliveryMilestoneWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Delivery Milestone',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          buildDatePicker(
            title: 'Delivery Date',
            selectedDate: selectedDate,
            onDateSelected: (date) => setState(() => selectedDate = date),
          ),
          // SizedBox(height: 16),
          // buildTextField(
          //   controller: quantityController,
          //   title: 'Quantity',
          //   icon: Icons.production_quantity_limits,
          //   isTextField: false,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter a quantity';
          //     }
          //     if (double.tryParse(value) == null) {
          //       return 'Please enter a valid number';
          //     }
          //     return null;
          //   },
          // ),
          // MetricDropDown(
          //   onSelectMetric: (metric) {
          //     setState(() {
          //       selectedMetric = metric;
          //     });
          //   },
          // ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _addDeliveryMilestone();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 5,
            ),
            child: Text(
              'Click to Add Milestone',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDatePicker({
    required String title,
    required DateTime? selectedDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: Colors.green,
                    colorScheme: ColorScheme.light(primary: Colors.green),
                    buttonTheme:
                        ButtonThemeData(textTheme: ButtonTextTheme.primary),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null && picked != selectedDate) {
              onDateSelected(picked);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? DateFormat.yMMMd().format(selectedDate)
                      : 'Date',
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
                Icon(Icons.calendar_today, color: Colors.green),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  void _addDeliveryMilestone() {
    if (selectedDate != null && quantityController.text.isNotEmpty) {
      setState(() {
        deliveryMilestones.add(DeliveryMilestone(
          date: selectedDate!,
          quantity: double.parse(quantityController.text),
        ));
        // selectedDate = null;
        // quantityController.clear();
        // selectedMetric = null;
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Map<int, int> tabToContractTypeId = {
      0: 1, // Futures
      1: 2, // Forwards
      2: 3, // Options
      3: 4, // Swaps
      4: 5, // Spot
    };

    int contractTypeId = tabToContractTypeId[_tabController.index] ?? 1;

    print('Form submitted');
    params.forEach((param) {
      print('${param.name}: ${controllers[param.id]?.text}');
    });
    print('Delivery Milestones:');
    deliveryMilestones.forEach((milestone) {
      print(
          'Date: ${DateFormat('yyyy-MM-dd').format(milestone.date)}, Quantity: ${milestone.quantity}');
    });

    double price = double.tryParse(priceController.text) ?? 0.0;
    double units = 0.0;
    for (var param in params) {
      if (param.name.toLowerCase() == 'units' ||
          param.name.toLowerCase() == 'quantity') {
        units = double.tryParse(controllers[param.id]?.text ?? '') ?? 0.0;
        break;
      }
    }

    DateTime? deliveryStartDate;
    DateTime? deliveryEndDate;
    if (deliveryMilestones.isNotEmpty) {
      deliveryStartDate = deliveryMilestones
          .map((m) => m.date)
          .reduce((a, b) => a.isBefore(b) ? a : b);
      deliveryEndDate = deliveryMilestones
          .map((m) => m.date)
          .reduce((a, b) => a.isAfter(b) ? a : b);
    }
    final String packingVolume =
        '${quantityController.text}${_packingMetrics?.isNotEmpty == true ? ' ' : ''}${_packingMetrics ?? ''}';
    print(packingVolume);

    Map<String, dynamic> contractData = {
      "contract_type_id": contractTypeId,
      "commodity_id": selectedCommodityId,
      "quality_grade_id": int.tryParse(selectedQuality ?? '') ?? 1,
      "delivery_start_date": deliveryStartDate?.toIso8601String() ?? "",
      "delivery_end_date": deliveryEndDate?.toIso8601String() ?? "",
      "warehouse_id": selectedWareHouseId,
      "packing": packingVolume,
      "price": price,
      "units": units,
      "description": descriptionController.text,
      "milestones": deliveryMilestones
          .map((milestone) => {
                "date": DateFormat('yyyy-MM-dd').format(milestone.date),
                "metric": packingVolume,
                "value": milestone.quantity
              })
          .toList(),
      "params": [
        {"param_id": 1, "param_value": 100}
      ]

      // params
      //     .map((param) => {
      //           "param_id": param.id,
      //           "param_value": controllers[param.id]?.text ?? ''
      //         })
      // .toList(),
    };

    try {
      optionsIds = {
        "contract_title": cntOptions.contractTitle,
        "contract_number": cntOptions.contractNumber,
        "date_of_issue": cntOptions.dateOfIssue,
        "expiration_date": cntOptions.expirationDate,
        "option_writer_name": cntOptions.optionWriterName,
        "option_writer_address": cntOptions.optionWriterAddress,
        "option_writer_phone": cntOptions.optionWriterPhone,
        "option_writer_email": cntOptions.optionWriterEmail,
        "option_holder_name": cntOptions.optionHolderName,
        "option_holder_address": cntOptions.optionHolderAddress,
        "option_holder_phone": cntOptions.optionHolderPhone,
        "option_holder_email": cntOptions.optionHolderEmail,
        "commodity_description": cntOptions.commodityDescription,
        "commodity_quality": cntOptions.commodityQuality,
        "commodity_quantity": cntOptions.commodityQuantity,
        "call_option": cntOptions.callOption,
        "put_option": cntOptions.putOption,
        "strike_price": cntOptions.strikePrice,
        "premium": cntOptions.premium,
        "american_style": cntOptions.americanStyle,
        "european_style": cntOptions.europeanStyle,
        "physical_delivery": cntOptions.physicalDelivery,
        "cash_settlement": cntOptions.cashSettlement,
        "delivery_location": cntOptions.deliveryLocation,
        "delivery_start_date": cntOptions.deliveryStartDate,
        "delivery_end_date": cntOptions.deliveryEndDate,
        "settlement_date": cntOptions.settlementDate,
        "reference_price_source": cntOptions.referencePriceSource,
        "notification_method": cntOptions.notificationMethod,
        "notice_period": cntOptions.noticePeriod,
        "jurisdiction": cntOptions.jurisdiction,
        "arbitration": cntOptions.arbitration,
        "arbitration_body": cntOptions.arbitrationBody,
        "arbitration_location": cntOptions.arbitrationLocation,
        "notice_of_default": cntOptions.noticeOfDefault,
        "cure_period": cntOptions.curePeriod,
        "option_writer_sign": cntOptions.optionWriterSign,
        "option_writer_date": cntOptions.optionWriterDate,
        "option_holder_sign": cntOptions.optionHolderSign,
        "option_holder_date": cntOptions.optionHolderDate,
        "additional_terms": cntOptions.additionalTerms,
      };

      forwardsIds = {
        "effective_day": cntForwards.effectiveDay,
        "effective_month": cntForwards.effectiveMonth,
        "effective_year": cntForwards.effectiveYear,
        "seller_name": cntForwards.sellerName,
        "seller_address": cntForwards.sellerAddress,
        "seller_contact": cntForwards.sellerContact,
        "buyer_name": cntForwards.buyerName,
        "buyer_address": cntForwards.buyerAddress,
        "buyer_contact": cntForwards.buyerContact,
        "commodity_type": cntForwards.commodityType,
        "commodity_quality": cntForwards.commodityQuality,
        "commodity_quantity": cntForwards.commodityQuantity,
        "unit_price": cntForwards.unitPrice,
        "total_price": cntForwards.totalPrice,
        "currency": cntForwards.currency,
        "payment_terms": cntForwards.paymentTerms,
        "payment_method": cntForwards.paymentMethod,
        "delivery_date": cntForwards.deliveryDate,
        "delivery_location": cntForwards.deliveryLocation,
        "delivery_method": cntForwards.deliveryMethod,
        "risk_title_transfer": cntForwards.riskTitleTransfer,
        "inspection_rights": cntForwards.inspectionRights,
        "quality_assurance": cntForwards.qualityAssurance,
        "default_events": cntForwards.defaultEvents,
        "remedies": cntForwards.remedies,
        "notice_of_default": cntForwards.noticeOfDefault,
        "cure_period": cntForwards.curePeriod,
        "seller_signature": cntForwards.sellerSignature,
        "seller_signature_name": cntForwards.sellerSignatureName,
        "seller_signature_title": cntForwards.sellerSignatureTitle,
        "buyer_signature": cntForwards.buyerSignature,
        "buyer_signature_name": cntForwards.buyerSignatureName,
        "buyer_signature_title": cntForwards.buyerSignatureTitle,
      };

      futureIds = {
        "details-of-transaction": cntFutures.detailsOfTransaction,
        "commodity": cntFutures.commodity,
        "contract_code": cntFutures.contractCode,
        "seller_details": cntFutures.sellerDetails,
        "buyer_details": cntFutures.buyerDetails,
        "quantity": cntFutures.quantity,
        "quality": cntFutures.quality,
        "delivery_location": cntFutures.deliveryLocation,
        "delivery_date": cntFutures.deliveryDate,
        "price": cntFutures.price,
        "settlement_type": cntFutures.settlementType,
        "settlement_date": cntFutures.settlementDate,
        "initial_margin": cntFutures.initialMargin,
        "maintenance_margin": cntFutures.maintenanceMargin,
        "daily_price_limits": cntFutures.dailyPriceLimits,
        "trading_hours": cntFutures.tradingHours,
        "expiration_date": cntFutures.expirationDate,
        "last_trading_day": cntFutures.lastTradingDay,
        "notice_of_default": cntFutures.noticeOfDefault,
        "cure_period": cntFutures.curePeriod,
        "seller_name": cntFutures.sellerName,
        "seller_title": cntFutures.sellerTitle,
        "seller_date": cntFutures.sellerDate,
        "seller_sign": cntFutures.sellerSign,
        "buyer_name": cntFutures.buyerName,
        "buyer_title": cntFutures.buyerTitle,
        "buyer_date": cntFutures.buyerDate,
        "buyer_sign": cntFutures.buyerSign,
        "witness1_name": cntFutures.witness1Name,
        "witness1_title": cntFutures.witness1Title,
        "witness1_date": cntFutures.witness1Date,
        "witness1_sign": cntFutures.witness1Sign,
        "witness2_name": cntFutures.witness2Name,
        "witness2_title": cntFutures.witness2Title,
        "witness2_date": cntFutures.witness2Date,
        "witness2_sign": cntFutures.witness2Sign,
      };

      swapIds = {
        // Party Details
        "agreement_date": cntSwap.agreementDate,
        "party_a_name": cntSwap.partyAName,
        "party_a_address": cntSwap.partyAAddress,
        "party_a_contact_person": cntSwap.partyAContactPerson,
        "party_a_email": cntSwap.partyAEmail,
        "party_a_phone": cntSwap.partyAPhone,
        "party_b_name": cntSwap.partyBName,
        "party_b_address": cntSwap.partyBAddress,
        "party_b_contact_person": cntSwap.partyBContactPerson,
        "party_b_email": cntSwap.partyBEmail,
        "party_b_phone": cntSwap.partyBPhone,

        // Swap Terms
        "fixed_rate": cntSwap.fixedRate,
        "floating_rate": cntSwap.floatingRate,
        "reference_rate": cntSwap.referenceRate,
        "notional_amount_term": cntSwap.notionalAmountTerm,
        "day_count_convention": cntSwap.dayCountConvention,

        // Payments
        "payment_dates_term": cntSwap.paymentDatesTerm,
        "payment_currency": cntSwap.paymentCurrency,
        "commodities": cntSwap.commodities,
        "swap_rate": cntSwap.swapRate,

        // Dates
        "effective_date_term": cntSwap.effectiveDateTerm,
        "termination_date_term": cntSwap.terminationDateTerm,
        "early_termination_notice": cntSwap.earlyTerminationNotice,

        // Default and Remedies
        "notice_of_default": cntSwap.noticeOfDefault,
        "cure_period": cntSwap.curePeriod,

        // Witness Signatures
        "party_a_signature": cntSwap.partyASignature,
        "party_a_name_in_witness": cntSwap.partyANameInWitness,
        "party_a_title": cntSwap.partyATitle,
        "party_b_signature": cntSwap.partyBSignature,
        "party_b_name_in_witness": cntSwap.partyBNameInWitness,
        "party_b_title": cntSwap.partyBTitle,
      };

      Map<String, dynamic> filledData = {};
      switch (contractTypeId) {
        case 1:
          filledData = futureIds;
          break;
        case 2:
          filledData = forwardsIds;
          break;
        case 3:
          filledData = optionsIds;
          break;
        case 4:
          filledData = swapIds;
          break;

        default:
          filledData = futureIds;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    child: ContractTemplete(
                        contractTypeId: contractTypeId, filledData: filledData),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Close',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      await CommodityService.CreateContract(context, contractData,
          isWeb: false);
      // Show success message or navigate to a new screen
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating contract: $e')),
      );
    }
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    _tabController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}

class DeliveryMilestone {
  final DateTime date;
  final double quantity;
  // final String metric;

  DeliveryMilestone({
    required this.date,
    required this.quantity,
    // required this.metric,
  });
}
