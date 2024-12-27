import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/match.dart';
import '../repositories/matches_repository.dart';

final matchesRepositoryProvider = Provider((ref) => MatchesRepository());

final matchesStreamProvider = StreamProvider<List<Match>>((ref) {
  try {
    final repository = ref.watch(matchesRepositoryProvider);
    return repository.getMatches();
  } catch (e, stack) {
    debugPrint('Error in matches provider: $e\n$stack');
    rethrow;
  }
}); 