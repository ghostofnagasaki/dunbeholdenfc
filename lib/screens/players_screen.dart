import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../providers/players_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import 'player_info_screen.dart';

class PlayerCard extends StatelessWidget {
  final Player player;

  const PlayerCard({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerInfoScreen(player: player),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161B25),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: player.profileImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            'assets/icons/dunbeholden.png',
                            color: Colors.grey[700],
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/icons/dunbeholden.png',
                            color: Colors.grey[700],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withAlpha(153),
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withAlpha(153),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Text(
                      player.jerseyNumber,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Text(
                      player.position,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                player.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayersScreen extends ConsumerWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(playersStreamProvider);

    return playersAsync.when(
      data: (players) {
        // Group players by position
        final goalkeepers = players.where((p) => p.position == 'Goalkeeper').toList();
        final defenders = players.where((p) => p.position == 'Defender').toList();
        final midfielders = players.where((p) => p.position == 'Midfielder').toList();
        final forwards = players.where((p) => p.position == 'Forward').toList();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (goalkeepers.isNotEmpty) ...[
                  const Text(
                    'GOALKEEPERS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPlayerGrid(goalkeepers),
                  const SizedBox(height: 24),
                ],
                if (defenders.isNotEmpty) ...[
                  const Text(
                    'DEFENDERS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPlayerGrid(defenders),
                  const SizedBox(height: 24),
                ],
                if (midfielders.isNotEmpty) ...[
                  const Text(
                    'MIDFIELDERS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPlayerGrid(midfielders),
                  const SizedBox(height: 24),
                ],
                if (forwards.isNotEmpty) ...[
                  const Text(
                    'FORWARDS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPlayerGrid(forwards),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingView(),
      error: (error, stack) => ErrorView(
        message: error.toString(),
        onRetry: () => ref.refresh(playersStreamProvider),
      ),
    );
  }

  Widget _buildPlayerGrid(List<Player> players) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return PlayerCard(
          player: player,
        );
      },
    );
  }
}