import 'package:dunbeholden/repositories/matches_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dunbeholden/providers/matches_provider.dart';
import 'package:dunbeholden/models/match.dart';
import 'matches_provider_test.mocks.dart';

@GenerateMocks([MatchesRepository])
void main() {
  group('MatchesProvider', () {
    late ProviderContainer container;
    late MockMatchesRepository mockRepository;

    setUp(() {
      mockRepository = MockMatchesRepository();
      container = ProviderContainer(
        overrides: [
          matchesRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should emit matches from repository', () async {
      final matches = [
        Match(
          id: 'match1',
          competition: 'Premier League',
          homeTeamId: 'team1',
          awayTeamId: 'team2',
          timestamp: DateTime(2024, 3, 20, 15, 30),
          status: 'Scheduled',
          type: 'fixture',
          isLive: false,
          hasHighlights: false,
          hasFullMatch: false,
          homeScore: null,
          awayScore: null,
        ),
      ];

      when(mockRepository.getMatches())
          .thenAnswer((_) => Stream.value(matches));

      // Wait for the first value to be emitted
      final result = await container.read(matchesStreamProvider.future);
      
      expect(result, matches);
      verify(mockRepository.getMatches()).called(1);
    });
  });
} 