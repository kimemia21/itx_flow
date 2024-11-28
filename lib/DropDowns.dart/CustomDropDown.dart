// import 'package:flutter/material.dart';

// class MetricDropDown extends StatefulWidget {
//   final Function(String) onSelectMetric;

//   const MetricDropDown({super.key, required this.onSelectMetric});

//   @override
//   _MetricDropDownState createState() => _MetricDropDownState();
// }

// class _MetricDropDownState extends State<MetricDropDown> {
//   String? selectedUnit; // Initially no unit selected

//   // List of dropdown items
//   final List<String> units = ['unit', 'band', 'sacks'];

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Container(
//       width: MediaQuery.of(context).size.width * .6,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Select Metric',
//             style: TextStyle(
//               fontSize: screenWidth * 0.04, // Responsive font size
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 8),
//           DropdownButtonFormField<String>(
//             value: selectedUnit,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: screenWidth * 0.03, // Responsive padding
//                 vertical: 12,
//               ),
//             ),
//             hint: Text(
//               'Choose a unit',
//               style: TextStyle(
//                   fontSize: screenWidth * 0.04), // Responsive hint text
//             ),
//             items: units.map((unit) {
//               return DropdownMenuItem(
//                 value: unit,
//                 child: Text(
//                   unit,
//                   style: TextStyle(
//                       fontSize: screenWidth * 0.04), // Responsive text size
//                 ),
//               );
//             }).toList(),
//             onChanged: (newValue) {
//               setState(() {
//                 selectedUnit = newValue;
//                 widget.onSelectMetric(selectedUnit!);
//               });
//             },
//           ),
//           SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
// }
