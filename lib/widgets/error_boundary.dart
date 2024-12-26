import 'package:flutter/material.dart';

class ErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget Function(Object error)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return child;
    } catch (error) {
      return errorBuilder?.call(error) ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/dunbeholden.png',
                  width: 100,
                  height: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
    }
  }
} 