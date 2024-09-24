class CommParams {
  final int id;
  final int commodityId;
  final String name;
  final String category;
  final String classField; // 'class' is a reserved keyword in Dart, so it's renamed
  final double? maxVal;
  final int multiple;
  final int orderValue;
  final int decimals;
  final String inputDataType;
  final String filterDataType;

  CommParams({
    required this.id,
    required this.commodityId,
    required this.name,
    required this.category,
    required this.classField,
    this.maxVal,
    required this.multiple,
    required this.orderValue,
    required this.decimals,
    required this.inputDataType,
    required this.filterDataType,
  });

  // Factory constructor to create a CommParams instance from a JSON map
  factory CommParams.fromJson(Map<String, dynamic> json) {
    return CommParams(
      id: json['id'],
      commodityId: json['commodity_id'],
      name: json['name'],
      category: json['category'],
      classField: json['class'], // Handling the 'class' field by renaming
      maxVal: json['max_val'] != null ? json['max_val'].toDouble() : null,
      multiple: json['multiple'],
      orderValue: json['order_value'],
      decimals: json['decimals'],
      inputDataType: json['input_data_type'],
      filterDataType: json['filter_data_type'],
    );
  }
}
