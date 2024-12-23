import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlayerInfoScreen extends StatelessWidget {
  final String? playerName;
  final String? playerNumber;
  final String? playerPosition;
  final String? playerImage;
  final String? playerCountry;
  final int? appearances;
  final int? goals;
  final int? assists;
  final String? biography;
  final String? nationality;
  final String? placeOfBirth;
  final String? birthday;
  final String? signedDate;
  final String? height;
  final String? weight;
  final List<Map<String, String>>? previousClubs;

  const PlayerInfoScreen({
    super.key,
    this.playerName,
    this.playerNumber,
    this.playerPosition,
    this.playerImage,
    this.playerCountry,
    this.appearances,
    this.goals,
    this.assists,
    this.biography,
    this.nationality,
    this.placeOfBirth,
    this.birthday,
    this.signedDate,
    this.height,
    this.weight,
    this.previousClubs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        title: Text(playerName?.toUpperCase() ?? 'Player Info',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  child: playerImage?.startsWith('http') == true
                      ? CachedNetworkImage(
                          imageUrl: playerImage!,
                          fit: BoxFit.cover,
                          memCacheWidth: 600,
                          memCacheHeight: 800,
                          maxWidthDiskCache: 600,
                          maxHeightDiskCache: 800,
                          fadeInDuration: const Duration(milliseconds: 300),
                          placeholderFadeInDuration: const Duration(milliseconds: 300),
                          placeholder: (context, url) => Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: Image.asset(
                                'assets/images/dunbeholden.png',
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: Image.asset(
                                'assets/images/dunbeholden.png',
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                        )
                      : Image.asset(
                          playerImage ?? 'assets/images/dunbeholden.png',
                          fit: BoxFit.cover,
                          cacheWidth: 600,
                          cacheHeight: 800,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: Image.asset(
                                'assets/images/dunbeholden.png',
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(179),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playerNumber ?? 'N/A',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        playerName?.toUpperCase() ?? 'Player Name',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        playerPosition?.toUpperCase() ?? 'Position',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn(
                      'APPEARANCES', appearances?.toString() ?? 'N/A'),
                  _buildStatColumn('GOALS', goals?.toString() ?? 'N/A'),
                  _buildStatColumn('ASSISTS', assists?.toString() ?? 'N/A'),
                  ElevatedButton(
                    onPressed: () {
                      // Add buy shirt functionality here
                    },
                    child: const Text('BUY MY SHIRT'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('BIOGRAPHY',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(biography ?? 'Biography'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // Add see more functionality here
                    },
                    child: const Text('See more',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NATIONALITY',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(nationality ?? 'Nationality'),
                  const SizedBox(height: 16),
                  const Text('PLACE OF BIRTH',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(placeOfBirth ?? 'Place of Birth'),
                  const SizedBox(height: 16),
                  const Text('BIRTHDAY',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(birthday ?? 'Birthday'),
                  const SizedBox(height: 16),
                  const Text('SIGNED',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(signedDate ?? 'Signed'),
                  const SizedBox(height: 16),
                  const Text('HEIGHT',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(height ?? 'Height'),
                  const SizedBox(height: 16),
                  const Text('WEIGHT',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(weight ?? 'Weight'),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PREVIOUS CLUBS',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  ...previousClubs
                          ?.map((club) => _buildPreviousClubRow(club)) ??
                      [],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Biography',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill),
            label: 'Highlights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Merchandise',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation tap
        },
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildPreviousClubRow(Map<String, String> club) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(club['years'] ?? 'Years',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Image.asset(club['logo'] ?? 'assets/icons/cavalier.png',
                  height: 24),
              const SizedBox(width: 8),
              Text(club['name'] ?? 'Club Name',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Text(club['games'] ?? 'Games',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
