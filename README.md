# Debt Tracker

A Flutter-based mobile application for tracking shared expenses and managing debts between friends, roommates, or group members.

## Features

### ? Authentication
- User registration and login system
- Secure authentication with Firebase
- Certificate-based login option

### ? Room Management
- Create new rooms for different events or groups
- Join existing rooms using room keys
- View room members and their status
- Leave rooms when no longer needed

### ? Expense Tracking
- Add expenses with detailed descriptions
- Track who paid for what
- Record actual amounts vs. paid amounts
- Real-time updates across all room members

### ? Debt Settlement
- Automatic calculation of debts between members
- View detailed breakdown of who owes what to whom
- Settle debts with a single tap
- Historical record of all settlements

### ? Event Management
- Create events and associate rooms with them
- Join multiple events simultaneously
- Track expenses across different events
- Separate settlement for each event

### ? User Experience
- Modern, intuitive UI with Material Design
- Pull-to-refresh functionality
- Loading overlays for better UX
- Responsive design for different screen sizes

## Screenshots

[Add screenshots here when available]

## Technology Stack

- **Framework**: Flutter
- **Backend**: Firebase Firestore
- **Authentication**: Firebase Auth
- **State Management**: Flutter StatefulWidget
- **UI Components**: Material Design, Google Nav Bar, Line Icons
- **Loading**: Loader Overlay, Flutter Spinkit

## Getting Started

### Prerequisites

- Flutter SDK (>=2.18.5)
- Dart SDK
- Android Studio / VS Code
- Firebase project setup

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/debt-tracker.git
cd debt-tracker
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add your Android/iOS apps to the project
   - Download and place the configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS
   - Update the Firebase configuration in `lib/firebase_options.dart`

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
¢u¢w¢w main.dart                 # App entry point
¢u¢w¢w firebase_options.dart     # Firebase configuration
¢u¢w¢w firestore/
¢x   ¢|¢w¢w firestore.dart        # Firestore database operations
¢u¢w¢w loginAndRegister/         # Authentication screens
¢u¢w¢w home/                     # Main app screens
¢x   ¢u¢w¢w home.dart            # Main navigation
¢x   ¢u¢w¢w event.dart           # Event management
¢x   ¢u¢w¢w inRoom.dart          # Room details and expense tracking
¢x   ¢u¢w¢w settleEvent.dart     # Debt settlement
¢x   ¢u¢w¢w event/               # Event-related screens
¢x   ¢|¢w¢w room/                # Room management screens
¢|¢w¢w images/                  # App assets
```

## Key Features Explained

### Room System
- Each room represents a group of people sharing expenses
- Rooms have unique keys for joining
- Members can add expenses and track payments

### Expense Tracking
- Users can add expenses with descriptions
- Track both intended and actual amounts
- Real-time synchronization across all members

### Debt Settlement
- Automatic calculation of net debts
- Shows who owes money to whom
- One-tap settlement process
- Maintains history of settlements

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Version

Current version: 0.18

## Support

If you encounter any issues or have questions, please open an issue on GitHub.

---

Built with ?? using Flutter and Firebase
