import 'package:flutter/material.dart';
import '../constants/styles.dart';

class StyledText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool isHeading;
  final bool isSubheading;
  final bool isBody;
  final Color? color;

  const StyledText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.isHeading = false,
    this.isSubheading = false,
    this.isBody = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle finalStyle = style ?? const TextStyle();

    if (isHeading) {
      finalStyle = AppStyles.headingStyle;
    } else if (isSubheading) {
      finalStyle = AppStyles.subheadingStyle;
    } else if (isBody) {
      finalStyle = AppStyles.bodyStyle;
    }

    if (color != null) {
      finalStyle = finalStyle.copyWith(color: color);
    }

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
    );
  }

  // Factory constructors for common text styles
  factory StyledText.heading(
    String text, {
    TextAlign? textAlign,
    Color? color,
  }) {
    return StyledText(
      text,
      isHeading: true,
      textAlign: textAlign,
      color: color,
    );
  }

  factory StyledText.subheading(
    String text, {
    TextAlign? textAlign,
    Color? color,
  }) {
    return StyledText(
      text,
      isSubheading: true,
      textAlign: textAlign,
      color: color,
    );
  }

  factory StyledText.body(
    String text, {
    TextAlign? textAlign,
    Color? color,
  }) {
    return StyledText(
      text,
      isBody: true,
      textAlign: textAlign,
      color: color,
    );
  }
} 