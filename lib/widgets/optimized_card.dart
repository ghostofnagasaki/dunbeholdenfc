import 'package:flutter/material.dart';

class OptimizedCard extends StatelessWidget {
  final Widget child;
  
  const OptimizedCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: child,
    );
  }
} 