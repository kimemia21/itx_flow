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
                    CommodityDropdown(
                      isForAppBar: false,
                      onCommoditySelected: (commodity) {
                        setState(() {
                          selectedCommodityId = int.parse(commodity.toString());
                          print(selectedCommodityId);
                        });
                      },
                    ),
                    if (selectedCommodityId != null) ...[
                      SizedBox(height: 16),
                      Visibility(
                        visible: context.watch<appBloc>().commId != 0,
                        child: GradeDropdown(
                          onGradeSelectedId: (onGradeSelected) {
                            setState(() {
                              selectedQuality = onGradeSelected;
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
                      onWarehouseSelected: (WareHouseId) {
                        setState(() {
                          selectedWareHouseId = WareHouseId;
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

    print('Form submitted');
    params.forEach((param) {
      print('${param.name}: ${controllers[param.id]?.text}');
    });
    print('Delivery Milestones:');
    deliveryMilestones.forEach((milestone) {
      print(
          'Date: ${DateFormat('yyyy-MM-dd').format(milestone.date)}, Quantity: ${milestone.quantity}');
    });

    Map<int, int> tabToContractTypeId = {
      0: 1, // Futures
      1: 2, // Forwards
      2: 3, // Options
      3: 4, // Swaps
      4: 5, // Spot
    };
    int contractTypeId = tabToContractTypeId[_tabController.index] ?? 1;

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
    print("-------------------------------------");
    print(contractData);

    print("-------------------------------------");

    try {
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
