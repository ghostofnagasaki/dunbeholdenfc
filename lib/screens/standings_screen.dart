import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/standings_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class StandingsScreen extends ConsumerWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(standingsStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFEEEEEE),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Row(
              children: [
                SizedBox(width: 32, child: Text('POS')),
                SizedBox(width: 12),
                Expanded(child: Text('CLUB')),
                SizedBox(width: 35, child: Text('PTS')),
                SizedBox(width: 35, child: Text('P')),
                SizedBox(width: 35, child: Text('W')),
                SizedBox(width: 35, child: Text('D')),
                SizedBox(width: 35, child: Text('L')),
                SizedBox(width: 35, child: Text('+/-')),
              ],
            ),
          ),
          Expanded(
            child: standingsAsync.when(
              data: (standings) => ListView.builder(
                itemCount: standings.length,
                itemBuilder: (context, index) {
                  final standing = standings[index];
                  final isChampionsLeague = index < 2;
                  final isEuropaLeague = index == 2;
                  final isRelegation = index >= standings.length - 3;

                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withAlpha(51),
                        ),
                        top: index == 0
                            ? BorderSide(
                                color: Colors.grey.withAlpha(51),
                              )
                            : BorderSide.none,
                      ),
                      color: Colors.white,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 4,
                            color: isChampionsLeague
                                ? Colors.blue
                                : isEuropaLeague
                                    ? const Color(0xFFFF9900)
                                    : isRelegation
                                        ? Colors.red
                                        : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 32,
                              child: Text(
                                standing.data()['stats']['position'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: standing.data()['teamLogo'],
                                    width: 24,
                                    height: 24,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _getShortTeamName(standing.data()['teamName']),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 35,
                              child: Text(
                                standing.data()['stats']['points'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 35,
                              child: Text(standing.data()['stats']['played'].toString()),
                            ),
                            SizedBox(
                              width: 35,
                              child: Text(standing.data()['stats']['won'].toString()),
                            ),
                            SizedBox(
                              width: 35,
                              child: Text(standing.data()['stats']['drawn'].toString()),
                            ),
                            SizedBox(
                              width: 35,
                              child: Text(standing.data()['stats']['lost'].toString()),
                            ),
                            SizedBox(
                              width: 35,
                              child: Text(
                                (standing.data()['stats']['goalDifference'] >= 0 ? '+' : '') +
                                    standing.data()['stats']['goalDifference'].toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              loading: () => const LoadingView(),
              error: (error, stack) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.refresh(standingsStreamProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getShortTeamName(String fullName) {
    // First try to get first 3 letters of first word
    final firstWord = fullName.split(' ').first;
    if (firstWord.length >= 3) {
      return firstWord.substring(0, 3).toUpperCase();
    }
    
    // If first word is too short, use first letters of each word
    final words = fullName.split(' ');
    if (words.length >= 2) {
      String abbr = '';
      for (var word in words) {
        if (word.isNotEmpty) {
          abbr += word[0];
        }
        if (abbr.length >= 3) break;
      }
      return abbr.toUpperCase();
    }
    
    // Fallback to full name if can't abbreviate
    return fullName.toUpperCase();
  }
} 