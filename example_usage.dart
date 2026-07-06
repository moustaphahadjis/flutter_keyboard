// Example usage of the new pure numeric keyboard functionality

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_keyboard/flutter_custom_keyboard.dart';

class NumericKeyboardExample extends StatefulWidget {
  const NumericKeyboardExample({super.key});

  @override
  State<NumericKeyboardExample> createState() => _NumericKeyboardExampleState();
}

class _NumericKeyboardExampleState extends State<NumericKeyboardExample> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _generalController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _priceController.dispose();
    _generalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardScaffold(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pure Numeric Keyboard Demo'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Pure Numeric Keyboard Examples',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Phone number field - shows pure numeric keyboard (numbers + decimal point only)
              const Text(
                'Phone Number (Pure Numeric with Input Formatters):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _phoneController,
                keyboardType: TextInputType.number, // Shows pure numeric keyboard
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{0,15}$')), // Only numbers, max 15 digits
                  LengthLimitingTextInputFormatter(15), // Max length 15
                ],
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter phone number (max 15 digits)',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Price field - shows decimal-optimized keyboard 
              const Text(
                'Price (Decimal Optimized with Formatters):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true), // Shows decimal keyboard
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')), // Numbers with up to 2 decimal places
                  LengthLimitingTextInputFormatter(10), // Max length 10
                ],
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter price (e.g., 99.99)',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Smart field with type selector
              const Text(
                'Smart Field (User Selectable with Formatters):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              AdaptiveTextField(
                controller: _generalController,
                availableTypes: [TextInputType.text, TextInputType.number, TextInputType.emailAddress],
                initialType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20), // General max length
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Information card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Keyboard Behavior',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('• Phone field: Pure numeric keyboard with input formatters (max 15 digits)'),
                    const Text('• Price field: Decimal-optimized keyboard with decimal formatting'),
                    const Text('• Smart field: User can switch between text and number with length limit'),
                    const Text('• All keyboards hide alphabet switch when in number mode'),
                    const Text('• Input formatters work seamlessly with custom keyboard input'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}