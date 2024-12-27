import 'package:dunbeholden/providers/staff_provider.dart';
import 'package:dunbeholden/screens/staff_screen.dart';
import 'package:dunbeholden/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:dunbeholden/models/staff.dart';

void main() {
  group('StaffScreen', () {
    testWidgets('should display loading state initially',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              staffStreamProvider.overrideWith(
                (_) => Stream.empty(),
              ),
            ],
            child: const MaterialApp(
              home: StaffScreen(),
            ),
          ),
        );

        await tester.pump();
        expect(find.byType(LoadingView), findsOneWidget);
      });
    });

    testWidgets('should display staff grouped by role',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final staffList = [
          Staff(
            id: 'staff1',
            name: 'John Smith',
            role: 'Coach',
            achievements: '',
            biography: '',
            dateJoined: DateTime.now(),
            email: '',
            image: '',
            isActive: true,
            nationality: '',
            phone: '',
            previousExperience: '',
            qualifications: '',
            socialMedia: StaffSocialMedia(instagram: '', linkedin: '', twitter: ''),
            updatedAt: DateTime.now(),
            databaseLocation: '',
          ),
        ];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              staffStreamProvider.overrideWith((_) => Stream.value(staffList)),
            ],
            child: const MaterialApp(
              home: StaffScreen(),
            ),
          ),
        );

        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.text('COACHING STAFF'), findsOneWidget);
        expect(find.text('JOHN SMITH'), findsOneWidget);  // Text is uppercase in UI
      });
    });
  });
} 