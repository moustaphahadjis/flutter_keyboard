import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_custom_keyboard/src/state/keyboard_state_manager.dart';
import 'package:flutter_custom_keyboard/src/widgets/keyboard_scaffold.dart';

/// A custom text field widget that integrates with the custom keyboard.
/// 
/// This is a drop-in replacement for [TextField] that automatically
/// shows the custom keyboard when focused and suppresses the system keyboard.
/// It provides all the standard text field functionality while seamlessly
/// integrating with the custom keyboard system.
/// 
/// Example usage:
/// ```dart
/// CustomTextField(
///   controller: _controller,
///   labelText: 'Email',
///   hintText: 'Enter your email address',
///   keyboardType: TextInputType.emailAddress,
///   prefixIcon: Icon(Icons.email),
/// )
/// ```
class CustomTextField extends StatefulWidget {
  /// Controls the text being edited in this text field.
  /// 
  /// This controller is used to read and modify the text content,
  /// and is automatically integrated with the custom keyboard.
  final TextEditingController controller;
  
  /// Text that appears in the text field when it's empty.
  /// 
  /// This provides a hint to users about what kind of input is expected.
  final String? hintText;
  
  /// Whether to obscure the text being edited (e.g., for passwords).
  /// 
  /// When true, the text field will show dots or asterisks instead
  /// of the actual characters. Defaults to false.
  final bool obscureText;
  
  /// The type of information for which to optimize the text input control.
  /// 
  /// This hint affects which keyboard layout is initially shown,
  /// though the custom keyboard will override the system keyboard.
  final TextInputType keyboardType;
  
  /// Optional text that describes the input field.
  /// 
  /// This label will appear above the text field and helps users
  /// understand what information should be entered.
  final String? labelText;
  
  /// An icon that appears before the editable part of the text field.
  /// 
  /// This is typically used to indicate the type of input expected,
  /// such as an email icon for email fields.
  final Widget? prefixIcon;
  
  /// An icon that appears after the editable part of the text field.
  /// 
  /// This is often used for actions like showing/hiding password text
  /// or clearing the field contents.
  final Widget? suffixIcon;
  
  /// Called when the user indicates that they are done editing the text.
  /// 
  /// This is typically triggered by pressing the Enter key on the keyboard.
  final Function(String)? onSubmitted;
  
  /// The maximum number of lines for the text field.
  /// 
  /// If null, there is no limit to the number of lines.
  /// If 1 (the default), the text field will be single-line.
  final int? maxLines;
  
  /// Whether the text field is enabled for user interaction.
  /// 
  /// When false, the text field will be grayed out and unresponsive
  /// to user input. Defaults to true.
  final bool enabled;
  
  /// Optional input formatters to apply to the text input.
  /// 
  /// These formatters will be applied by the custom keyboard when
  /// processing text input, allowing for validation and formatting
  /// such as length limits or character filtering.
  final List<TextInputFormatter>? inputFormatters;
  
  /// The decoration to show around the text field.
  /// 
  /// By default, creates an outlined input decoration with rounded corners.
  /// If provided, this decoration will override the default styling.
  final InputDecoration? decoration;

  /// Creates a [CustomTextField] with the given properties.
  /// 
  /// The [controller] parameter is required and must not be null.
  /// All other parameters are optional and have sensible defaults.
  const CustomTextField({
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
    this.inputFormatters,
    this.decoration,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
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
      
      // Register controller with type and formatters
      KeyboardManager.setCurrentControllerWithType(widget.controller, customKeyboardType, widget.inputFormatters);
      
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
          return TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            showCursor: true,
            enableInteractiveSelection: false,
            readOnly: true,
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