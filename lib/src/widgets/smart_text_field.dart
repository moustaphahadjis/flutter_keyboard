import 'package:flutter/material.dart';

import 'package:flutter_custom_keyboard/src/widgets/adaptive_text_field.dart';

/// A smart text field that provides common input type combinations
/// with sensible defaults for rapid development.
/// 
/// This widget is a simplified version of AdaptiveTextField with
/// pre-configured input type combinations for common use cases.
/// 
/// Example usage:
/// ```dart
/// SmartTextField.contact(controller: _controller)  // Phone, Email
/// SmartTextField.general(controller: _controller)  // Text, Number
/// SmartTextField.web(controller: _controller)      // Text, Email, URL
/// ```
class SmartTextField extends StatelessWidget {
  final TextEditingController controller;
  final List<TextInputType> availableTypes;
  final TextInputType? initialType;
  final bool? showTypeSelector;
  final bool obscureText;
  final int? maxLines;
  final bool enabled;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(TextInputType)? onTypeChanged;
  final Map<TextInputType, String>? customLabels;

  const SmartTextField({
    super.key,
    required this.controller,
    required this.availableTypes,
    this.initialType,
    this.showTypeSelector,
    this.obscureText = false,
    this.maxLines = 1,
    this.enabled = true,
    this.decoration,
    this.validator,
    this.onChanged,
    this.onTypeChanged,
    this.customLabels,
  });

  /// Creates a contact input field with phone and email options.
  /// Perfect for contact forms and user profiles.
  factory SmartTextField.contact({
    Key? key,
    required TextEditingController controller,
    TextInputType initialType = TextInputType.number,
    bool? showTypeSelector,
    bool obscureText = false,
    int? maxLines = 1,
    bool enabled = true,
    InputDecoration? decoration,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Function(TextInputType)? onTypeChanged,
  }) {
    return SmartTextField(
      key: key,
      controller: controller,
      availableTypes: const [
        TextInputType.number,
        TextInputType.emailAddress,
      ],
      initialType: initialType,
      showTypeSelector: showTypeSelector,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      decoration: decoration,
      validator: validator,
      onChanged: onChanged,
      onTypeChanged: onTypeChanged,
      customLabels: {
        TextInputType.number: 'Phone Number',
        TextInputType.emailAddress: 'Email Address',
      },
    );
  }

  /// Creates a general input field with text and number options.
  /// Suitable for forms that need both text and numeric input.
  factory SmartTextField.general({
    Key? key,
    required TextEditingController controller,
    TextInputType initialType = TextInputType.text,
    bool? showTypeSelector,
    bool obscureText = false,
    int? maxLines = 1,
    bool enabled = true,
    InputDecoration? decoration,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Function(TextInputType)? onTypeChanged,
  }) {
    return SmartTextField(
      key: key,
      controller: controller,
      availableTypes: const [
        TextInputType.text,
        TextInputType.number,
      ],
      initialType: initialType,
      showTypeSelector: showTypeSelector,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      decoration: decoration,
      validator: validator,
      onChanged: onChanged,
      onTypeChanged: onTypeChanged,
      customLabels: {
        TextInputType.text: 'Name',
        TextInputType.number: 'Phone Number',
      },
    );
  }

  /// Creates a web-oriented input field with text, email, and URL options.
  /// Perfect for registration forms and profile pages.
  factory SmartTextField.web({
    Key? key,
    required TextEditingController controller,
    TextInputType initialType = TextInputType.text,
    bool? showTypeSelector,
    bool obscureText = false,
    int? maxLines = 1,
    bool enabled = true,
    InputDecoration? decoration,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Function(TextInputType)? onTypeChanged,
  }) {
    return SmartTextField(
      key: key,
      controller: controller,
      availableTypes: const [
        TextInputType.text,
        TextInputType.emailAddress,
        TextInputType.url,
      ],
      initialType: initialType,
      showTypeSelector: showTypeSelector,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      decoration: decoration,
      validator: validator,
      onChanged: onChanged,
      onTypeChanged: onTypeChanged,
      customLabels: {
        TextInputType.text: 'Name',
        TextInputType.emailAddress: 'Email Address',
        TextInputType.url: 'Website URL',
      },
    );
  }

  /// Creates a comprehensive input field with all common input types.
  /// Use this when you need maximum flexibility.
  factory SmartTextField.all({
    Key? key,
    required TextEditingController controller,
    TextInputType initialType = TextInputType.text,
    bool? showTypeSelector,
    bool obscureText = false,
    int? maxLines = 1,
    bool enabled = true,
    InputDecoration? decoration,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Function(TextInputType)? onTypeChanged,
  }) {
    return SmartTextField(
      key: key,
      controller: controller,
      availableTypes: const [
        TextInputType.text,
        TextInputType.number,
        TextInputType.emailAddress,
        TextInputType.url,
      ],
      initialType: initialType,
      showTypeSelector: showTypeSelector,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      decoration: decoration,
      validator: validator,
      onChanged: onChanged,
      onTypeChanged: onTypeChanged,
    );
  }

  /// Creates a numeric input field with number and decimal options.
  /// Perfect for forms that need numeric input with decimal support.
  factory SmartTextField.numeric({
    Key? key,
    required TextEditingController controller,
    TextInputType initialType = TextInputType.number,
    bool? showTypeSelector,
    bool obscureText = false,
    int? maxLines = 1,
    bool enabled = true,
    InputDecoration? decoration,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Function(TextInputType)? onTypeChanged,
  }) {
    return SmartTextField(
      key: key,
      controller: controller,
      availableTypes: const [
        TextInputType.number,
        TextInputType.numberWithOptions(decimal: true),
      ],
      initialType: initialType,
      showTypeSelector: showTypeSelector,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      decoration: decoration,
      validator: validator,
      onChanged: onChanged,
      onTypeChanged: onTypeChanged,
      customLabels: {
        TextInputType.number: 'Number',
        const TextInputType.numberWithOptions(decimal: true): 'Decimal',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTextField(
      controller: controller,
      availableTypes: availableTypes,
      initialType: initialType,
      showTypeSelector: showTypeSelector,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      decoration: decoration,
      validator: validator,
      onChanged: onChanged,
      onTypeChanged: onTypeChanged,
      customLabels: customLabels,
    );
  }
}