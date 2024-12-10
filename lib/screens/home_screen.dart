import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import
// import '../widgets/video_post_widget.dart';
import 'calendar_screen.dart';
import 'news_detail_screen.dart';

import '../constants.dart/colors.dart';
import 'players_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat(
        'EEEE d MMMM'); // This will format the date as "Tuesday 8 October"
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CalendarScreen()));
          },
          icon: const Icon(Icons.calendar_today, color: Colors.white),
        ),
        centerTitle: true,
        title: const Text('News', style: TextStyle(color: Colors.white)),
        actions: [
          // const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 10),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PlayersScreen()));
              },
              icon: const Icon(Icons.people, color: Colors.white)),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "WHAT'S NEW",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              getCurrentDate(), // Use the getCurrentDate function here
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          const NewsPostWidget(
            imageUrl: 'assets/images/3-3.png',
            title:
                'Big Balla Chevoy Watkin pulls us back level! From 2-0 down to 3-3—resilience and heart on full display. ❤️💙',
            content:
                'Three of our players will now not be joining up with their countries during the break.',
            timeAgo: '1 day ago',
          ),
          // Add more NewsPostWidget items here
          const NewsPostWidget(
            imageUrl: 'assets/images/charity-match.jpg',
            title: 'Dunbeholden FC and NCB Foundation team up for a Christmas treat for elders',
            content:
                '''With a little help from NCB Foundation, the Dunbeholden Football Club in St Catherine has secured \$100,000 to grant a wish for elders in their community this Christmas. The Grant A Wish donation will fund an annual Christmas treat for seniors in the community – an annual undertaking by the Dunbeholden Football Club in partnership with the Star Church of God in Dunbeholden.

"Football is bigger than the matches we play – it's about the connections we create and the lives we touch off the field," said Roger Simmonds, Dunbeholden FC manager. "Working with NCB Foundation's Grant A Wish initiative is an incredible opportunity because it allows us to extend the spirit of teamwork beyond our players and fans to the community at large."

He added, "Sports, like football, have the power to change lives, and today, we've proven that by securing the funding to make the season a little brighter for our elders in the community."''',
            timeAgo: '1h',
          ),
          const SizedBox(height: 16),
          // You can continue adding more NewsPostWidget items as needed
        ],
      ),
    );
  }
}

class NewsPostWidget extends StatelessWidget {
  final String title;
  final String content;
  final String imageUrl;
  final String timeAgo;

  const NewsPostWidget({
    super.key,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.timeAgo,
  });

  String _getPreviewContent(String fullContent) {
    // Split content into lines and take first three
    final lines = fullContent.split('\n').take(1).join('\n');
    // If content is longer than preview, add ellipsis
    return lines + (fullContent.split('\n').length > 1 ? '...' : '');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(
              imageUrl: imageUrl,
              title: title,
              content: content,
              timeAgo: timeAgo,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Men's Team • $timeAgo",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getPreviewContent(content),
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  if (content.split('\n').length > 3)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Read More',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
