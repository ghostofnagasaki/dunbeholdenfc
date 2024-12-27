import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunbeholden/repositories/matches_repository.dart';

import '../helpers/mocks.dart';
import 'matches_repository_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  Query<Map<String, dynamic>>,
  QuerySnapshot<Map<String, dynamic>>,
])
void main() {
  group('MatchesRepository', () {
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
    late MockQuery<Map<String, dynamic>> mockQuery;
    late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
    late MatchesRepository repository;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
      mockQuery = MockQuery<Map<String, dynamic>>();
      mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      repository = MatchesRepository(firestore: mockFirestore);

      when(mockFirestore.collection('matches'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.orderBy('timestamp'))
          .thenReturn(mockQuery);
    });

    test('getMatches should return stream of matches', () async {
      final timestamp = Timestamp.fromDate(DateTime(2024, 3, 20, 15, 30));
      final mockDoc = {
        'competition': 'Premier League',
        'homeTeamId': 'team1',
        'awayTeamId': 'team2',
        'timestamp': timestamp,
        'status': 'Scheduled',
        'type': 'fixture',
      };

      when(mockQuery.snapshots()).thenAnswer((_) =>
          Stream.value(mockQuerySnapshot));
      when(mockQuerySnapshot.docs).thenReturn([
        MockQueryDocumentSnapshot(mockDoc, 'match_id'),
      ]);

      final stream = repository.getMatches();
      final matches = await stream.first;

      expect(matches.length, 1);
      expect(matches.first.id, 'match_id');
      expect(matches.first.competition, 'Premier League');
    });
  });
} 