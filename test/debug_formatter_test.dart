import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Debug Formatter Behavior', () {
    test('Test how FilteringTextInputFormatter behaves with rejected input', () {
      final formatter = FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'));
      
      // Test case 1: Valid input
      final oldValue1 = const TextEditingValue(text: '123', selection: TextSelection.collapsed(offset: 3));
      final newValue1 = const TextEditingValue(text: '1234', selection: TextSelection.collapsed(offset: 4));
      final result1 = formatter.formatEditUpdate(oldValue1, newValue1);
      
      print('Valid input:');
      print('  Old: "${oldValue1.text}"');
      print('  New: "${newValue1.text}"');
      print('  Result: "${result1.text}"');
      print('  Same as old? ${result1.text == oldValue1.text && result1.selection == oldValue1.selection}');
      print('');
      
      // Test case 2: Invalid input (adding letter)
      final oldValue2 = const TextEditingValue(text: '123', selection: TextSelection.collapsed(offset: 3));
      final newValue2 = const TextEditingValue(text: '123a', selection: TextSelection.collapsed(offset: 4));
      final result2 = formatter.formatEditUpdate(oldValue2, newValue2);
      
      print('Invalid input (letter):');
      print('  Old: "${oldValue2.text}"');
      print('  New: "${newValue2.text}"');
      print('  Result: "${result2.text}"');
      print('  Same as old? ${result2.text == oldValue2.text && result2.selection == oldValue2.selection}');
      print('');
      
      // Test case 3: Invalid input (adding dot)
      final oldValue3 = const TextEditingValue(text: '123', selection: TextSelection.collapsed(offset: 3));
      final newValue3 = const TextEditingValue(text: '123.', selection: TextSelection.collapsed(offset: 4));
      final result3 = formatter.formatEditUpdate(oldValue3, newValue3);
      
      print('Invalid input (dot):');
      print('  Old: "${oldValue3.text}"');
      print('  New: "${newValue3.text}"');
      print('  Result: "${result3.text}"');
      print('  Same as old? ${result3.text == oldValue3.text && result3.selection == oldValue3.selection}');
      print('');
      
      // Test case 4: Replace selection with invalid character
      final oldValue4 = const TextEditingValue(text: '123', selection: TextSelection(baseOffset: 1, extentOffset: 2));
      final newValue4 = const TextEditingValue(text: '1.3', selection: TextSelection.collapsed(offset: 2));
      final result4 = formatter.formatEditUpdate(oldValue4, newValue4);
      
      print('Replace selection with invalid:');
      print('  Old: "${oldValue4.text}" (selection: ${oldValue4.selection})');
      print('  New: "${newValue4.text}" (selection: ${newValue4.selection})');
      print('  Result: "${result4.text}" (selection: ${result4.selection})');
      print('  Same as old? ${result4.text == oldValue4.text && result4.selection == oldValue4.selection}');
    });
  });
}