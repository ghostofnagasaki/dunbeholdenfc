import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dunbeholden/services/performance_monitor.dart';

import 'performance_monitor_test.mocks.dart';

// Setup mock Firebase Performance
class MockFirebaseApp extends Mock {
  static final instance = MockFirebaseApp._();
  MockFirebaseApp._();
}

@GenerateMocks([FirebasePerformance, Trace, HttpMetric])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PerformanceMonitor', () {
    late MockFirebasePerformance mockPerformance;
    late MockTrace mockTrace;
    late MockHttpMetric mockMetric;

    setUp(() {
      mockPerformance = MockFirebasePerformance();
      mockTrace = MockTrace();
      mockMetric = MockHttpMetric();

      PerformanceService.setInstance(mockPerformance);

      when(mockPerformance.newTrace(any)).thenReturn(mockTrace);
      when(mockPerformance.newHttpMetric(any, any)).thenReturn(mockMetric);
      when(mockTrace.start()).thenAnswer((_) => Future.value());
      when(mockTrace.stop()).thenAnswer((_) => Future.value());
      when(mockMetric.start()).thenAnswer((_) => Future.value());
      when(mockMetric.stop()).thenAnswer((_) => Future.value());
    });

    test('trackOperation starts and stops trace', () async {
      final result = await PerformanceMonitor.trackOperation(
        'test_operation',
        () async => 'result',
      );

      verify(mockTrace.start()).called(1);
      verify(mockTrace.stop()).called(1);
      expect(result, equals('result'));
    });

    test('trackStream transforms stream correctly', () async {
      final stream = Stream.fromIterable([1, 2, 3]);
      final trackedStream = PerformanceMonitor.trackStream('test_stream', stream);

      final results = await trackedStream.toList();
      
      verify(mockTrace.start()).called(1);
      verify(mockTrace.stop()).called(1);
      expect(results, equals([1, 2, 3]));
    });

    test('trackNetworkRequest measures network calls', () async {
      final result = await PerformanceMonitor.trackNetworkRequest(
        'https://test.com',
        () async => 'response',
      );

      verify(mockMetric.start()).called(1);
      verify(mockMetric.stop()).called(1);
      expect(result, equals('response'));
    });
  });
} 