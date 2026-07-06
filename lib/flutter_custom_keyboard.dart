/// Flutter Custom Keyboard Package
/// 
/// A highly customizable Flutter keyboard widget with modern animations,
/// haptic feedback, and cross-platform support. Perfect replacement for
/// system keyboards in forms, login screens, and search fields.
/// 
/// ## Quick Start
/// 
/// 1. Wrap your app with [KeyboardScaffold]:
/// ```dart
/// MaterialApp(
///   home: KeyboardScaffold(
///     child: MyHomePage(),
///   ),
/// )
/// ```
/// 
/// 2. Use one of the smart text field widgets:
/// ```dart
/// // Adaptive field with type selector
/// AdaptiveTextField(
///   controller: _controller,
///   availableTypes: [TextInputType.text, TextInputType.number, TextInputType.emailAddress],
/// )
/// 
/// // Pre-configured smart fields
/// SmartTextField.contact(controller: _phoneController)  // Phone + Email
/// SmartTextField.general(controller: _nameController)   // Text + Number
/// SmartTextField.web(controller: _urlController)        // Text + Email + URL
/// 
/// // Traditional single-type fields
/// CustomTextField(
///   controller: _controller,
///   keyboardType: TextInputType.number, // Automatic numeric keyboard
/// )
/// ```
/// 
/// ## Features
/// 
/// - **Smart Type Detection**: Automatically shows appropriate keyboard based on input type
/// - **Adaptive UI**: Built-in type selector for multi-purpose input fields
/// - **Modern Design**: Beautiful keyboard with gradients and animations
/// - **Cross-platform**: Works on Android, iOS, and web
/// - **Multiple layouts**: QWERTY, numeric, symbols, email, and URL optimized
/// - **Zero Configuration**: Smart defaults that work out of the box
/// - **Haptic feedback**: Different vibrations for different keys
/// - **Auto-scrolling**: Keeps focused fields visible above keyboard
/// - **Drop-in replacement**: Easy migration from standard TextFields
library flutter_custom_keyboard;

// Export layouts
export 'src/layouts/keyboard_layouts.dart';

// Export models
export 'src/models/keyboard_models.dart';

// Export state management
export 'src/state/keyboard_state_manager.dart';

// Export utilities
export 'src/utils/keyboard_utils.dart';

// Export widgets
export 'src/widgets/adaptive_text_field.dart';
export 'src/widgets/custom_key.dart';
export 'src/widgets/custom_keyboard.dart';
export 'src/widgets/custom_text_field.dart';
export 'src/widgets/global_custom_text_field.dart';
export 'src/widgets/keyboard_scaffold.dart';
export 'src/widgets/smart_text_field.dart';