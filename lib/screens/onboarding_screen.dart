import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../services/notification_service.dart';
import 'mydbn_screen.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final NotificationService _notificationService = NotificationService();
  late final List<OnboardingPage> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const OnboardingPage(
        image: 'assets/images/shop_banner.jpg',
        title: 'Welcome to Dunbeholden FC',
        description: 'Your official source for all things Dunbeholden Football Club',
      ),
      const OnboardingPage(
        image: 'assets/images/shop_banner.jpg',
        title: 'Live Match Updates',
        description: 'Follow matches in real-time with live commentary and updates',
      ),
      const OnboardingPage(
        image: 'assets/images/shop_banner.jpg',
        title: 'Latest News & Updates',
        description: 'Stay informed with exclusive news, interviews, and behind-the-scenes content',
      ),
      OnboardingPage(
        image: 'assets/images/shop_banner.jpg',
        title: 'Stay Updated',
        description: 'Never miss important updates about your favorite club',
        customContent: NotificationRequestWidget(
          onEnable: () async {
            await _notificationService.requestPermissions();
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          onSkip: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
      OnboardingPage(
        image: 'assets/images/shop_banner.jpg',
        title: 'Join Our Family',
        description: 'Become a member and get exclusive benefits',
        customContent: MembershipRequestWidget(
          onJoin: () {
            _completeOnboarding(navigateToMembership: true);
          },
          onSkip: _completeOnboarding,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) => _pages[index],
          ),

          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: TextButton(
              onPressed: _completeOnboarding,
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withAlpha(153),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index 
                              ? AppColors.primary 
                              : AppColors.primary.withAlpha(77),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Next/Get Started button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeOnboarding({bool navigateToMembership = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => navigateToMembership 
              ? const MyDBNScreen() 
              : const MainScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class NotificationRequestWidget extends StatelessWidget {
  final VoidCallback onEnable;
  final VoidCallback onSkip;

  const NotificationRequestWidget({
    super.key,
    required this.onEnable,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
        const SizedBox(height: 24),
          ElevatedButton(
          onPressed: onEnable,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Enable Notifications'),
        ),
        TextButton(
          onPressed: onSkip,
          child: const Text(
            'Maybe Later',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

class MembershipRequestWidget extends StatelessWidget {
  final VoidCallback onJoin;
  final VoidCallback onSkip;

  const MembershipRequestWidget({
    super.key,
    required this.onJoin,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
        const SizedBox(height: 24),
          ElevatedButton(
          onPressed: onJoin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Join Now'),
        ),
        TextButton(
          onPressed: onSkip,
          child: const Text(
            'Skip for Now',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final Widget? customContent;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withAlpha(77),
              Colors.black.withAlpha(179),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                if (customContent != null) customContent!,
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
