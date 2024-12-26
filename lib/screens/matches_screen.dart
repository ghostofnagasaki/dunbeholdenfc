// import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// import '../constants/colors.dart';
// import '../screens/players_screen.dart';



// class MatchesScreen extends StatefulWidget {
//   const MatchesScreen({super.key});

//   @override
//   State<MatchesScreen> createState() => _MatchesScreenState();
// }

// class _MatchesScreenState extends State<MatchesScreen> {
//   String selectedTab = 'Fixtures';
//   // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Map<String, Map<String, dynamic>> _clubsCache = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadClubs();
//   }

//   // Future<void> _loadClubs() async {
//   //   final clubsSnapshot = await _firestore.collection('clubs').where('isActive', isEqualTo: true).get();
//   //   setState(() {
//   //     _clubsCache = {
//   //       for (var doc in clubsSnapshot.docs)
//   //         doc.id: doc.data()..addAll({'id': doc.id})
//   //     };
//   //   });
//   // }

//   // Stream<QuerySnapshot> _getMatchesStream() {
//   //   return _firestore
//   //       .collection('matches')
//   //       .orderBy('timestamp', descending: true)
//   //       .snapshots();
//   // }

//   Widget _getSelectedTabContent() {
//     switch (selectedTab) {
//       case 'Squad':
//         return const PlayersScreen();
//       case 'Fixtures':
//         return _buildMatchesList(type: 'fixture');
//       case 'Results':
//         return _buildMatchesList(type: 'result');
//       case 'Standings':
//         return const Center(child: Text('Standings Coming Soon'));
//       default:
//         return const Center(child: Text('Select a tab'));
//     }
//   }

//   Widget _buildMatchesList({required String type}) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _getMatchesStream(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         final matches = snapshot.data!.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .where((match) {
//               // For results, show matches that are not fixtures and have scores
//               if (type == 'result') {
//                 return match['type'] == 'result' || 
//                        (match['homeScore'] != null && match['awayScore'] != null);
//               }
//               // For fixtures, only show upcoming matches
//               return match['type'] == 'fixture' && !match['isLive'];
//             })
//             .toList();

//         // Sort matches by timestamp
//         matches.sort((a, b) {
//           final aTime = DateTime.parse(a['timestamp']);
//           final bTime = DateTime.parse(b['timestamp']);
//           return type == 'result' ? bTime.compareTo(aTime) : aTime.compareTo(bTime);
//         });

//         if (matches.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/icons/dunbeholden.png',
//                   height: 100,
//                   width: 100,
//                   color: Colors.grey[400],
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   'No ${type == 'fixture' ? 'Upcoming Matches' : 'Results'} Available',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         return ListView.builder(
//           itemCount: matches.length,
//           itemBuilder: (context, index) {
//             final match = matches[index];
//             final homeClub = _clubsCache[match['homeTeamId']];
//             final awayClub = _clubsCache[match['awayTeamId']];

//             if (homeClub == null || awayClub == null) {
//               return const SizedBox.shrink();
//             }

//             // Print score values for debugging
//             print('Match scores - Home: ${match['homeScore']}, Away: ${match['awayScore']}');

//             return _buildResultCard(
//               competition: match['competition'] ?? '',
//               date: match['date'] ?? '',
//               time: match['time'] ?? '',
//               homeTeam: homeClub['name'] ?? '',
//               awayTeam: awayClub['name'] ?? '',
//               homeTeamLogo: homeClub['logoUrl'] ?? '',
//               awayTeamLogo: awayClub['logoUrl'] ?? '',
//               homeScore: match['homeScore']?.toString() ?? '-',
//               awayScore: match['awayScore']?.toString() ?? '-',
//               hasHighlights: match['hasHighlights'] ?? false,
//               hasFullMatch: match['hasFullMatch'] ?? false,
//               isFixture: type == 'fixture',
//               isLive: match['isLive'] ?? false,
//               status: match['status'] ?? '',
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryBlue,
//         elevation: 0,
//         title: const Row(
//           children: [
//             Text(
//               'Matches',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
          
//           ],
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48),
//           child: Container(
//             color: AppColors.primaryBlue,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildTab('Fixtures'),
//                 _buildTab('Results'),
//                 _buildTab('Standings'),
//                 _buildTab('Squad'),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: _getSelectedTabContent(),
//     );
//   }

//   Widget _buildTab(String text) {
//     final isSelected = selectedTab == text;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedTab = text;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(
//               color: isSelected ? Colors.white : Colors.transparent,
//               width: 2,
//             ),
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.grey,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildResultCard({
//     required String competition,
//     required String date,
//     required String time,
//     required String homeTeam,
//     required String awayTeam,
//     required String homeTeamLogo,
//     required String awayTeamLogo,
//     required String homeScore,
//     required String awayScore,
//     bool hasHighlights = false,
//     bool hasFullMatch = false,
//     bool isFixture = false,
//     bool isLive = false,
//     String status = '',
//   }) {
//     // Print values for debugging
//     print('Building card - Home Score: $homeScore, Away Score: $awayScore, isFixture: $isFixture');

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             decoration: const BoxDecoration(
//               color: Color(0xFF161B25),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 topRight: Radius.circular(8),
//               ),
//             ),
//             child: Text(
//               competition,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     children: [
//                       CachedNetworkImage(
//                         imageUrl: homeTeamLogo,
//                         height: 50,
//                         placeholder: (context, url) => const CircularProgressIndicator(),
//                         errorWidget: (context, url, error) => const Icon(Icons.error),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         homeTeam,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text(
//                         date,
//                         style: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 13,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       if (isLive)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: const Text(
//                             'LIVE',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         )
//                       else if (isFixture)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF161B25),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           time,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         )
//                       else
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                             Container(
//                             width: 40,
//                             height: 40,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Text(
//                               homeScore,
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Container(
//                             width: 40,
//                               height: 40,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Text(
//                               awayScore,
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       if (!isFixture)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8),
//                           child: Text(
//                             status.isNotEmpty ? status : 'FINAL',
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       CachedNetworkImage(
//                         imageUrl: awayTeamLogo,
//                         height: 50,
//                         placeholder: (context, url) => const CircularProgressIndicator(),
//                         errorWidget: (context, url, error) => const Icon(Icons.error),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         awayTeam,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (!isFixture && (hasHighlights || hasFullMatch))
//           Container(
//             decoration: const BoxDecoration(
//               border: Border(
//                 top: BorderSide(color: Colors.grey, width: 0.2),
//               ),
//             ),
//             child: Row(
//               children: [
//                   if (hasFullMatch)
//                 Expanded(
//                   child: InkWell(
//                         onTap: () {
//                       // Handle full match tap
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.all(12),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.play_circle_outline, 
//                             color: Colors.grey, size: 20),
//                           SizedBox(width: 8),
//                           Text(
//                             'FULL MATCH',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                   if (hasFullMatch && hasHighlights)
//                 Container(
//                   width: 1,
//                   height: 40,
//                   color: Colors.grey.withOpacity(0.2),
//                 ),
//                   if (hasHighlights)
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       // Handle highlights tap
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.all(12),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.play_circle_outline, 
//                             color: Colors.grey, size: 20),
//                           SizedBox(width: 8),
//                           Text(
//                             'HIGHLIGHTS',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (isFixture && !isLive)
//             Container(
//               decoration: const BoxDecoration(
//                 border: Border(
//                   top: BorderSide(color: Colors.grey, width: 0.2),
//                 ),
//               ),
//               child: InkWell(
//                 onTap: () {
//                   // Handle ticketing info tap
//                 },
//                 child: const Padding(
//                   padding: EdgeInsets.all(12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.confirmation_number_outlined,
//                           color: Colors.grey, size: 18),
//                       SizedBox(width: 8),
//                       Text(
//                         'VIEW TICKETING INFO',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(width: 4),
//                       Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

