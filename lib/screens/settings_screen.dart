import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import 'delete_account_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.primaryBlue,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'JOIN THE CLUB',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Become a part of Dunbeholden's global fan community and gain access to exclusive features including Play Predictor, Live Streams and more!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildSettingsItem(context, 'Settings', Icons.settings),
            _buildSettingsItem(context, 'Legal', Icons.gavel),
            _buildSettingsItem(
              context, 
              'Membership Form', 
              Icons.card_membership,
              onTap: _launchURL,
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text(
                'Delete My Data',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeleteAccountScreen(),
                  ),
                );
              },
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIcon(icon: Icons.facebook),
                  SizedBox(width: 20),
                  _SocialIcon(icon: FontAwesomeIcons.twitter),
                  SizedBox(width: 20),
                  _SocialIcon(icon: FontAwesomeIcons.instagram),
                  SizedBox(width: 20),
                  _SocialIcon(icon: FontAwesomeIcons.youtube),
                  SizedBox(width: 20),
                  _SocialIcon(icon: FontAwesomeIcons.tiktok),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.primaryBlue,
        size: 16,
      ),
      onTap: onTap ?? () {
        // Handle navigation to respective settings pages
      },
    );
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSe1j67D5Yw6G8Mfr84NSJbvdkm_e4-H-j_a04JZJfwWl6-7qw/viewform');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;

  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(icon, color: AppColors.primaryBlue, size: 20),
    );
  }
}
