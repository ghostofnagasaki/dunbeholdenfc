import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/staff.dart';
import '../providers/staff_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class StaffCard extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;

  const StaffCard({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          'assets/icons/dunbeholden.png',
                          color: Colors.grey[700],
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/icons/dunbeholden.png',
                          color: Colors.grey[700],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withAlpha(153),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withAlpha(153),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Text(
                    role.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              name.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class StaffScreen extends ConsumerWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffStreamProvider);

    return staffAsync.when(
      data: (staffList) {
        // Group staff by role
        final coaches = staffList.where((s) => s.role == 'Coach').toList();
        final medical = staffList.where((s) => s.role == 'Medical').toList();
        final other = staffList.where((s) => s.role == 'Other').toList();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (coaches.isNotEmpty) ...[
                  const Text(
                    'COACHING STAFF',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStaffGrid(coaches),
                  const SizedBox(height: 24),
                ],
                if (medical.isNotEmpty) ...[
                  const Text(
                    'MEDICAL STAFF',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStaffGrid(medical),
                  const SizedBox(height: 24),
                ],
                if (other.isNotEmpty) ...[
                  const Text(
                    'OTHER STAFF',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStaffGrid(other),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingView(),
      error: (error, stack) => ErrorView(
        message: error.toString(),
        onRetry: () => ref.refresh(staffStreamProvider),
      ),
    );
  }

  Widget _buildStaffGrid(List<Staff> staffList) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        final staff = staffList[index];
        return StaffCard(
          name: staff.name,
          role: staff.role,
          imageUrl: staff.image,
        );
      },
    );
  }
} 