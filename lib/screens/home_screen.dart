import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/post_provider.dart';
import '../constants/colors.dart';
import '../services/performance_monitor.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'settings_screen.dart';
import '../widgets/optimized_card.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final DateTime Function()? getCurrentTime;

  const HomeScreen({
    super.key,
    this.getCurrentTime,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _formatDate(DateTime date) {
    final now = widget.getCurrentTime?.call() ?? DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM').format(date);
    }
  }

  void _preloadImages(List<Post> posts) {
    // Limit preloading to first few posts
    final limitedPosts = posts.take(5).toList();
    for (final post in limitedPosts) {
      if (post.image.isNotEmpty) {
        precacheImage(
          CachedNetworkImageProvider(
            post.image,
            maxHeight: 800, // Limit image size
            maxWidth: 800,
          ),
          context,
        );
      }
    }
  }

  @override
  void dispose() {
    // Clear memory when leaving the screen
    imageCache.clear();
    imageCache.clearLiveImages();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Defer non-critical operations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }

  void _initializeScreen() {
    ref.read(postsStreamProvider.stream).first.then((posts) {
      if (mounted) {
        _preloadImages(posts);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(postsStreamProvider, (previous, next) {
      next.whenData((posts) => _preloadImages(posts));
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        title: Image.asset(
          'assets/icons/dunbeholden.png',
          height: 40,
          fit: BoxFit.contain,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => PerformanceMonitor.trackOperation(
          'refresh_news_feed',
          () => ref.refresh(postsStreamProvider.future),
        ),
        color: AppColors.primaryBlue,
        child: _buildNewsFeed(),
      ),
    );
  }

  Widget _buildNewsFeed() {
    return Consumer(
      builder: (context, ref, _) {
        return ref.watch(postsStreamProvider).when(
          data: (posts) {
            if (posts.isEmpty) {
              return _buildEmptyState();
            }

            final announcements = posts.where((post) => 
              post.category.toLowerCase() == 'announcement').toList();
            final otherPosts = posts.where((post) => 
              post.category.toLowerCase() != 'announcement').toList();

            // Combine all posts into a single list
            final allPosts = [...announcements, ...otherPosts];

            return ListView.builder(
              itemCount: allPosts.length,
              cacheExtent: 1000,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              itemBuilder: (context, index) {
                final post = allPosts[index];
                return RepaintBoundary(
                  child: index < announcements.length
                    ? _buildAnnouncementCard(context, post)
                    : OptimizedCard(
                        child: _buildRegularPostCard(context, post),
                      ),
                );
              },
            );
          },
          loading: () => const LoadingView(),
          error: (error, stack) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.refresh(postsStreamProvider),
          ),
        );
      },
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, Post post) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/news-detail',
        arguments: post.id,
      ),
      child: Container(
        height: 500,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(26),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (post.image.isNotEmpty)
              CachedNetworkImage(
                imageUrl: post.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 48,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(77),
                    Colors.black.withAlpha(128),
                    const Color(0xFF1E3A8A).withAlpha(179),
                    const Color(0xFF1E3A8A).withAlpha(242),
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.campaign_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Men's Team",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '• ${_formatDate(post.date)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularPostCard(BuildContext context, Post post) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/news-detail',
        arguments: post.id,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(26),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.image.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: post.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  memCacheWidth: 800,
                  fadeInDuration: const Duration(milliseconds: 300),
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Colors.grey[100],
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 48,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Colors.grey[100],
                    child: Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Men's Team • ${_formatDate(post.date)}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.summary,
                    style: TextStyle(color: Colors.grey[800]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                ),
              ),
          ],
      ),
    )
  );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('No posts available'),
    );
  }
}
