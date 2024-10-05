import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Commodities.dart/ComDropDown.dart';
import 'package:itx/Commodities.dart/Grade.dart';
import 'package:itx/Contracts/CreateContract/CustomDropDown.dart';
import 'package:itx/Contracts/CreateContract/WareHouseDropDown.dart';
import 'package:itx/Serializers/CommParams.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/requests/HomepageRequest.dart';
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
  int selectedCommodityId = 1;
  String? selectedQuality;
  DateTime? selectedDate;
  String? selectedMetric;
  int? selectedWareHouseId;
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final metricController = TextEditingController();

  late TabController _tabController;
  List<DeliveryMilestone> deliveryMilestones = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _fetchParams();
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
                    'Add Contract info',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10,),
                  CommodityDropdown(
                    onCommoditySelected: (commodity) {
                      setState(() {
                        selectedCommodityId = int.parse(commodity.toString());
                      });
                    },
                  ),
                  if (selectedCommodityId != null) ...[
                    SizedBox(height: 16),
                    GradeDropdown(
                      onGradeSelected: (onGradeSelected) {
                        setState(() {
                          selectedQuality = onGradeSelected;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    buildTextField(
                      controller: priceController,
                      title: 'Enter Price',
                      icon: Icons.attach_money,
                      isTextField: false,
                    ),
                    SizedBox(height: 16),
                    buildTextField(
                      controller: descriptionController,
                      title: 'Description',
                      icon: Icons.description,
                      maxLines: 4,
                      isTextField: true,
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
                            Text(
                              'Metric: ${milestone.metric}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
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
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color
                // onPrimary: Colors.white, // Text color
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),

            SizedBox(height: 100), // Add extra space at the bottom
          ],
        ),
      );
    }
  }

  Widget _buildParamField(CommParams param) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: TextField(
        controller: controllers[param.id],
        decoration: InputDecoration(
          labelText: param.name,
          hintText: 'Enter ${param.name}',
          labelStyle: TextStyle(
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14.0,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blueGrey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
        ),
        style: TextStyle(fontSize: 16.0, color: Colors.black87),
        keyboardType: param.inputDataType == 'number'
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
      ),
    );
  }

  Widget buildDropdownButton({
    required String title,
    required String? value,
    required List items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items
              .map((item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)))
              .toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          style: GoogleFonts.poppins(),
        ),
        SizedBox(height: 16),
      ],
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

  Widget buildTextField(
      {required TextEditingController controller,
      required String title,
      int maxLines = 1,
      IconData? icon,
      required isTextField}) {
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
                fontSize: screenWidth * 0.04, // Responsive font size
              ),
            ),
            SizedBox(height: 8),
            TextField(
              keyboardType:
                  isTextField ? TextInputType.name : TextInputType.phone,
              controller: controller,
              maxLines: maxLines,
              inputFormatters: isTextField
                  ? []
                  : [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Restrict input to digits

              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04, // Responsive text field font size
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
                        size: screenWidth * 0.06, // Responsive icon size
                      )
                    : null,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03, // Responsive padding
                  vertical: 12,
                ),
              ),
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
          SizedBox(height: 16),
          buildTextField(
            controller: quantityController,
            title: 'Quantity',
            icon: Icons.production_quantity_limits,
            isTextField: false,
          ),
          SizedBox(height: 16),
          MetricDropDown(
            onSelectMetric: (metric) {
              setState(() {
                selectedMetric = metric;
              });
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addDeliveryMilestone,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Button color
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              elevation: 5, // Button shadow
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

  void _addDeliveryMilestone() {
    if (selectedDate != null && quantityController.text.isNotEmpty) {
      setState(() {
        deliveryMilestones.add(DeliveryMilestone(
          metric: selectedMetric!,
          date: selectedDate!,
          quantity: double.parse(quantityController.text),
        ));
        selectedDate = null;
        quantityController.clear();
      });
    }
  }

  void _submitForm() async {
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

    // Parse the price and units
    double price = double.tryParse(priceController.text) ?? 0.0;
    double units = 0.0;
    for (var param in params) {
      if (param.name.toLowerCase() == 'units' ||
          param.name.toLowerCase() == 'quantity') {
        units = double.tryParse(controllers[param.id]?.text ?? '') ?? 0.0;
        break;
      }
    }

    // Get the delivery start and end dates
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

    // Create the map
    Map<String, dynamic> contractData = {
      "contract_type_id": contractTypeId,
      "commodity_id": selectedCommodityId,
      "quality_grade_id": int.tryParse(selectedQuality ?? '') ?? 1,
      "delivery_start_date": deliveryStartDate?.toIso8601String() ?? "",
      "delivery_end_date": deliveryEndDate?.toIso8601String() ?? "",
      "warehouse_id": selectedWareHouseId,
      "price": price,
      "units": units,
      "description": descriptionController.text,
      "milestones": deliveryMilestones
          .map((milestone) => {
                "date": DateFormat('yyyy-MM-dd').format(milestone.date),
                "metric": milestone.metric,
                "value": milestone.quantity
              })
          .toList(),
      "params": [
        {"param_id": 1, "param_value": 100}
      ]
    };
    print(" createContract-------------${contractData}-----");

    CommodityService.CreateContract(context, contractData);

    // Print the map (you can replace this with sending to an API or other operations)
    print(contractData);
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
  final String metric;

  DeliveryMilestone(
      {required this.date, required this.quantity, required this.metric});
}
