import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:permission_handler/permission_handler.dart';

import '../constants/colors.dart';
import 'delete_account_screen.dart';
import '../services/notification_service.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            // Account Section
            _buildSection(
              'Account',
              [
                _buildSettingsItem(
                  context,
                  'Profile',
                  Icons.person_outline,
                  showDivider: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  ),
                ),
                _buildSettingsItem(
                  context,
                  'Notifications',
                  Icons.notifications_outlined,
                  showDivider: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                ),
              ),
            ),
                _buildSettingsItem(
                  context,
                  'Privacy',
                  Icons.lock_outline,
                ),
                _buildSettingsItem(
                  context,
                  'Sign Out',
                  Icons.logout,
                  color: Colors.red,
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                ),
              ],
            ),

            

            // Support Section
            _buildSection(
              'Support',
              [
                _buildSettingsItem(
                  context,
                  'Help Center',
                  Icons.help_outline,
                  showDivider: true,
                ),
                _buildSettingsItem(
                  context,
                  'Contact Us',
                  Icons.mail_outline,
                  showDivider: true,
                ),
                _buildSettingsItem(
                  context,
                  'Terms of Service',
                  Icons.description_outlined,
                  showDivider: true,
                  onTap: () async {
                    final url = Uri.parse('https://sites.google.com/view/dunbeholden-terms-of-service/home');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
                _buildSettingsItem(
                  context,
                  'Privacy Policy',
                  Icons.privacy_tip_outlined,
                  onTap: () async {
                    final url = Uri.parse('https://sites.google.com/view/dunbeholden-privacy-policy/home');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
              ],
            ),

            // Danger Zone
            _buildSection(
              'Danger Zone',
              [
            _buildSettingsItem(
              context, 
                  'Delete Account',
                  Icons.delete_outline,
                  color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeleteAccountScreen(),
                  ),
                );
              },
            ),
              ],
            ),

            const SizedBox(height: 20),

            // Social Media Links
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Follow Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onTap,
    Color color = Colors.white,
    bool showDivider = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
              color: color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
            color: Colors.white54,
        size: 16,
      ),
      onTap: onTap ?? () {
            // Handle navigation
          },
        ),
        if (showDivider)
          Divider(
            color: Colors.white.withAlpha(26),
            height: 1,
            indent: 56,
          ),
      ],
    );
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
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class _NotificationSettings extends StatefulWidget {
  @override
  State<_NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<_NotificationSettings> {
  late Future<bool> _notificationsEnabled;
  final _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = _notificationService.areNotificationsEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _notificationsEnabled,
      builder: (context, snapshot) {
        return ListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Get updates about matches, news, and more'),
          trailing: Switch(
            value: snapshot.data ?? false,
            onChanged: (bool value) async {
              if (value) {
                await _notificationService.requestPermissions();
              } else {
                // Open app settings to disable notifications
                await openAppSettings();
              }
              setState(() {
                _notificationsEnabled = _notificationService.areNotificationsEnabled();
              });
            },
          ),
        );
      },
    );
  }
}
