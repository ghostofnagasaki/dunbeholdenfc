import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'players_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Section with Gradient Overlay
            Stack(
              children: [
                // Background Image
                Image.asset(
                  'assets/images/d2.png',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                // Gradient Overlay
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.primaryBlue.withAlpha(128),
                        AppColors.primaryBlue,
                      ],
                    ),
                  ),
                ),
                // Search Bar
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for players, news, or videos',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                // Explore Text
                const Positioned(
                  bottom: 20,
                  left: 16,
                  child: Text(
                    'EXPLORE\nDUNBEHOLDEN',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            // Rest of the content with blue background
            Container(
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Action Buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickActionButton(
                          'Play\nPredictor',
                          Icons.sports_soccer,
                          () {
                            // Navigate to Predictor screen
                            Navigator.pushNamed(context, '/predictor');
                          },
                        ),
                        _buildQuickActionButton(
                          'Memberships',
                          Icons.restaurant,
                          () {
                            // Navigate to Food & Drink screen
                            Navigator.pushNamed(context, '/food-drink');
                          },
                        ),
                        _buildQuickActionButton(
                          'Buy\nTickets',
                          Icons.confirmation_number,
                          () {
                            // Navigate to Tickets screen
                            Navigator.pushNamed(context, '/tickets');
                          },
                        ),
                      ],
                    ),
                  ),

                  // Tickets & Information Section
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'TICKETS &\nINFORMATION',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Ticket Options Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PlayersScreen(),
                              ),
                            );
                          },
                          child: _buildTicketCardWithImage(
                            'Players',
                            'assets/images/d1.png',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/mens-tickets');
                                },
                                child: _buildTicketCardWithImage(
                                  'Men\'s Tickets',
                                  'assets/images/d2.png',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/hospitality');
                                },
                                child: _buildTicketCardWithImage(
                                  'Hospitality',
                                  'assets/images/d3.png',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Links List
                  _buildClickableInfoLink(
                    'Ticket Information',
                    () => Navigator.pushNamed(context, '/ticket-info'),
                  ),
                  // _buildClickableInfoLink(
                  //   'Women\'s Ticket Information',
                  //   () => Navigator.pushNamed(context, '/womens-ticket-info'),
                  // ),
                  _buildClickableInfoLink(
                    'Matchday Guide',
                    () => Navigator.pushNamed(context, '/matchday-guide'),
                  ),

                  // Memberships Section
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'OFFICIAL\nMEMBERSHIPS',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Membership Card
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () {
                        // Launch membership form URL
                        launchUrl(Uri.parse(
                          'https://docs.google.com/forms/d/e/1FAIpQLSe1j67D5Yw6G8Mfr84NSJbvdkm_e4-H-j_a04JZJfwWl6-7qw/viewform'
                        ));
                      },
                      child: _buildMembershipCardWithImage('assets/images/d4.png'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCardWithImage(String title, String imagePath) {
    return Stack(
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withAlpha(179),
              ],
            ),
          ),
        ),
        Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipCardWithImage(String imagePath) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withAlpha(179),
              ],
            ),
          ),
        ),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          child: const Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Memberships',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClickableInfoLink(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white.withAlpha(51)),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(26),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withAlpha(51)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
