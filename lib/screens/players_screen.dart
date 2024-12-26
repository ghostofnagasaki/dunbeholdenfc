import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import '../widgets/player_card.dart';
import 'player_info_screen.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: 'Players'),
              Tab(text: 'Staff'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPlayersTab(),
            _buildStaffTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersTab() {
    // Temporary mock data
    final players = [
      {
        'name': 'John Doe',
        'jerseyNumber': '10',
        'position': 'Forward',
        'profileImage': 'assets/images/default_player.png',
      },
      {
        'name': 'James Smith',
        'jerseyNumber': '7',
        'position': 'Midfielder',
        'profileImage': 'assets/images/default_player.png',
      },
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'FORWARDS',
              style: AppStyles.subheadingStyle,
            ),
          ),
          _buildPlayerGrid(players),
        ],
      ),
    );
  }

  Widget _buildStaffTab() {
    // Temporary mock data
    final staff = [
      {
        'name': 'Coach Smith',
        'role': 'Head Coach',
        'imagePath': 'assets/images/default_player.png',
      },
      {
        'name': 'Dr. Johnson',
        'role': 'Team Doctor',
        'imagePath': 'assets/images/default_player.png',
      },
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStaffSection('COACHING STAFF', staff),
        ],
      ),
    );
  }

  Widget _buildPlayerGrid(List<Map<String, dynamic>> players) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75,
        ),
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return PlayerCard(
            imagePath: player['profileImage'],
            number: player['jerseyNumber'],
            name: player['name'],
            onTap: () => _navigateToPlayerInfo(player),
          );
        },
      ),
    );
  }

  Widget _buildStaffSection(String title, List<Map<String, dynamic>> staffMembers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: AppStyles.subheadingStyle,
          ),
        ),
        _buildStaffGrid(staffMembers),
      ],
    );
  }

  Widget _buildStaffGrid(List<Map<String, dynamic>> staffMembers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75,
        ),
        itemCount: staffMembers.length,
        itemBuilder: (context, index) {
          final staff = staffMembers[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.asset(
                    staff['imagePath'],
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        staff['role'],
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToPlayerInfo(Map<String, dynamic> player) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerInfoScreen(
          playerNumber: player['jerseyNumber'],
          playerName: player['name'],
          playerPosition: player['position'],
          playerImage: player['profileImage'],
        ),
      ),
    );
  }
}