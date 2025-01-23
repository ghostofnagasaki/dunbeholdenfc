# Dunbeholden FC Official App

The official mobile application for Dunbeholden Football Club, providing fans with live match updates, news, and exclusive content.

## Features

- **Live Match Updates**: Real-time scores, commentary, and match statistics
- **News & Announcements**: Latest club news, transfer updates, and official announcements
- **Player Profiles**: Detailed information about squad members
- **Push Notifications**: Stay updated with match events and club news
- **MyDBN Membership**: Exclusive content and benefits for members

## Technical Details

### Built With
- Flutter 3.5.0
- Firebase (Auth, Firestore, Cloud Functions, Analytics)
- Riverpod for state management
- Cached Network Image for optimized image loading
- Firebase Cloud Messaging for notifications

### Performance Optimizations
- Lazy loading for lists
- Image caching
- Optimized build settings for Android
- Performance monitoring
- Shader warming

### Requirements
- Flutter SDK ^3.5.0
- Dart SDK ^3.0.0
- Android SDK 24+ (Android 7.0 or higher)
- iOS 11.0+

## Getting Started

1. Clone the repository
```bash
git clone https://github.com/yourusername/dunbeholden-app.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Set up Firebase
- Create a Firebase project
- Add Android & iOS apps
- Download and place configuration files:
  - `google-services.json` for Android
  - `GoogleService-Info.plist` for iOS

4. Run the app
```bash
flutter run
```

## Architecture

The app follows a clean architecture pattern with:
- Services for external interactions
- Repositories for data management
- Providers for state management
- Models for data structures
- Screens for UI components

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is proprietary and confidential. All rights reserved by Dunbeholden FC.

## Contact

For support or queries, contact [support@dunbeholdenfc.com](mailto:support@dunbeholdenfc.com)