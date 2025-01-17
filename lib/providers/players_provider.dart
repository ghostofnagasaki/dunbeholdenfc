import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../repositories/players_repository.dart';
import '../services/performance_monitor.dart';

final playersRepositoryProvider = Provider((ref) => PlayersRepository());

final playersStreamProvider = StreamProvider<List<Player>>((ref) {
  final repository = ref.watch(playersRepositoryProvider);
  final stream = repository.getPlayers();
  
  return PerformanceMonitor.trackStream(
    'fetch_players',
    stream,
  );
}); 