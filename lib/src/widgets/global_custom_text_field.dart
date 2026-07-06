import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_custom_keyboard/src/state/keyboard_state_manager.dart';
import 'package:flutter_custom_keyboard/src/widgets/keyboard_scaffold.dart';

/// A global custom text field widget that integrates with the custom keyboard.
/// 
/// This widget provides enhanced functionality for use with any TextFormField
/// or custom input widget. It automatically handles focus management and
/// keyboard state reset when switching between fields.
/// 
/// Example usage:
/// ```dart
/// GlobalCustomTextField(
///   controller: _controller,
///   labelText: 'Username',
///   hintText: 'Enter your username',
///   prefixIcon: Icon(Icons.person),
/// )
/// ```
class GlobalCustomTextField extends StatefulWidget {
  /// Controls the text being edited in this text field.
  final TextEditingController controller;
  
  /// Text that appears in the text field when it's empty.
  final String? hintText;
  
  /// Whether to obscure the text being edited (e.g., for passwords).
  final bool obscureText;
  
  /// The type of information for which to optimize the text input control.
  final TextInputType keyboardType;
  
  /// Optional text that describes the input field.
  final String? labelText;
  
  /// An icon that appears before the editable part of the text field.
  final Widget? prefixIcon;
  
  /// An icon that appears after the editable part of the text field.
  final Widget? suffixIcon;
  
  /// Called when the user indicates that they are done editing the text.
  final Function(String)? onSubmitted;
  
  /// The maximum number of lines for the text field.
  final int? maxLines;
  
  /// Whether the text field is enabled for user interaction.
  final bool enabled;
  
  /// Custom decoration for the text field.
  final InputDecoration? decoration;
  
  /// Validator function for form validation.
  final String? Function(String?)? validator;
  
  /// Called when the value of the text field changes.
  final Function(String)? onChanged;

  const GlobalCustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
    this.maxLines = 1,
    this.enabled = true,
    this.decoration,
    this.validator,
    this.onChanged,
  });

  @override
  State<GlobalCustomTextField> createState() => _GlobalCustomTextFieldState();
}

class _GlobalCustomTextFieldState extends State<GlobalCustomTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _focusAnimationController;
  late Animation<Color?> _borderColorAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    
    _focusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _borderColorAnimation = ColorTween(
      begin: Colors.grey.shade300,
      end: Colors.blue.shade400,
    ).animate(CurvedAnimation(
      parent: _focusAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _focusAnimationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // Start focus animation
      _focusAnimationController.forward();
      
      // Convert TextInputType to CustomKeyboardType
      final customKeyboardType = KeyboardStateManager.textInputTypeToCustomKeyboardType(widget.keyboardType);
      
      // Set keyboard type first, before showing
      KeyboardManager.resetWithType(customKeyboardType);
      
      // Register controller with type
      KeyboardManager.setCurrentControllerWithType(widget.controller, customKeyboardType);
      
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
      // Reverse focus animation
      _focusAnimationController.reverse();
      
      // Unregister this controller
      KeyboardManager.clearCurrentController();
      
      // Hide custom keyboard if no other field is focused
      Future.delayed(const Duration(milliseconds: 100), () {
        if (FocusManager.instance.primaryFocus == null) {
          KeyboardManager.hide();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: AnimatedBuilder(
        animation: _focusAnimationController,
        builder: (context, child) {
          return TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            showCursor: true,
            enableInteractiveSelection: false,
            readOnly: true,
            keyboardType: TextInputType.none, // Disable system keyboard
            validator: widget.validator,
            onChanged: widget.onChanged,
            decoration: widget.decoration ?? InputDecoration(
              hintText: widget.hintText,
              labelText: widget.labelText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _borderColorAnimation.value ?? Colors.blue.shade400,
                  width: 2.5,
                ),
              ),
              filled: true,
              fillColor: _focusNode.hasFocus 
                  ? Colors.blue.shade50 
                  : Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}