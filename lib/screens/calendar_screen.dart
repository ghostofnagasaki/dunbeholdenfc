import 'package:flutter/material.dart';

import '../constants.dart/colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedGender = 'Mens';
  String selectedSeason = '2024-25';
  String selectedCompetition = 'All competitions';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        title: const Text('Fixtures', style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.5),
          labelColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(text: 'FIXTURES'),
            Tab(text: 'RESULTS'),
            Tab(text: 'TABLES'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFixturesTab(),
          _buildResultsTab(),
          _buildTablesTab(),
        ],
      ),
    );
  }

  Widget _buildFixturesTab() {
    return Column(
      children: [
        _buildDropdowns(),
        Expanded(
          child: ListView(
            children: [
              _buildNextMatchCard(),
              _buildMatchCard('PREMIER LEAGUE', 'TUE 17 SEPTEMBER',
                  'Dunbeholden', '14:00', 'Dunbeholden F.C'),
              _buildMatchCard('PREMIER LEAGUE', 'SAT 21 SEPTEMBER',
                  'Dunbeholden F.C', '09:00', 'Tivoli Gardens F.C.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsTab() {
    return Column(
      children: [
        _buildDropdowns(),
        Expanded(
          child: ListView(
            children: [
              _buildResultsSection('SEPTEMBER 2024', [
                _buildResultCard(
                    'PREMIER LEAGUE',
                    'SUN 1 SEPTEMBER — 10:00',
                    'Dunbeholden F.C',
                    '0',
                    '3',
                    'Waterhouse F.C',
                    'assets/icons/dunbeholden.png',
                    'assets/icons/waterhouse.png'),
              ]),
              _buildResultsSection('AUGUST 2024', [
                _buildResultCard(
                    'PREMIER LEAGUE',
                    'SUN 25 AUGUST — 10:30',
                    'Cavalier F.C',
                    '2',
                    '0',
                    'Dunbeholden F.C',
                    'assets/icons/cavalier.png',
                    'assets/icons/dunbeholden.png'),
                _buildResultCard(
                    'PREMIER LEAGUE',
                    'SAT 17 AUGUST — 06:30',
                    'Dunbeholden F.C',
                    '0',
                    '2',
                    'Humble Lions F.C',
                    'assets/icons/dunbeholden.png',
                    'assets/icons/humble.png'),
                _buildResultCard(
                    'FRIENDLY',
                    'SUN 11 AUGUST — 11:00',
                    'Harbour View F.C',
                    '0',
                    '0',
                    'Dunbeholden F.C',
                    'assets/icons/dunbeholden.png',
                    'assets/icons/hvfc.png'),
                _buildResultCard(
                    'FRIENDLY',
                    'SUN 11 AUGUST — 06:30',
                    'Dunbeholden F.C',
                    '4',
                    '1',
                    'Lime Hall Community F.C',
                    'assets/icons/dunbeholden.png',
                    'assets/icons/lhcc.png'),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTablesTab() {
    return Column(
      children: [
        _buildDropdowns(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PREMIER LEAGUE 2024-25',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  backgroundColor: Colors.black,
                ),
              ),
              Image.asset('assets/icons/premier_league_logo.png', height: 40),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _buildTableHeader(),
              _buildTableRow(1, 'DUN', 'assets/icons/dunbeholden.png', 3, 3, 0,
                  0, '+7', 9),
              _buildTableRow(
                  2, 'CAV', 'assets/icons/cavalier.png', 3, 3, 0, 0, '+7', 9),
              _buildTableRow(
                  3, 'HUM', 'assets/icons/humble.png', 3, 2, 1, 0, '+4', 7),
              _buildTableRow(
                  4, 'LIM', 'assets/icons/lhcc.png', 3, 2, 1, 0, '+4', 7),
              _buildTableRow(
                  5, 'MOL', 'assets/icons/molynes.png', 3, 2, 1, 0, '+2', 7),
              _buildTableRow(
                  6, 'WAT', 'assets/icons/waterhouse.png', 3, 2, 0, 1, '+1', 6),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdowns() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                  items: <String>['Mens', 'Womens']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: selectedSeason,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSeason = newValue!;
                    });
                  },
                  items: <String>['2024-25', '2023-24', '2022-23']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          DropdownButton<String>(
            value: selectedCompetition,
            onChanged: (String? newValue) {
              setState(() {
                selectedCompetition = newValue!;
              });
            },
            items: <String>[
              'All competitions',
              'Premier League',
              'Champions League'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNextMatchCard() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('NEXT MATCH', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PREMIER LEAGUE',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('SAT 14 SEPTEMBER — 09:00'),
                  ],
                ),
                Image.asset('assets/icons/premier_league_logo.png', height: 40),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dunbeholden F.C',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Tivoli Gardens F.C'),
                  ],
                ),
                Column(
                  children: [
                    _CountdownTimer(label: 'DAYS', value: '1'),
                    _CountdownTimer(label: 'HRS', value: '2'),
                    _CountdownTimer(label: 'MIN', value: '1'),
                    _CountdownTimer(label: 'SEC', value: '58'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(String competition, String date, String team1,
      String time, String team2) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(competition, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(date),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(team1,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(time),
                Text(team2,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection(String month, List<Widget> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(month,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        ...results,
      ],
    );
  }

  Widget _buildResultCard(String competition, String date, String team1,
      String score1, String score2, String team2, String logo1, String logo2) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(competition, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(date),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(logo1, height: 24),
                    const SizedBox(width: 8),
                    Text(team1,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Text(score1,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(score2,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Text(team2,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Image.asset(logo2, height: 24),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('POS',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text('CLUB',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text('PL',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text('W',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text('D',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text('L',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text('GD',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text('PTS',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTableRow(int position, String club, String logo, int played,
      int won, int drawn, int lost, String goalDifference, int points) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(position.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Image.asset(logo, height: 24),
              const SizedBox(width: 8),
              Text(club, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Text(played.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(won.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(drawn.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(lost.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(goalDifference,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(points.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _CountdownTimer extends StatelessWidget {
  final String label;
  final String value;

  const _CountdownTimer({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }
}
