import 'dart:async';
import 'package:firebase_performance/firebase_performance.dart';

class PerformanceService {
  static PerformanceService? _instance;
  final FirebasePerformance _performance;

  PerformanceService._(this._performance);

  static PerformanceService get instance {
    return _instance ??= PerformanceService._(FirebasePerformance.instance);
  }

  // For testing
  static void setInstance(FirebasePerformance performance) {
    _instance = PerformanceService._(performance);
  }

  FirebasePerformance get performance => _performance;
}

class PerformanceMonitor {
  static FirebasePerformance get _performance => PerformanceService.instance.performance;

  static Future<T> trackOperation<T>(String name, Future<T> Function() operation) async {
    final Trace trace = _performance.newTrace(name);
    await trace.start();
    
    try {
      final result = await operation();
      return result;
    } finally {
      await trace.stop();
    }
  }

  static Stream<T> trackStream<T>(String name, Stream<T> stream) {
    final Trace trace = _performance.newTrace(name);
    trace.start();
    
    return stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data);
        },
        handleDone: (sink) {
          trace.stop();
          sink.close();
        },
        handleError: (error, stackTrace, sink) {
          trace.stop();
          sink.addError(error, stackTrace);
        },
      ),
    );
  }

  static Future<T> trackNetworkRequest<T>(String url, Future<T> Function() request) async {
    final metric = _performance.newHttpMetric(url, HttpMethod.Get);
    await metric.start();
    
    try {
      final result = await request();
      return result;
    } finally {
      await metric.stop();
    }
  }
} 