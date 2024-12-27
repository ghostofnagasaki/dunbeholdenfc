import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../repositories/players_repository.dart';

final playersRepositoryProvider = Provider((ref) => PlayersRepository());

final playersStreamProvider = StreamProvider<List<Player>>((ref) {
  final repository = ref.watch(playersRepositoryProvider);
  return repository.getPlayers();
}); 