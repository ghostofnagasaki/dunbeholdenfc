import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> _data;
  final String _id;

  MockQueryDocumentSnapshot(this._data, this._id);

  @override
  Map<String, dynamic> data() => _data;

  @override
  String get id => _id;

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  DocumentReference<Map<String, dynamic>> get reference => throw UnimplementedError();
}

// ignore: subtype_of_sealed_class
class MockStandingDocumentSnapshot extends MockQueryDocumentSnapshot {
  MockStandingDocumentSnapshot({
    required String teamName,
    required String teamLogo,
    required int position,
    required int points,
    required int played,
    required int won,
    required int drawn,
    required int lost,
    required int goalDifference,
  }) : super(
          {
            'teamName': teamName,
            'teamLogo': teamLogo,
            'stats': {
              'position': position,
              'points': points,
              'played': played,
              'won': won,
              'drawn': drawn,
              'lost': lost,
              'goalDifference': goalDifference,
            },
          },
          'standing_$teamName',
        );
} 