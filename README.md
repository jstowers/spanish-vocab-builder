# Spanish Vocab Builder

Saturday, July 26, 2025

## Motivation

I want to build a Dart/Flutter app that allows me to enter Spanish words and their English definitions and saves them in a Google Firebase database.

When I click a button Add Word, I want three fields in a column:
1. Spanish word
2. English definition
3. Part of speech

The first two fields will be text fields.  The third field, Part of speech, will be a dropdown.

The `Part of speech` dropdown will have the following values:
1. Noun
2. Verb
3. Adjective
4. Preposition
5. Phrase

Below these fields will be a `Save word` button.  When I click this button, the vocab data will be saved in my Firestore database.

When I click a button `Show words`, I want to see a table of the vocabulary words presenting in alphabetical order in Spanish.

## Features

✅ **Landing Screen** - clean, modern interface with two main buttons

✅ **Add Word Screen** - three fields in a column (Spanish word, English definition, Part of speech dropdown)

✅ **Show Words Screen** - table view of vocabulary words sorted alphabetically in Spanish

✅ **Firebase Integration** - save and retrieve words from Firestore database

✅ **Delete Functionality** - remove words from the vocabulary list

✅ **Form Validation** - ensure all fields are filled before saving

✅ **Loading States** - visual feedback during database operations

✅ **Error Handling** - user-friendly error messages

## Project Structure

```
lib/
├── main.dart                    # app entry point
├── firebase_options.dart        # Firebase configuration
├── models/
│   └── vocab_word.dart          # data model for vocabulary words
├── services/
│   └── firebase_service.dart    # Firebase database operations
└── screens/
    ├── landing_screen.dart      # main landing screen
    ├── add_word_screen.dart     # add new vocab word
    └── show_words_screen.dart   # display vocab table
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.32.7 or higher)
- Dart SDK (v3.8.1 or higher)
- Google Firebase project
- iOS or Android phone simulator

### Installation

1. __Clone the repository__
   
   ```bash
   git clone <repository-url>
   cd spanish-vocab
   ```

2. __Install dependencies__
   
   ```bash
   flutter pub get
   ```

3. __Configure Firebase__
   
   a. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/).
   
   b. Create and configure a Firestore database in your Firebase project.
   
   c. Install FlutterFire CLI:

   ```bash
   dart pub global activate flutterfire_cli
   ```
   
   d. Configure Firebase for your app:

   ```bash
   flutterfire configure
   ```
   
   This will generate a `firebase_options.dart` file with your project configuration.  Because this file contains API keys, you must add this file to your `.gitignore` and never commit it to GitHub.

### Run the App

1. __Start the iPhone Simulator__

   ```bsh
   open -a Simulator
   ```

2. **Run the app**

   ```bash
   flutter run
   ```

## Usage

1. **Adding Words**: Tap "Add Word" on the landing screen, fill in the three fields, and tap "Save Word"
2. **Viewing Words**: Tap "Show Words" to see all vocabulary words in a table format
3. **Deleting Words**: Tap the delete icon next to any word in the table view

## Dependencies

- `flutter` - UI framework
- `firebase_core` - Firebase initialization
- `cloud_firestore` - Firestore database operations
- `cupertino_icons` - iOS-style icons

## Future Enhancements

- Edit existing words
- Search and filter functionality
- Categories/tags for words
- Export/import vocabulary lists
- Offline support
- User authentication
- Multiple language support

## Revisions

Initial commit:  Saturday, July 26, 2025

