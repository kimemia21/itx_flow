import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Commodities.dart/ComDropDown.dart';
import 'package:itx/Commodities.dart/Grade.dart';
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
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  List<String> qualities = ['Quality 1', 'Quality 2', 'Quality 3'];
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
        backgroundColor: Colors.white,
        title: Text('Create Contract',
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.bold)),
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
            CommodityDropdown(onCommoditySelected: (commodity) {
              setState(() {
                selectedCommodityId = int.parse(commodity.toString());
                _fetchParams();
              });
            }),
            if (selectedCommodityId != null) ...[
              SizedBox(
                height: 10,
              ),
              GradeDropdown(onGradeSelected: (onGradeSelected) {
                setState(() {
                  selectedQuality = onGradeSelected;
                });
              }),
              SizedBox(
                height: 10,
              ),
              buildTextField(
                controller: priceController,
                title: 'Enter Price',
                icon: Icons.attach_money,
              ),
              buildTextField(
                controller: descriptionController,
                title: 'Description',
                maxLines: 4,
              ),
              ...params.map((param) => _buildParamField(param)),
            ],
            SizedBox(height: 20),
            buildDeliveryMilestoneWidget(),
            SizedBox(height: 16),

            Column(
              children: deliveryMilestones
                  .map((milestone) => ListTile(
                        title: Text(
                            'Date: ${DateFormat('yyyy-MM-dd').format(milestone.date)}'),
                        subtitle: Text('Quantity: ${milestone.quantity}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              deliveryMilestones.remove(milestone);
                            });
                          },
                        ),
                      ))
                  .toList(),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
            SizedBox(height: 100), // Add extra space at the bottom
          ],
        ),
      );
    }
  }

  Widget _buildParamField(CommParams param) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controllers[param.id],
        decoration: InputDecoration(
          labelText: param.name,
          hintText: 'Enter ${param.name}',
          border: OutlineInputBorder(),
        ),
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
                      : 'Select date',
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

  Widget buildTextField({
    required TextEditingController controller,
    required String title,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.poppins(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: icon != null ? Icon(icon, color: Colors.green) : null,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildDeliveryMilestoneWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add Delivery Milestone',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: buildDatePicker(
                title: 'Delivery Date',
                selectedDate: selectedDate,
                onDateSelected: (date) => setState(() => selectedDate = date),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: buildTextField(
                controller: quantityController,
                title: 'Quantity',
                icon: Icons.production_quantity_limits,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addDeliveryMilestone,
          child: Text('Add Milestone'),
        ),
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
      "price": price,
      "units": units,
      "description": descriptionController.text,
      "milestones": deliveryMilestones
          .map((milestone) => {
                "date": DateFormat('yyyy-MM-dd').format(milestone.date),
                "metric": "units",
                "value": milestone.quantity
              })
          .toList(),
    };

    CommodityService.CreateContract(context,contractData);

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

  DeliveryMilestone({required this.date, required this.quantity});
}
