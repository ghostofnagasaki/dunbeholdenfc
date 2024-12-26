import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../constants.dart/colors.dart';
import '../providers/post_provider.dart';

class NewsDetailScreen extends ConsumerWidget {
  final String postId;

  const NewsDetailScreen({
    super.key,
    required this.postId,
  });

  String _formatDate(DateTime date) {
    return DateFormat('EEE dd MMM yyyy, HH:mm').format(date);
  }

  String _parseHtmlString(String htmlString) {
    // Remove <p> tags
    var text = htmlString.replaceAll(RegExp(r'<p>|</p>'), '');
    // Remove other common HTML tags if needed
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');
    // Replace HTML entities
    text = text.replaceAll('&nbsp;', ' ')
              .replaceAll('&amp;', '&')
              .replaceAll('&quot;', '"')
              .replaceAll('&apos;', "'")
              .replaceAll('&lt;', '<')
              .replaceAll('&gt;', '>');
    return text;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(postsStreamProvider);

    return postsState.when(
      data: (posts) {
        try {
          final post = posts.firstWhere((p) => p.id == postId);
          final parsedContent = _parseHtmlString(post.content);
          
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.image.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: post.image,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[100],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[100],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "MEN'S TEAM",
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          post.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: post.author.isNotEmpty
                                  ? NetworkImage(post.author)
                                  : null,
                              child: post.author.isEmpty
                                  ? const Icon(Icons.person, color: Colors.grey)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'by ${post.author}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _formatDate(post.date),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          parsedContent,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } catch (e) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: const Center(
              child: Text('Post not found'),
            ),
          );
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
