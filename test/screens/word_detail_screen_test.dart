import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:spanish_vocab/models/vocab_word.dart';
import 'package:spanish_vocab/services/firebase_service.dart';
import 'package:spanish_vocab/screens/word_detail_screen.dart';

import 'word_detail_screen_test.mocks.dart';

@GenerateMocks([FirebaseService])
void main() {
  group('WordDetailScreen', () {
    late MockFirebaseService mockFirebaseService;
    late VocabWord testWord;

    setUp(() {
      mockFirebaseService = MockFirebaseService();
      testWord = VocabWord(
        id: 'test-id-123',
        spanish: 'hola',
        english: 'hello',
        partOfSpeech: 'Noun',
        timestamp: 'January 1, 2024 at 12:00:00 PM UTC+0',
        notes: 'Test note',
      );
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 800,
            height: 800,
            child: WordDetailScreen(word: testWord),
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('should display word details correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Check that the word details are displayed
        expect(find.text('hola'), findsOneWidget);
        expect(find.text('hello'), findsOneWidget);
        expect(find.text('Noun'), findsOneWidget);
        expect(find.text('Test note'), findsOneWidget);
        expect(find.text('January 1, 2024 at 12:00:00 PM UTC+0'), findsOneWidget);
      });

      testWidgets('should initialize with correct part of speech selected', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Check that the dropdown shows the correct value
        expect(find.text('Noun'), findsOneWidget);
      });

      testWidgets('should initialize with Update button disabled', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Check that Update button is initially disabled
        final updateButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Update Word'),
        );
        expect(updateButton.onPressed, isNull);
      });
    });

    group('Change Detection', () {
      testWidgets('should enable Update button when Spanish word is changed', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Change the Spanish word
        await tester.enterText(find.widgetWithText(TextField, 'Spanish word'), 'adios');
        await tester.pump();

        // Check that Update button is now enabled
        final updateButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Update Word'),
        );
        expect(updateButton.onPressed, isNotNull);
      });

      testWidgets('should enable Update button when English word is changed', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Change the English word
        await tester.enterText(find.widgetWithText(TextField, 'English definition'), 'goodbye');
        await tester.pump();

        // Check that Update button is now enabled
        final updateButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Update Word'),
        );
        expect(updateButton.onPressed, isNotNull);
      });

      testWidgets('should enable Update button when part of speech is changed', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Change the part of speech
        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Verb').last);
        await tester.pump();

        // Check that Update button is now enabled
        final updateButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Update Word'),
        );
        expect(updateButton.onPressed, isNotNull);
      });

      testWidgets('should enable Update button when notes are changed', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Change the notes
        await tester.enterText(find.widgetWithText(TextField, 'Note or Reference'), 'Updated note');
        await tester.pump();

        // Check that Update button is now enabled
        final updateButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Update Word'),
        );
        expect(updateButton.onPressed, isNotNull);
      });

      testWidgets('should disable Update button when changes are reverted', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Change the Spanish word
        await tester.enterText(find.widgetWithText(TextField, 'Spanish word'), 'adios');
        await tester.pump();

        // Verify button is enabled
        var updateButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Update Word'),
        );
        expect(updateButton.onPressed, isNotNull);

        // Revert the change
        await tester.enterText(find.widgetWithText(TextField, 'Spanish word'), 'hola');
        await tester.pump();

        // Check that Update button is disabled again
        updateButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Update Word'),
        );
        expect(updateButton.onPressed, isNull);
      });
    });

    group('UI Elements', () {
      testWidgets('should have correct field labels', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Spanish word'), findsOneWidget);
        expect(find.text('English definition'), findsOneWidget);
        expect(find.text('Part of speech'), findsOneWidget);
        expect(find.text('Date and Time'), findsOneWidget);
        expect(find.text('Note or Reference'), findsOneWidget);
      });

      testWidgets('should have correct button labels', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Update Word'), findsOneWidget);
        expect(find.text('Delete Word'), findsOneWidget);
      });

      testWidgets('should have correct app bar title', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Word Detail'), findsOneWidget);
      });

      testWidgets('should have notes field with multiple lines', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final notesField = tester.widget<TextField>(
          find.widgetWithText(TextField, 'Note or Reference'),
        );
        expect(notesField.maxLines, equals(4));
      });

      testWidgets('should have disabled timestamp field', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final timestampField = tester.widget<TextField>(
          find.widgetWithText(TextField, 'Date and Time'),
        );
        expect(timestampField.enabled, isFalse);
      });
    });

    group('Delete Word Dialog', () {
      testWidgets('should have delete button present', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify delete button exists
        expect(find.text('Delete Word'), findsOneWidget);
      });
    });
  });
} 