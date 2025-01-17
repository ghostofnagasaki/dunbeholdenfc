import 'dart:ui';
import 'package:flutter/material.dart';

class ShaderWarmer {
  static Future<void> warmupShaders() async {
    // Pre-warm common UI effects
    await _warmGradients();
    await _warmBlurs();
    await _warmShadows();
    await _warmAnimations();
  }

  static Future<void> _warmGradients() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Warm up common gradients
    final gradients = [
      const LinearGradient(
        colors: [Colors.blue, Colors.white],
      ),
      LinearGradient(
        begin: Alignment.center,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withAlpha(77),
          Colors.black.withAlpha(128),
        ],
      ),
    ];

    for (final gradient in gradients) {
      final paint = Paint()
        ..shader = gradient.createShader(const Rect.fromLTWH(0, 0, 100, 100));
      canvas.drawRect(const Rect.fromLTWH(0, 0, 100, 100), paint);
    }
    
    await recorder.endRecording().toImage(1, 1);
  }

  static Future<void> _warmBlurs() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    
    final blurs = [5.0, 10.0, 20.0];
    for (final sigma in blurs) {
      final paint = Paint()
        ..imageFilter = ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);
      canvas.drawRect(const Rect.fromLTWH(0, 0, 100, 100), paint);
    }
    
    await recorder.endRecording().toImage(1, 1);
  }

  static Future<void> _warmShadows() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    
    canvas.drawShadow(
      Path()..addRect(const Rect.fromLTWH(0, 0, 100, 100)),
      Colors.black,
      4.0,
      true,
    );
    
    await recorder.endRecording().toImage(1, 1);
  }

  static Future<void> _warmAnimations() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Warm up common animations
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
      
    canvas.drawCircle(const Offset(50, 50), 25, paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 100, 100),
        const Radius.circular(8),
      ),
      paint,
    );
    
    await recorder.endRecording().toImage(1, 1);
  }
} 