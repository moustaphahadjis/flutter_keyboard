import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_custom_keyboard/src/models/keyboard_models.dart';
import 'package:flutter_custom_keyboard/src/state/keyboard_state_manager.dart';
import 'package:flutter_custom_keyboard/src/widgets/keyboard_scaffold.dart';

/// Utility functions for integrating custom keyboard with standard Flutter widgets.
/// 
/// These utilities help you add custom keyboard functionality to existing
/// TextFormField, TextField, or other input widgets without replacing them.
class KeyboardUtils {
  /// Creates a FocusNode that integrates with the custom keyboard system.
  /// 
  /// Use this FocusNode with your TextFormField or TextField to automatically
  /// reset the keyboard state when focus changes and manage the custom keyboard.
  /// 
  /// Example:
  /// ```dart
  /// final focusNode = KeyboardUtils.createCustomKeyboardFocusNode(_controller, TextInputType.number);
  /// 
  /// TextFormField(
  ///   controller: _controller,
  ///   focusNode: focusNode,
  ///   keyboardType: TextInputType.none, // Disable system keyboard
  ///   // ... other properties
  /// )
  /// ```
  static FocusNode createCustomKeyboardFocusNode(
    TextEditingController controller, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    final focusNode = FocusNode();
    
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // Convert TextInputType to CustomKeyboardType and register controller with type
        final customKeyboardType = KeyboardStateManager.textInputTypeToCustomKeyboardType(keyboardType);
        KeyboardManager.setCurrentControllerWithType(controller, customKeyboardType);
        
        // Immediately hide system keyboard
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        
        // Hide system keyboard more aggressively
        Future.delayed(const Duration(milliseconds: 50), () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        });
        
        // Show custom keyboard
        KeyboardManager.show();
        
        // Scroll to make field visible
        Future.delayed(const Duration(milliseconds: 300), () {
          KeyboardManager.scrollToField();
        });
      } else {
        // Unregister this controller
        KeyboardManager.clearCurrentController();
        
        // Hide custom keyboard if no other field is focused
        Future.delayed(const Duration(milliseconds: 100), () {
          if (FocusManager.instance.primaryFocus == null) {
            KeyboardManager.hide();
          }
        });
      }
    });
    
    return focusNode;
  }
  
  /// Manually resets the keyboard to its default state.
  /// 
  /// This can be called programmatically to reset the keyboard layout
  /// back to QWERTY with no shift or caps lock active.
  /// 
  /// Example:
  /// ```dart
  /// KeyboardUtils.resetKeyboard();
  /// ```
  static void resetKeyboard() {
    KeyboardManager.reset();
  }
  
  /// Resets the keyboard to a specific type.
  /// 
  /// This can be called programmatically to reset the keyboard layout
  /// to a specific type (number, email, etc.).
  /// 
  /// Example:
  /// ```dart
  /// KeyboardUtils.resetKeyboardWithType(CustomKeyboardType.number);
  /// ```
  static void resetKeyboardWithType(CustomKeyboardType type) {
    KeyboardManager.resetWithType(type);
  }
  
  /// Shows the custom keyboard programmatically.
  /// 
  /// This is useful when you want to show the keyboard without
  /// focusing on a specific text field.
  static void showKeyboard() {
    KeyboardManager.show();
  }
  
  /// Hides the custom keyboard programmatically.
  /// 
  /// This is useful when you want to dismiss the keyboard
  /// manually without unfocusing text fields.
  static void hideKeyboard() {
    KeyboardManager.hide();
  }
  
  /// Creates a FocusNode specifically for number input fields.
  /// 
  /// This is a convenience method that creates a FocusNode configured
  /// to show the numeric keyboard when focused.
  /// 
  /// Example:
  /// ```dart
  /// final focusNode = KeyboardUtils.createNumberFocusNode(_controller);
  /// 
  /// TextFormField(
  ///   controller: _controller,
  ///   focusNode: focusNode,
  ///   keyboardType: TextInputType.none,
  /// )
  /// ```
  static FocusNode createNumberFocusNode(TextEditingController controller) {
    return createCustomKeyboardFocusNode(controller, TextInputType.number);
  }
  
  /// Creates a FocusNode specifically for phone number input fields.
  /// 
  /// This is a convenience method that creates a FocusNode configured
  /// to show the phone keyboard when focused.
  static FocusNode createPhoneFocusNode(TextEditingController controller) {
    return createCustomKeyboardFocusNode(controller, TextInputType.phone);
  }
  
  /// Creates a FocusNode specifically for email input fields.
  /// 
  /// This is a convenience method that creates a FocusNode configured
  /// to show the email keyboard when focused.
  static FocusNode createEmailFocusNode(TextEditingController controller) {
    return createCustomKeyboardFocusNode(controller, TextInputType.emailAddress);
  }
  
  /// Creates a FocusNode specifically for URL input fields.
  /// 
  /// This is a convenience method that creates a FocusNode configured
  /// to show the URL keyboard when focused.
  static FocusNode createUrlFocusNode(TextEditingController controller) {
    return createCustomKeyboardFocusNode(controller, TextInputType.url);
  }
  
  /// Creates a FocusNode specifically for decimal number input fields.
  /// 
  /// This is a convenience method that creates a FocusNode configured
  /// to show the decimal keyboard when focused.
  static FocusNode createDecimalFocusNode(TextEditingController controller) {
    return createCustomKeyboardFocusNode(controller, const TextInputType.numberWithOptions(decimal: true));
  }
}