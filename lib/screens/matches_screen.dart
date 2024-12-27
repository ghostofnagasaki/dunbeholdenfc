import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/matches_provider.dart';
import '../providers/clubs_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../models/match.dart';
import '../constants/colors.dart';
import 'standings_screen.dart';
import 'players_screen.dart';
import 'staff_screen.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MatchesView();
  }
}

class MatchesView extends ConsumerStatefulWidget {
  const MatchesView({super.key});

  @override
  ConsumerState<MatchesView> createState() => _MatchesViewState();
}

class _MatchesViewState extends ConsumerState<MatchesView> {
  String selectedTab = 'Fixtures';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildNavigationTabs(),
            Expanded(
              child: _getSelectedTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          'MATCHES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  Widget _buildNavigationTabs() {
    return Container(
      color: AppColors.primaryBlue,
      child: Row(
        children: [
          _buildMainTab('Fixtures'),
          _buildMainTab('Results'),
          _buildMainTab('Standings'),
          _buildMainTab('Players'),
          _buildMainTab('Staff'),
        ],
      ),
    );
  }

  Widget _buildMainTab(String text) {
    final isSelected = selectedTab == text;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = text),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.red : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[300],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        month,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildMatchCard({
    required String competition,
    required String date,
    required String time,
    required String homeTeam,
    required String homeTeamShort,
    required String awayTeam,
    required String awayTeamShort,
    required String homeTeamLogo,
    required String awayTeamLogo,
    String? homeScore,
    String? awayScore,
    required bool isFixture,
    required bool isLive,
    bool hasHighlights = false,
    bool hasFullMatch = false,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF161B25),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            width: double.infinity,
            child: Text(
              competition,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamInfo(homeTeam, homeTeamShort, homeTeamLogo),
                _buildMatchInfo(date, time, isFixture, isLive, homeScore, awayScore, status),
                _buildTeamInfo(awayTeam, awayTeamShort, awayTeamLogo),
              ],
            ),
          ),
          if (!isFixture && (hasHighlights || hasFullMatch))
            _buildMediaButtons(hasHighlights, hasFullMatch)
          else
            const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTeamInfo(String team, String shortName, String logo) {
    return Expanded(
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: logo,
            height: 40,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(height: 8),
          Text(
            MediaQuery.of(context).size.width < 360 ? shortName : team,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMatchInfo(String date, String time, bool isFixture, bool isLive, 
      String? homeScore, String? awayScore, String status) {
    return Expanded(
      child: Column(
        children: [
          Text(
            date,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          if (isLive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else if (isFixture)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF161B25),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildScoreBox(homeScore ?? '-'),
                    const SizedBox(width: 8),
                    _buildScoreBox(awayScore ?? '-'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildScoreBox(String score) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        score,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMediaButtons(bool hasHighlights, bool hasFullMatch) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.withAlpha(51)),
        ),
      ),
      child: Row(
        children: [
          if (hasFullMatch)
            Expanded(
              child: _buildMediaButton(
                icon: Icons.play_circle_outline,
                text: 'FULL MATCH',
                onTap: () {},
              ),
            ),
          if (hasFullMatch && hasHighlights)
            Container(
              width: 1,
              height: 40,
              color: Colors.grey.withAlpha(51),
            ),
          if (hasHighlights)
            Expanded(
              child: _buildMediaButton(
                icon: Icons.play_circle_outline,
                text: 'HIGHLIGHTS',
                onTap: () {},
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<Match>> _groupMatchesByMonth(List<Match> matches) {
    final grouped = <String, List<Match>>{};
    for (final match in matches) {
      final month = DateFormat('MMMM').format(match.timestamp).toUpperCase();
      grouped.putIfAbsent(month, () => []).add(match);
    }
    return grouped;
  }

  Widget _getSelectedTabContent() {
    switch (selectedTab) {
      case 'Players':
        return const PlayersScreen();
      case 'Staff':
        return const StaffScreen();
      case 'Fixtures':
        return _buildMatchesList(type: 'fixture');
      case 'Results':
        return _buildMatchesList(type: 'result');
      case 'Standings':
        return const StandingsScreen();
      default:
        return const Center(child: Text('Select a tab'));
    }
  }

  Widget _buildMatchesList({required String type}) {
    final matchesStream = ref.watch(matchesStreamProvider);
    final clubsAsync = ref.watch(clubsProvider);

    return matchesStream.when(
      data: (matches) {
        return clubsAsync.when(
          data: (clubs) {
            final filteredMatches = matches.where((match) {
              return match.type == type;
            }).toList();

            final groupedMatches = _groupMatchesByMonth(filteredMatches);

            if (groupedMatches.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/dunbeholden.png',
                      height: 100,
                      width: 100,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No ${type == "fixture" ? "Upcoming Matches" : "Results"} Available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: groupedMatches.length,
              itemBuilder: (context, index) {
                final month = groupedMatches.keys.elementAt(index);
                final monthMatches = groupedMatches[month]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMonthHeader(month),
                    ...monthMatches.map((match) {
                      final homeClub = clubs[match.homeTeamId];
                      final awayClub = clubs[match.awayTeamId];

                      if (homeClub == null || awayClub == null) {
                        return const SizedBox.shrink();
                      }

                      return _buildMatchCard(
                        competition: match.competition,
                        date: DateFormat('EEE dd MMM')
                            .format(match.timestamp)
                            .toUpperCase(),
                        time: DateFormat('HH:mm')
                            .format(match.timestamp),
                        homeTeam: homeClub.name,
                        homeTeamShort: homeClub.shortName,
                        awayTeam: awayClub.name,
                        awayTeamShort: awayClub.shortName,
                        homeTeamLogo: homeClub.logoUrl,
                        awayTeamLogo: awayClub.logoUrl,
                        homeScore: match.formattedHomeScore,
                        awayScore: match.formattedAwayScore,
                        isFixture: match.type == 'fixture',
                        isLive: match.isLive,
                        hasHighlights: match.hasHighlights,
                        hasFullMatch: match.hasFullMatch,
                        status: match.status,
                      );
                    }),
                  ],
                );
              },
            );
          },
          loading: () => const LoadingView(),
          error: (error, stackTrace) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.refresh(clubsProvider),
          ),
        );
      },
      loading: () => const LoadingView(),
      error: (error, stackTrace) => ErrorView(
        message: error.toString(),
        onRetry: () => ref.refresh(matchesStreamProvider),
      ),
    );
  }
}

