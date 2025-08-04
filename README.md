# Debt Tracker

A Flutter mobile app for tracking shared expenses and managing debts between friends, roommates, or group members.

## What This App Does

### User Accounts
- Sign up and log in with your account
- Secure login with Firebase
- Certificate-based login option

### Room Management
- Create new rooms for different groups or events
- Join existing rooms using room keys
- See who is in each room
- Leave rooms when you don't need them anymore

### Expense Tracking
- Add expenses with descriptions
- Track who paid for what
- Record planned amounts and actual amounts
- Updates in real-time for all room members

### Debt Settlement
- Automatically calculates debts between members
- Shows who owes money to whom
- Settle debts with one tap
- Keeps history of all settlements

### Event Management
- Create events and connect rooms to them
- Join multiple events at the same time
- Track expenses across different events
- Separate settlement for each event

### User Interface
- Clean and easy to use design
- Pull down to refresh data
- Loading screens for better experience
- Works on different screen sizes

## Technology Used

- Flutter framework
- Firebase Firestore database
- Firebase Authentication
- Material Design components
- Google Navigation Bar
- Line Icons

## How to Set Up

### What You Need

- Flutter SDK (version 2.18.5 or higher)
- Dart SDK
- Android Studio or VS Code
- Firebase project

### Installation Steps

1. Download the code:
```bash
git clone https://github.com/yourusername/debt-tracker.git
cd debt-tracker
```

2. Install packages:
```bash
flutter pub get
```

3. Set up Firebase:
   - Create a new Firebase project
   - Add your Android/iOS apps to the project
   - Download and add these files:
     - google-services.json for Android
     - GoogleService-Info.plist for iOS
   - Update the Firebase settings in lib/firebase_options.dart

4. Run the app:
```bash
flutter run
```

## Project Files

```
lib/
??? main.dart                 # Main app file
??? firebase_options.dart     # Firebase settings
??? firestore/
?   ??? firestore.dart        # Database operations
??? loginAndRegister/         # Login and signup screens
??? home/                     # Main app screens
?   ??? home.dart            # Main navigation
?   ??? event.dart           # Event management
?   ??? inRoom.dart          # Room details and expenses
?   ??? settleEvent.dart     # Debt settlement
?   ??? event/               # Event screens
?   ??? room/                # Room management screens
??? images/                  # App images
```

## How It Works

### Rooms
- Each room is a group of people sharing expenses
- Rooms have unique keys for joining
- Members can add expenses and track payments

### Expenses
- Users can add expenses with descriptions
- Track both planned and actual amounts
- Updates happen in real-time for all members

### Debt Settlement
- Automatically calculates net debts
- Shows who owes money to whom
- One-tap settlement process
- Keeps history of settlements

## How to Help

1. Fork this project
2. Create a new branch for your changes
3. Make your changes
4. Push your changes
5. Create a Pull Request

## Version

Current version: 0.18

## Support

If you have problems or questions, please create an issue on GitHub.

---

Made with Flutter and Firebase
