import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/club.dart';
import '../repositories/clubs_repository.dart';

final clubsRepositoryProvider = Provider((ref) => ClubsRepository());

final clubsProvider = FutureProvider<Map<String, Club>>((ref) async {
  try {
    final repository = ref.watch(clubsRepositoryProvider);
    return await repository.getClubs();
  } catch (e, stack) {
    debugPrint('Error in clubs provider: $e\n$stack');
    rethrow;
  }
}); 