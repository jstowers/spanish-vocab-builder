// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spanish_vocab/main.dart';

void main() {
  testWidgets('Spanish Vocab app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SpanishVocabApp());

    // Verify that the app starts with the landing screen
    expect(find.text('Spanish Vocab Builder'), findsAtLeastNWidgets(1));
    expect(find.text('Build your Spanish vocabulary with ease'), findsOneWidget);
    expect(find.text('Add Word'), findsOneWidget);
    expect(find.text('Show Words'), findsOneWidget);
  });
}
