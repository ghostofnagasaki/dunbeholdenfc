import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../constants/colors.dart';
import '../constants/styles.dart';
import '../widgets/benefit_item.dart';
import '../screens/membership_onboarding_screen.dart';

class MyDBNScreen extends ConsumerWidget {
  const MyDBNScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'MY DBN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner with Image
            Stack(
              children: [
                Image.asset(
                  'assets/images/shop_banner.jpg',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.primaryBlue.withAlpha(230),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Sign Up Card
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.white.withAlpha(20),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'DUNBEHOLDEN WANT TO SIGN YOU!',
                        style: AppStyles.headingStyle.copyWith(
                          color: Colors.white,
                          fontSize: 32,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Get access to exclusive content, personalise your profile, see your predictions scores & fan stats, plus official stickers!',
                        textAlign: TextAlign.center,
                        style: AppStyles.bodyStyle.copyWith(
                          color: Colors.white.withAlpha(230),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MembershipOnboardingScreen()),
                );
              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'SIGN FOR DUNBEHOLDEN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Benefits Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Member Benefits',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBenefitsGrid(context),
                ],
              ),
            ),
            const SizedBox(height: 32),

          
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsGrid(BuildContext context) {
    final benefits = [
      const BenefitData(
        icon: Icons.star,
        title: 'DAILY EXCLUSIVES',
        description: 'Player training, interviews, club news & more',
      ),
      const BenefitData(
        icon: Icons.sports_soccer,
        title: 'DBN PREDICTIONS',
        description: 'Play, score & win prizes every matchday!',
      ),
      const BenefitData(
        icon: Icons.emoji_events,
        title: 'WIN REWARDS',
        description: 'Exclusive prizes and special offers',
      ),
      const BenefitData(
        icon: Icons.person,
        title: 'PLAYER PROFILE',
        description: 'Customize your fan experience',
      ),
      const BenefitData(
        icon: Icons.chat,
        title: 'FAN COMMUNITY',
        description: 'Connect with other supporters',
      ),
      const BenefitData(
        icon: Icons.notifications,
        title: 'MATCH ALERTS',
        description: 'Never miss a game or update',
      ),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: benefits.map((benefit) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(20),
            borderRadius: BorderRadius.circular(16),
          ),
          child: BenefitItem(
            icon: benefit.icon,
            title: benefit.title,
            description: benefit.description,
            textColor: Colors.white,
            iconColor: Colors.white,
          ),
        );
      }).toList(),
    );
  }
}

class BenefitData {
  final IconData icon;
  final String title;
  final String description;

  const BenefitData({
    required this.icon,
    required this.title,
    required this.description,
  });
}