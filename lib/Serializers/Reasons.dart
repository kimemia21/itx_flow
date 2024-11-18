import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Reasons {
  final IconData icon;
  final String title;
  final String subtitle;

  const Reasons({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  factory Reasons.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (kDebugMode) {
        print('Reasons.fromJson: $key: $value');
      }
    });

    // Convert string icon name to IconData
    IconData getIconData(String iconName) {
      switch (iconName) {
        case 'Icons.location_off':
          return Icons.location_off;
        case 'Icons.description':
          return Icons.description;
        case 'Icons.inventory_2':
          return Icons.inventory_2;
        case 'Icons.access_time':
          return Icons.access_time;
        case 'Icons.warning':
          return Icons.warning;
        case 'Icons.more_horiz':
          return Icons.more_horiz;
        default:
          return Icons.error; 
      }
    }

    return Reasons(
      icon: getIconData(json['icon'] as String),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
    );
  }

  // Optional: Add toJson method if you need to serialize back to JSON
  Map<String, dynamic> toJson() {
    return {
      'icon': icon.toString(),
      'title': title,
      'subtitle': subtitle,
    };
  }
}