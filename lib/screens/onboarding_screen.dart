import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      _buildWelcomePage(),
      // _buildRoleSelectionPage(),
      _buildNotificationPermissionPage(),
      _buildMicrophonePermissionPage(),
      _buildCameraPermissionPage(),
      _buildThankYouPage(),
    ]);
  }

  Widget _buildWelcomePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome to the App!', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _nextPage(),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  // Widget _buildRoleSelectionPage() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const Text('Select Your Role', style: TextStyle(fontSize: 24)),
  //         const SizedBox(height: 20),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Save role as 'teacher'
  //             _nextPage();
  //           },
  //           child: const Text('I am a Teacher'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Save role as 'student'
  //             _nextPage();
  //           },
  //           child: const Text('I am a Student'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildNotificationPermissionPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Enable Notifications', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Request notification permission
              await Permission.notification.request();
              _nextPage();
            },
            child: const Text('Enable Notifications'),
          ),
        ],
      ),
    );
  }

  Widget _buildMicrophonePermissionPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Enable Microphone Access',
              style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Request microphone permission
              await Permission.microphone.request();
              _nextPage();
            },
            child: const Text('Enable Microphone'),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPermissionPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Enable Camera Access', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Request camera permission
              await Permission.camera.request();
              _nextPage();
            },
            child: const Text('Enable Camera'),
          ),
        ],
      ),
    );
  }

  Widget _buildThankYouPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Thank You!', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to home screen without allowing back navigation
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('Go to Home Screen'),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    setState(() {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
      } else {
        // Navigate to home screen if on the last page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
    );
  }
}
