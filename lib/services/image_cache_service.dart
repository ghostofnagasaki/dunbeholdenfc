import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class ImageCacheService {
  static final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(hours: 12),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: 'dunbeholden_cache'),
      fileService: HttpFileService(),
    ),
  );

  static Future<void> preCacheImages(List<String> imageUrls) async {
    final limitedUrls = imageUrls.take(3).toList();
    for (final url in limitedUrls) {
      try {
        await customCacheManager.downloadFile(url);
      } catch (e) {
        // Ignore cache errors
      }
    }
  }

  static Future<void> clearCache() async {
    await customCacheManager.emptyCache();
    imageCache?.clear();
    imageCache?.clearLiveImages();
  }
} 