import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import 'membership_form_screen.dart';

class MembershipOnboardingScreen extends StatelessWidget {
  const MembershipOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Membership Benefits',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const Text(
                'Join the Dunbeholden FC Family!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Become a member and enjoy exclusive benefits while supporting your favorite team.',
                style: AppStyles.bodyStyle.copyWith(
                  color: Colors.white.withAlpha(230),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),

              // Benefits List
              _buildBenefitSection(
                icon: Icons.star,
                title: 'Match Day Experience',
                details: [
                  'Priority access to match tickets',
                  'Exclusive match day events',
                  'Special seating areas',
                  'Meet and greet opportunities',
                ],
              ),
              const SizedBox(height: 24),

              _buildBenefitSection(
                icon: Icons.card_membership,
                title: 'Member Exclusives',
                details: [
                  'Official membership card',
                  'Birthday recognition',
                  'Member-only merchandise',
                  'Digital newsletter subscription',
                ],
              ),
              const SizedBox(height: 24),

              _buildBenefitSection(
                icon: Icons.discount,
                title: 'Special Discounts',
                details: [
                  '10% off at club shop',
                  'Partner establishment discounts',
                  'Season ticket priority',
                  'Special event discounts',
                ],
              ),
              const SizedBox(height: 24),

              _buildBenefitSection(
                icon: Icons.groups,
                title: 'Community Access',
                details: [
                  'Private WhatsApp group',
                  'Exclusive content access',
                  'Vote on club decisions',
                  'Member-only events',
                ],
              ),
              const SizedBox(height: 32),

              // Price Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Membership Fee',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$5,000 JMD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'per season',
                      style: TextStyle(
                        color: Colors.white.withAlpha(179),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MembershipFormScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'JOIN NOW',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitSection({
    required IconData icon,
    required String title,
    required List<String> details,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...details.map((detail) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white.withAlpha(179),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      detail,
                      style: TextStyle(
                        color: Colors.white.withAlpha(230),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
} 