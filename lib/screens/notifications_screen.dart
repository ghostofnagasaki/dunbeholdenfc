import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/notification_service.dart';
import '../constants/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<bool> _notificationsEnabled;
  final _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  void _checkNotificationStatus() {
    setState(() {
      _notificationsEnabled = _notificationService.areNotificationsEnabled();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<bool>(
        future: _notificationsEnabled,
        builder: (context, snapshot) {
          return ListView(
            children: [
              const SizedBox(height: 16),
              _buildNotificationToggle(snapshot.data ?? false),
              const Divider(),
              _buildNotificationInfo(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationToggle(bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Push Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEnabled ? 'Enabled' : 'Disabled',
                  style: TextStyle(
                    color: isEnabled ? Colors.green : Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            activeColor: AppColors.darkBlue,
            onChanged: (value) async {
              if (value) {
                await _notificationService.requestPermissions();
              } else {
                await openAppSettings();
              }
              _checkNotificationStatus();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationInfo() {
    return const Padding(
      padding:  EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Text(
            'What you\'ll receive:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
         SizedBox(height: 16),
          _NotificationItem(
            icon: Icons.sports_soccer,
            title: 'Match Updates',
            description: 'Live scores, commentary, and results',
          ),
          SizedBox(height: 12),
          _NotificationItem(
            icon: Icons.newspaper,
            title: 'News',
            description: 'Latest team news and announcements',
          ),
          SizedBox(height: 12),
          _NotificationItem(
            icon: Icons.campaign,
            title: 'Announcements',
            description: 'Important club announcements',
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.darkBlue.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.darkBlue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 