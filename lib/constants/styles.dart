import 'package:flutter/material.dart';
import 'colors.dart';

class AppStyles {
  static const TextStyle headingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryBlue,
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
  );

  static ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    minimumSize: const Size(double.infinity, 50),
    side: const BorderSide(color: AppColors.primaryBlue),
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withAlpha(77),
        spreadRadius: 1,
        blurRadius: 3,
        offset: const Offset(0, 1),
      ),
    ],
  );
}