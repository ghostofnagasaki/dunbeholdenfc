 import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final String? imageUrl;
  final double height;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    this.imageUrl,
    this.height = 200,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      fit: StackFit.expand,
      children: [
        if (imageUrl != null)
          Image.asset(
            imageUrl!,
            fit: BoxFit.cover,
          ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withAlpha(179),
                Colors.transparent,
              ],
            ),
          ),
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ],
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              child: SizedBox(
                height: height,
                child: content,
              ),
            )
          : SizedBox(
              height: height,
              child: content,
            ),
    );
  }
}