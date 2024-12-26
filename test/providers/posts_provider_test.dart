import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:dunbeholden/providers/post_provider.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ProviderContainer container;

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();
    
    // Add some test data
    await fakeFirestore.collection('posts').add({
      'title': 'Test Post 1',
      'content': 'Test Content 1',
      'summary': 'Test Summary 1',
      'category': 'News',
      'date': DateTime.now(),
      'status': 'published',
    });

    await fakeFirestore.collection('posts').add({
      'title': 'Test Post 2',
      'content': 'Test Content 2',
      'summary': 'Test Summary 2',
      'category': 'Announcement',
      'date': DateTime.now(),
      'status': 'published',
    });

    container = ProviderContainer(
      overrides: [
        // Override the Firestore instance
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('should load posts from Firestore', () async {
    final snapshot = await fakeFirestore
        .collection('posts')
        .where('status', isEqualTo: 'published')
        .get();

    expect(snapshot.docs.length, 2);
    
    final posts = snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    expect(posts.length, 2);
    expect(posts[0].title, 'Test Post 1');
    expect(posts[1].title, 'Test Post 2');
  });

  test('should filter posts by category', () async {
    final snapshot = await fakeFirestore
        .collection('posts')
        .where('category', isEqualTo: 'Announcement')
        .get();

    final posts = snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    expect(posts.length, 1);
    expect(posts[0].category, 'Announcement');
  });
} 