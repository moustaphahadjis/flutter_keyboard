import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_custom_keyboard/src/state/keyboard_state_manager.dart';
import 'package:flutter_custom_keyboard/src/widgets/keyboard_scaffold.dart';

/// An adaptive text field that automatically handles keyboard type switching
/// and provides built-in UI for users to select different input types.
/// 
/// This widget eliminates the need to manually handle keyboard type logic
/// in every input field by providing a complete solution out of the box.
/// 
/// Example usage:
/// ```dart
/// AdaptiveTextField(
///   controller: _controller,
///   availableTypes: [
///     TextInputType.text,
///     TextInputType.number,
///     TextInputType.emailAddress,
///   ],
/// )
/// ```
class AdaptiveTextField extends StatefulWidget {
  /// Controls the text being edited in this text field.
  final TextEditingController controller;
  
  /// List of available input types that users can select from.
  /// If null or empty, defaults to [TextInputType.text].
  final List<TextInputType>? availableTypes;
  
  /// Initial input type. If not specified, uses the first type from availableTypes.
  final TextInputType? initialType;
  
  /// Whether to show the input type selector above the field.
  /// Defaults to true if more than one type is available.
  final bool? showTypeSelector;
  
  /// Whether to obscure the text being edited (e.g., for passwords).
  final bool obscureText;
  
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
  
  /// Called when the input type changes.
  final Function(TextInputType)? onTypeChanged;
  
  /// Custom labels for each input type. If not provided, uses default labels.
  final Map<TextInputType, String>? customLabels;
  
  /// Optional input formatters to apply to the text input.
  /// 
  /// These formatters will be applied by the custom keyboard when
  /// processing text input, allowing for validation and formatting
  /// such as length limits or character filtering.
  final List<TextInputFormatter>? inputFormatters;

  const AdaptiveTextField({
    super.key,
    required this.controller,
    this.availableTypes,
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
    this.inputFormatters,
  });

  @override
  State<AdaptiveTextField> createState() => _AdaptiveTextFieldState();
}

class _AdaptiveTextFieldState extends State<AdaptiveTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _focusAnimationController;
  late Animation<Color?> _borderColorAnimation;
  late TextInputType _currentType;
  late List<TextInputType> _availableTypes;

  @override
  void initState() {
    super.initState();
    
    // Initialize available types
    _availableTypes = widget.availableTypes?.isNotEmpty == true 
        ? widget.availableTypes! 
        : [TextInputType.text];
    
    // Initialize current type
    _currentType = widget.initialType ?? _availableTypes.first;
    
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
      // Convert TextInputType to CustomKeyboardType
      final customKeyboardType = KeyboardStateManager.textInputTypeToCustomKeyboardType(_currentType);
      
      // Set keyboard type first, before showing
      KeyboardManager.resetWithType(customKeyboardType);
      
      // Register controller with type and formatters
      KeyboardManager.setCurrentControllerWithType(widget.controller, customKeyboardType, widget.inputFormatters);
      
      // Start focus animation
      _focusAnimationController.forward();
      
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

  void _changeInputType(TextInputType newType) {
    setState(() {
      _currentType = newType;
      // Clear the field when changing input type for better UX
      widget.controller.clear();
      
      // Hide keyboard if currently visible to refresh the layout
      if (_focusNode.hasFocus) {
        KeyboardManager.hide();
        Future.delayed(const Duration(milliseconds: 100), () {
          _focusNode.requestFocus();
        });
      }
    });
    
    // Notify parent of type change
    widget.onTypeChanged?.call(newType);
  }

  String _getDefaultLabel(TextInputType type) {
    if (widget.customLabels?.containsKey(type) == true) {
      return widget.customLabels![type]!;
    }
    
    switch (type) {
      case TextInputType.number:
        return 'Phone Number';
      case TextInputType.emailAddress:
        return 'Email Address';
      case TextInputType.url:
        return 'Website URL';
      case TextInputType.text:
      default:
        return 'Text Input';
    }
  }

  String _getDefaultHint(TextInputType type) {
    switch (type) {
      case TextInputType.number:
        return 'Enter phone number';
      case TextInputType.emailAddress:
        return 'Enter email address';
      case TextInputType.url:
        return 'Enter website URL';
      case TextInputType.text:
      default:
        return 'Enter text';
    }
  }

  IconData _getDefaultIcon(TextInputType type) {
    switch (type) {
      case TextInputType.number:
        return Icons.phone_outlined;
      case TextInputType.emailAddress:
        return Icons.email_outlined;
      case TextInputType.url:
        return Icons.link_outlined;
      case TextInputType.text:
      default:
        return Icons.text_fields_outlined;
    }
  }

  String _getChipLabel(TextInputType type) {
    switch (type) {
      case TextInputType.number:
        return 'Number';
      case TextInputType.emailAddress:
        return 'Email';
      case TextInputType.url:
        return 'URL';
      case TextInputType.text:
      default:
        return 'Text';
    }
  }

  Widget _buildTypeSelector() {
    if (_availableTypes.length <= 1) return const SizedBox.shrink();
    
    final shouldShow = widget.showTypeSelector ?? _availableTypes.length > 1;
    if (!shouldShow) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Input Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _availableTypes.map((type) {
            final isSelected = _currentType == type;
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getDefaultIcon(type),
                    size: 14,
                    color: isSelected ? Colors.white : Colors.blue.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(_getChipLabel(type)),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _changeInputType(type);
                }
              },
              selectedColor: Colors.blue.shade600,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.blue.shade600,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTypeSelector(),
        GestureDetector(
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
                keyboardType: TextInputType.none, // Always disable system keyboard
                validator: widget.validator,
                onChanged: widget.onChanged,
                decoration: widget.decoration ?? InputDecoration(
                  labelText: _getDefaultLabel(_currentType),
                  hintText: _getDefaultHint(_currentType),
                  prefixIcon: Icon(_getDefaultIcon(_currentType)),
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
        ),
      ],
    );
  }
}