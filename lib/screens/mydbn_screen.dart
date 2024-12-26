import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import '../constants/styles.dart';
import '../widgets/benefit_item.dart';

class MyDBNScreen extends ConsumerWidget {
  const MyDBNScreen({super.key});

  void _navigateToLogin(BuildContext context) async {
    final Uri url = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSe1j67D5Yw6G8Mfr84NSJbvdkm_e4-H-j_a04JZJfwWl6-7qw/viewform');
    if (!await launchUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch form. Please try again later.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        title: const Text(
          'MY DBN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              // Handle settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSignUpCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'DUNBEHOLDEN WANT TO SIGN YOU!',
            style: AppStyles.headingStyle.copyWith(
              color: Colors.white,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Get access to exclusive content, personalise your profile, see your predictions scores & fan stats, plus official stickers!',
            textAlign: TextAlign.center,
            style: AppStyles.bodyStyle.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => _navigateToLogin(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'SIGN FOR DUNBEHOLDEN',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildBenefitsGrid(context),
        ],
      ),
    );
  }

  Widget _buildBenefitsGrid(BuildContext context) {
    final benefits = [
      BenefitData(
        icon: Icons.star,
        title: 'DAILY EXCLUSIVES',
        description: 'Player training, interviews, club news & more',
      ),
      BenefitData(
        icon: Icons.sports_soccer,
        title: 'DBN PREDICTIONS',
        description: 'Play, score & win prizes every matchday!',
      ),
      BenefitData(
        icon: Icons.emoji_events,
        title: 'WIN REWARDS',
        description: 'Exclusive prizes and special offers',
      ),
      BenefitData(
        icon: Icons.person,
        title: 'PLAYER PROFILE',
        description: 'Customize your fan experience',
      ),
      BenefitData(
        icon: Icons.chat,
        title: 'FAN COMMUNITY',
        description: 'Connect with other supporters',
      ),
      BenefitData(
        icon: Icons.notifications,
        title: 'MATCH ALERTS',
        description: 'Never miss a game or update',
      ),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: benefits.map((benefit) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
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