import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_keyboard/flutter_custom_keyboard.dart';

/// Simple test app to demonstrate the input formatter fix
/// Run this to verify that restricted characters are ignored instead of clearing text
void main() {
  runApp(const TestFixApp());
}

class TestFixApp extends StatelessWidget {
  const TestFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Input Formatter Fix Test',
      home: KeyboardScaffold(
        child: const TestScreen(),
      ),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final TextEditingController _numbersOnlyController = TextEditingController(text: '123');
  final TextEditingController _lengthLimitController = TextEditingController(text: '12345');
  final TextEditingController _combinedController = TextEditingController(text: '12');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Formatter Fix Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test Input Formatter Fix',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Tap each field to bring up the custom keyboard'),
                  Text('2. Try typing INVALID characters (like "." or letters in numbers-only field)'),
                  Text('3. Verify that text is NOT cleared - invalid characters should be ignored'),
                  Text('4. Try typing valid characters to confirm they work normally'),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Numbers only field
            const Text(
              '1. Numbers Only (try typing letters or symbols):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _numbersOnlyController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')), // Only 0-9
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(
                labelText: 'Numbers Only',
                hintText: 'Try typing "." or "a" - should be ignored!',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Length limited field  
            const Text(
              '2. Length Limited (max 5, try typing more):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _lengthLimitController,
              keyboardType: TextInputType.text,
              inputFormatters: [
                LengthLimitingTextInputFormatter(5), // Max 5 chars
              ],
              decoration: const InputDecoration(
                labelText: 'Max 5 Characters',
                hintText: 'Try typing more than 5 characters',
                prefixIcon: Icon(Icons.text_fields),
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Combined formatters
            const Text(
              '3. Combined (numbers only + max 3 chars):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _combinedController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')), // Only 0-9
                LengthLimitingTextInputFormatter(3), // Max 3 chars
              ],
              decoration: const InputDecoration(
                labelText: 'Numbers Only, Max 3',
                hintText: 'Try letters or 4th digit',
                prefixIcon: Icon(Icons.pin),
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Status display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Values:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Numbers Only: "${_numbersOnlyController.text}"'),
                  Text('Length Limited: "${_lengthLimitController.text}"'),
                  Text('Combined: "${_combinedController.text}"'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _numbersOnlyController.dispose();
    _lengthLimitController.dispose();
    _combinedController.dispose();
    super.dispose();
  }
}