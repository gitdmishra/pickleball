# Pickleball Score Tracker

A Flutter mobile app for tracking pickleball game scores and visualizing courts.

## Features

- **Score Tracking**: Keep track of points, games, and matches
- **Court Visualization**: Visual representation of pickleball court
- **Game Setup**: Configure points per game and games per match
- **Serving Side Tracking**: Track which side is serving
- **Dark Theme**: Clean, modern dark interface

## Getting Started

### Prerequisites

- Flutter SDK (>=2.7.0 <3.0.0)
- Dart SDK
- Android Studio or Xcode for device testing

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd pickleball
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart           # App entry point and setup
├── score_table.dart    # Score tracking UI components
├── court_painter.dart  # Court visualization/drawing
└── set.dart           # Game set logic and data models

images/                 # App assets and icons
android/               # Android platform code
ios/                   # iOS platform code
```

## Dependencies

- `flutter`: Flutter SDK
- `cupertino_icons`: iOS-style icons
- `flutter_dash`: Dashed line drawing for court visualization

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request
