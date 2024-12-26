import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunbeholden/providers/post_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<DocumentSnapshot>(as: #GeneratedMockDocumentSnapshot)])
import 'post_test.mocks.dart';

void main() {
  group('Post Model Tests', () {
    test('should create Post from Firestore data', () {
      // Arrange
      final mockDoc = GeneratedMockDocumentSnapshot();
      final data = {
        'title': 'Test Post',
        'content': 'Test Content',
        'summary': 'Test Summary',
        'category': 'News',
        'date': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'image': 'https://example.com/image.jpg',
        'author': 'Test Author',
        'featured': true,
        'seoDescription': 'Test SEO',
        'slug': 'test-post',
        'status': 'published',
        'tags': ['tag1', 'tag2'],
      };

      when(mockDoc.data()).thenReturn(data);
      when(mockDoc.id).thenReturn('test-id');

      // Act
      final post = Post.fromFirestore(mockDoc);

      // Assert
      expect(post.id, 'test-id');
      expect(post.title, 'Test Post');
      expect(post.content, 'Test Content');
      expect(post.summary, 'Test Summary');
      expect(post.category, 'News');
      expect(post.date, DateTime(2024, 1, 1));
      expect(post.image, 'https://example.com/image.jpg');
      expect(post.author, 'Test Author');
      expect(post.featured, true);
      expect(post.seoDescription, 'Test SEO');
      expect(post.slug, 'test-post');
      expect(post.status, 'published');
      expect(post.tags, ['tag1', 'tag2']);
    });

    test('should handle missing or null data', () {
      // Arrange
      final mockDoc = GeneratedMockDocumentSnapshot();
      final data = <String, dynamic>{};

      when(mockDoc.data()).thenReturn(data);
      when(mockDoc.id).thenReturn('test-id');

      // Act
      final post = Post.fromFirestore(mockDoc);

      // Assert
      expect(post.id, 'test-id');
      expect(post.title, '');
      expect(post.content, '');
      expect(post.summary, '');
      expect(post.category, 'News');
      expect(post.image, '');
      expect(post.author, '');
      expect(post.featured, false);
      expect(post.seoDescription, '');
      expect(post.slug, '');
      expect(post.status, 'draft');
      expect(post.tags, isEmpty);
    });
  });
} 