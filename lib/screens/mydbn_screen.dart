import 'package:flutter/material.dart';
import '../constants.dart/colors.dart';

class MyDBNScreen extends StatelessWidget {
  const MyDBNScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          'MyDBN',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('MyDBN Coming Soon'),
      ),
    );
  }
} 