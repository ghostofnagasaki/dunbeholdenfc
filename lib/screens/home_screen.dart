import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/post_provider.dart';
import '../constants.dart/colors.dart';
import '../widgets/loading_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final DateTime Function() getCurrentTime;

  const HomeScreen({
    super.key,
    this.getCurrentTime = DateTime.now,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  String _formatDate(DateTime date) {
    final now = widget.getCurrentTime();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        
        centerTitle: true,
        title: const Text('News', style: TextStyle(color: Colors.white)),
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
      body: _buildNewsFeed(),
    );
  }

  Widget _buildNewsFeed() {
    final postsState = ref.watch(postsStreamProvider);

    return postsState.when(
      data: (posts) {
        if (posts.isEmpty) {
          return _buildEmptyState();
        }

        final announcements = posts.where((post) => 
          post.category.toLowerCase() == 'announcement').toList();
        final otherPosts = posts.where((post) => 
          post.category.toLowerCase() != 'announcement').toList();

        return ListView(
          children: [
           
           
            if (announcements.isNotEmpty)
              _buildAnnouncementCard(announcements.first),
            ...otherPosts.map((post) => _buildRegularPostCard(post)),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildAnnouncementCard(Post post) {
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

  Widget _buildRegularPostCard(Post post) {
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
            if (post.image.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: post.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('No posts available'),
    );
  }
}
