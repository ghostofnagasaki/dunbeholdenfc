import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class PlayerCard extends StatelessWidget {
  final String imagePath;
  final String number;
  final String name;
  final VoidCallback onTap;

  const PlayerCard({
    super.key,
    required this.imagePath,
    required this.number,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = imagePath.startsWith('http');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: isNetworkImage
                    ? CachedNetworkImage(
                        imageUrl: imagePath,
                        fit: BoxFit.cover,
                        memCacheWidth: 300,
                        memCacheHeight: 400,
                        maxWidthDiskCache: 300,
                        maxHeightDiskCache: 400,
                        fadeInDuration: const Duration(milliseconds: 300),
                        placeholderFadeInDuration: const Duration(milliseconds: 300),
                        placeholder: (context, url) => Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: Image.asset(
                              'assets/images/dunbeholden.png',
                              width: 50,
                              height: 50,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: Image.asset(
                              'assets/images/dunbeholden.png',
                              width: 50,
                              height: 50,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        cacheWidth: 300,
                        cacheHeight: 400,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: Image.asset(
                              'assets/images/dunbeholden.png',
                              width: 50,
                              height: 50,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    number,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}