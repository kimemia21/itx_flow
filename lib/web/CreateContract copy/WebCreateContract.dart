import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Commodities.dart/ComDropDown.dart';
import 'package:itx/web/CreateContract%20copy/Grade.dart';
import 'package:itx/web/CreateContract%20copy/PackingDropDown.dart';
import 'package:itx/web/CreateContract%20copy/WareHouseDropDown.dart';

class WebCreateContract extends StatefulWidget {
  @override
  _WebCreateContractState createState() => _WebCreateContractState();
}

class _WebCreateContractState extends State<WebCreateContract>
    with TickerProviderStateMixin {
  int selectedCommodityId = 0;
  String? selectedQuality;
  DateTime? selectedDate;
  int? selectedWareHouseId;
  String? _packingMetrics;
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  String selectedTabName = 'Futures';

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
  }

  String getTabName(int index) {
    List<String> tabNames = ['Futures', 'Forwards', 'Options', 'Swaps', 'Spot'];
    return tabNames[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildContractInfo(),
                  SizedBox(height: 16),
                  _buildDeliveryMilestoneWidget(),
                  SizedBox(height: 16),
                  _buildDeliveryMilestonesList(),
                  SizedBox(height: 20),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContractInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add $selectedTabName Contract info',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            CommodityDropdown(
              onCommoditySelected: (commodity) {
                setState(() {
                  selectedCommodityId = int.parse(commodity.toString());
                });
              },
            ),
            SizedBox(height: 16),
            if (selectedCommodityId != 0) ...[
              WebGradeDropdown(
                onGradeSelectedId: (onGradeSelected) {
                  setState(() {
                    selectedQuality = onGradeSelected;
                  });
                },
              ),
              SizedBox(height: 16),
              WebPackingDropdown(
                onPackingSelected: (packingId, packingName) {
                  setState(() {
                    _packingMetrics = packingName;
                  });
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: priceController,
                title: 'Enter Price',
                icon: Icons.attach_money,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: descriptionController,
                title: 'Description',
                icon: Icons.description,
                maxLines: 4,
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
            SizedBox(height: 16),
            WebWarehouseSearchDropdown(
              onWarehouseSelected: (WareHouseId) {
                setState(() {
                  selectedWareHouseId = WareHouseId;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryMilestoneWidget() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Delivery Milestone',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            _buildDatePicker(
              title: 'Delivery Date',
              selectedDate: selectedDate,
              onDateSelected: (date) => setState(() => selectedDate = date),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: quantityController,
              title: 'Quantity',
              icon: Icons.production_quantity_limits,
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addDeliveryMilestone,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5.0,
              ),
              child: Text(
                'Add Delivery Milestone',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _onSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5.0,
      ),
      child: Text(
        'Submit Contract',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

Widget _buildTextField({
  required TextEditingController controller,
  required String title,
  required IconData icon,
  String? hint,
  int maxLines = 1,
  required FormFieldValidator<String> validator,
}) {
  // Get the screen width to determine the text size
  double screenWidth = MediaQuery.of(context).size.width;
  double fontSize = screenWidth < 600 ? 12 : 14; // Smaller font for narrow screens

  return TextFormField(
    controller: controller,
    maxLines: maxLines,
    keyboardType: TextInputType.text,
    validator: validator,
    style: TextStyle(fontSize: fontSize), // Responsive text size
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      labelText: title,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );
}


  Widget _buildDatePicker({
    required String title,
    required DateTime? selectedDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context, selectedDate, onDateSelected),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? DateFormat.yMMMd().format(selectedDate)
                      : 'Select Date',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                Icon(Icons.calendar_today, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime? initialDate,
    ValueChanged<DateTime> onDateSelected,
  ) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (selected != null) {
      onDateSelected(selected);
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Submit the contract
      print('Contract submitted');
    }
  }

  void _addDeliveryMilestone() {
    if (selectedDate != null && quantityController.text.isNotEmpty) {
      setState(() {
        deliveryMilestones.add(DeliveryMilestone(
          deliveryDate: selectedDate!,
          quantity: double.parse(quantityController.text),
        ));
        quantityController.clear();
        selectedDate = null;
      });
    }
  }

  Widget _buildDeliveryMilestonesList() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Milestones',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (deliveryMilestones.isEmpty)
              Center(child: Text('No delivery milestones added yet.')),
            for (var milestone in deliveryMilestones)
              ListTile(
                title: Text(
                  'Delivery on ${DateFormat.yMMMd().format(milestone.deliveryDate)}',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                subtitle: Text(
                  'Quantity: ${milestone.quantity}',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DeliveryMilestone {
  final DateTime deliveryDate;
  final double quantity;

  DeliveryMilestone({required this.deliveryDate, required this.quantity});
}