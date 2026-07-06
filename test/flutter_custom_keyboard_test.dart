import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_custom_keyboard/flutter_custom_keyboard.dart';

void main() {
  group('Flutter Custom Keyboard Package Tests', () {
    testWidgets('CustomTextField can be created', (WidgetTester tester) async {
      final controller = TextEditingController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyboardScaffold(
              child: CustomTextField(
                controller: controller,
                hintText: 'Test hint',
                labelText: 'Test label',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test label'), findsOneWidget);
      expect(find.text('Test hint'), findsOneWidget);
    });

    testWidgets('CustomKeyboard can be created', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomKeyboard(
              onTextInput: (text) {},
              onBackspace: () {},
              onEnter: () {},
            ),
          ),
        ),
      );

      // Verify keyboard is rendered
      expect(find.byType(CustomKeyboard), findsOneWidget);
    });

    test('KeyboardStateManager initializes correctly', () {
      final stateManager = KeyboardStateManager();
      
      expect(stateManager.currentLayout, KeyboardLayout.qwerty);
      expect(stateManager.shiftState, ShiftState.none);
      expect(stateManager.isUpperCase, false);
    });

    test('KeyData model works correctly', () {
      const keyData = KeyData(
        value: 'a',
        type: KeyType.letter,
        shiftValue: 'A',
      );
      
      expect(keyData.value, 'a');
      expect(keyData.type, KeyType.letter);
      expect(keyData.shiftValue, 'A');
      expect(keyData.displayValue, 'a');
    });

    test('KeyboardLayouts provides correct layouts', () {
      final qwertyLayout = KeyboardLayouts.getLayoutForKeyboard(KeyboardLayout.qwerty);
      final numericLayout = KeyboardLayouts.getLayoutForKeyboard(KeyboardLayout.numeric);
      final symbolsLayout = KeyboardLayouts.getLayoutForKeyboard(KeyboardLayout.symbols);
      
      expect(qwertyLayout.isNotEmpty, true);
      expect(numericLayout.isNotEmpty, true);
      expect(symbolsLayout.isNotEmpty, true);
    });

    test('Layout switching works correctly', () {
      final nextLayout1 = KeyboardLayouts.getNextLayout(KeyboardLayout.qwerty, '123');
      final nextLayout2 = KeyboardLayouts.getNextLayout(KeyboardLayout.numeric, '!@#');
      final nextLayout3 = KeyboardLayouts.getNextLayout(KeyboardLayout.symbols, 'ABC');
      
      expect(nextLayout1, KeyboardLayout.numeric);
      expect(nextLayout2, KeyboardLayout.symbols);
      expect(nextLayout3, KeyboardLayout.qwerty);
    });

    test('Shift state management works correctly', () {
      final stateManager = KeyboardStateManager();
      
      // Test shift activation
      stateManager.handleShiftKey();
      expect(stateManager.shiftState, ShiftState.single);
      expect(stateManager.isUpperCase, true);
      
      // Test caps lock (double tap)
      stateManager.handleShiftKey();
      expect(stateManager.shiftState, ShiftState.capsLock);
      expect(stateManager.isUpperCase, true);
      
      // Test back to normal (third tap)
      stateManager.handleShiftKey();
      expect(stateManager.shiftState, ShiftState.none);
      expect(stateManager.isUpperCase, false);
    });

    test('Key value generation works correctly', () {
      final stateManager = KeyboardStateManager();
      
      const letterKey = KeyData(value: 'a', type: KeyType.letter);
      const numberKey = KeyData(value: '1', type: KeyType.number);
      const spaceKey = KeyData(value: ' ', type: KeyType.space);
      
      // Test normal case
      expect(stateManager.getKeyValue(letterKey), 'a');
      expect(stateManager.getKeyValue(numberKey), '1');
      expect(stateManager.getKeyValue(spaceKey), ' ');
      
      // Test shift case
      stateManager.handleShiftKey();
      expect(stateManager.getKeyValue(letterKey), 'A');
      expect(stateManager.getKeyValue(numberKey), '1'); // Numbers don't change
    });
  });
}