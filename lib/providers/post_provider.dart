import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchDetails {
  final String awayScore;
  final String awayTeam;
  final String homeScore;
  final String homeTeam;
  final String kickoffTime;
  final String matchDate;
  final String venue;

  MatchDetails({
    required this.awayScore,
    required this.awayTeam,
    required this.homeScore,
    required this.homeTeam,
    required this.kickoffTime,
    required this.matchDate,
    required this.venue,
  });

  factory MatchDetails.fromMap(Map<String, dynamic> map) {
    return MatchDetails(
      awayScore: map['awayScore'] ?? '',
      awayTeam: map['awayTeam'] ?? '',
      homeScore: map['homeScore'] ?? '',
      homeTeam: map['homeTeam'] ?? '',
      kickoffTime: map['kickoffTime'] ?? '',
      matchDate: map['matchDate'] ?? '',
      venue: map['venue'] ?? '',
    );
  }
}

class Post {
  final String id;
  final String title;
  final String content;
  final String summary;
  final String category;
  final DateTime date;
  final String image;
  final String author;
  final bool featured;
  final MatchDetails? matchDetails;
  final String seoDescription;
  final String slug;
  final String status;
  final List<String> tags;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.category,
    required this.date,
    required this.image,
    required this.author,
    required this.featured,
    this.matchDetails,
    required this.seoDescription,
    required this.slug,
    required this.status,
    required this.tags,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      summary: data['summary'] ?? '',
      category: data['category'] ?? 'News',
      date: (data['date'] as Timestamp).toDate(),
      image: data['image'] ?? '',
      author: data['author'] ?? '',
      featured: data['featured'] ?? false,
      matchDetails: data['matchDetails'] != null 
          ? MatchDetails.fromMap(data['matchDetails'] as Map<String, dynamic>)
          : null,
      seoDescription: data['seoDescription'] ?? '',
      slug: data['slug'] ?? '',
      status: data['status'] ?? 'draft',
      tags: List<String>.from(data['tags'] ?? []),
    );
  }
}

class PostsNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  PostsNotifier() : super(const AsyncValue.loading()) {
    loadPosts();
  }

  Future<void> loadPosts() async {
    try {
      state = const AsyncValue.loading();
      
      final snapshot = await _firestore
          .collection('posts')
          .where('status', isEqualTo: 'published')
          .orderBy('date', descending: true)
          .get();

      final posts = snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
      state = AsyncValue.data(posts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Stream<List<Post>> getPostsStream() {
    return _firestore
        .collection('posts')
        .where('status', isEqualTo: 'published')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList());
  }

  Future<void> refreshPosts() async {
    loadPosts();
  }
}

// Providers
final postsProvider = StateNotifierProvider<PostsNotifier, AsyncValue<List<Post>>>(
  (ref) => PostsNotifier(),
);

final postsStreamProvider = StreamProvider<List<Post>>((ref) {
  return ref.watch(postsProvider.notifier).getPostsStream();
});

final groupedPostsProvider = Provider<Map<String, List<Post>>>((ref) {
  final postsState = ref.watch(postsStreamProvider);
  return postsState.when(
    data: (posts) {
      final grouped = <String, List<Post>>{};
      for (var post in posts) {
        if (!grouped.containsKey(post.category)) {
          grouped[post.category] = [];
        }
        grouped[post.category]!.add(post);
      }
      return grouped;
    },
    loading: () => {},
    error: (_, __) => {},
  );
}); 