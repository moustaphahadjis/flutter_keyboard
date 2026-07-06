import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_custom_keyboard/src/models/keyboard_models.dart';
import 'package:flutter_custom_keyboard/src/widgets/custom_keyboard.dart';

/// A scaffold widget that provides global keyboard management functionality.
/// 
/// This widget should wrap your entire screen or app to enable custom keyboard
/// functionality. It automatically handles keyboard display, focus management,
/// and scrolling to keep focused text fields visible.
/// 
/// Example usage:
/// ```dart
/// MaterialApp(
///   home: KeyboardScaffold(
///     child: MyHomePage(),
///   ),
/// )
/// ```
class KeyboardScaffold extends StatefulWidget {
  /// The main content widget of your screen.
  /// 
  /// This will be the primary content that users interact with,
  /// while the keyboard appears overlaid at the bottom when needed.
  final Widget child;

  /// Creates a [KeyboardScaffold] with the given [child].
  /// 
  /// The [child] parameter is required and represents the main
  /// content of your screen that will be displayed above the keyboard.
  const KeyboardScaffold({
    super.key,
    required this.child,
  });

  @override
  State<KeyboardScaffold> createState() => _KeyboardScaffoldState();
}

class _KeyboardScaffoldState extends State<KeyboardScaffold>
    with TickerProviderStateMixin {
  bool _keyboardVisible = false;
  late AnimationController _keyboardAnimationController;
  late Animation<Offset> _keyboardSlideAnimation;
  late Animation<double> _keyboardFadeAnimation;
  
  static _KeyboardScaffoldState? _instance;
  static final List<_KeyboardScaffoldState> _instanceRegistry = [];
  static TextEditingController? _currentController;
  static CustomKeyboardType? _desiredKeyboardType;
  static List<TextInputFormatter>? _currentFormatters;

  @override
  void initState() {
    super.initState();
    
    // Register this instance
    _instanceRegistry.add(this);
    _instance = this;
    debugPrint('🔧 KeyboardScaffold: Instance registered - ${hashCode} (Registry size: ${_instanceRegistry.length})');
    
    // Initialize keyboard animation
    _keyboardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _keyboardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start below screen
      end: const Offset(0, 0),   // End at normal position
    ).animate(CurvedAnimation(
      parent: _keyboardAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _keyboardFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _keyboardAnimationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure this instance is set as the active one when dependencies change
    if (_instance != this) {
      _instance = this;
      
      // Make sure this instance is in the registry
      if (!_instanceRegistry.contains(this)) {
        _instanceRegistry.add(this);
      }
    }
  }

  @override
  void dispose() {
    _keyboardAnimationController.dispose();
    
    // Remove from registry
    _instanceRegistry.remove(this);
    debugPrint('🗑️ KeyboardScaffold: Instance disposed - ${hashCode} (Registry size: ${_instanceRegistry.length})');
    
    // If this was the current instance, try to find another one
    if (_instance == this) {
      if (_instanceRegistry.isNotEmpty) {
        _instance = _instanceRegistry.last;
        debugPrint('🔄 KeyboardScaffold: Switched to another instance - ${_instance!.hashCode}');
      } else {
        _instance = null;
        _currentController = null;
        _desiredKeyboardType = null;
        _currentFormatters = null;
        debugPrint('🧹 KeyboardScaffold: No more instances, cleared static state');
      }
    }
    
    super.dispose();
  }

  static void showKeyboard() {
    debugPrint('📞 KeyboardScaffold: showKeyboard() called - instance: ${_instance?.hashCode}, registry: ${_instanceRegistry.length}');
    
    if (_instance == null) {
      debugPrint('❌ KeyboardScaffold: No instance available');
      // Try to find an available instance in the registry
      if (_instanceRegistry.isNotEmpty) {
        _instance = _instanceRegistry.last;
        debugPrint('✅ KeyboardScaffold: Recovered instance from registry - ${_instance!.hashCode}');
        _instance!._showKeyboard();
        return;
      }
      
      debugPrint('⏳ KeyboardScaffold: No instances in registry, using post-frame callback');
      // Use a post-frame callback to try again after the widget tree settles
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_instance != null) {
          debugPrint('✅ KeyboardScaffold: Instance available after callback - ${_instance!.hashCode}');
          _instance!._showKeyboard();
        } else if (_instanceRegistry.isNotEmpty) {
          _instance = _instanceRegistry.last;
          debugPrint('✅ KeyboardScaffold: Found instance in registry after callback - ${_instance!.hashCode}');
          _instance!._showKeyboard();
        } else {
          debugPrint('💥 KeyboardScaffold: Still no instance after post-frame callback');
        }
      });
      return;
    }
    
    // Check if the current instance is still valid (not disposed)
    if (!_instanceRegistry.contains(_instance)) {
      debugPrint('⚠️ KeyboardScaffold: Current instance not in registry');
      if (_instanceRegistry.isNotEmpty) {
        _instance = _instanceRegistry.last;
        debugPrint('🔄 KeyboardScaffold: Switched to valid instance - ${_instance!.hashCode}');
      } else {
        debugPrint('❌ KeyboardScaffold: No valid instances available');
        return;
      }
    }
    
    debugPrint('📱 KeyboardScaffold: Calling _showKeyboard() on instance ${_instance!.hashCode}');
    _instance!._showKeyboard();
  }
  

  static void hideKeyboard() {
    if (_instance == null && _instanceRegistry.isNotEmpty) {
      _instance = _instanceRegistry.last;
    }
    _instance?._hideKeyboard();
  }

  static void scrollToFocusedField() {
    _instance?._scrollToFocus(_instance!.context);
  }
  
  static void setCurrentController(TextEditingController controller) {
    _currentController = controller;
  }
  
  static void setCurrentControllerWithType(TextEditingController controller, CustomKeyboardType type, [List<TextInputFormatter>? formatters]) {
    // Store the desired keyboard type for when the keyboard is shown
    _desiredKeyboardType = type;
    _currentController = controller;
    _currentFormatters = formatters;
    
    // If keyboard is already visible, apply the type immediately
    CustomKeyboard.resetKeyboardWithType(type);
  }
  
  static void clearCurrentController() {
    _currentController = null;
    _desiredKeyboardType = null;
    _currentFormatters = null;
  }
  
  void _clearCurrentController() {
    _currentController = null;
    _currentFormatters = null;
  }

  void _showKeyboard() {
    debugPrint('🎬 KeyboardScaffold: _showKeyboard() called - setting visible = true');
    setState(() {
      _keyboardVisible = true;
    });
    
    // Apply the desired keyboard type if one was set
    if (_desiredKeyboardType != null) {
      debugPrint('🎯 KeyboardScaffold: Applying desired keyboard type: $_desiredKeyboardType');
      // Small delay to ensure keyboard widget is initialized
      Future.delayed(const Duration(milliseconds: 50), () {
        CustomKeyboard.resetKeyboardWithType(_desiredKeyboardType!);
      });
    }
    
    // Start keyboard slide-up animation
    debugPrint('🎬 KeyboardScaffold: Starting keyboard animation');
    _keyboardAnimationController.forward();
    
    // Small delay to ensure keyboard is rendered before scrolling
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        _scrollToFocus(context);
      }
    });
  }

  void _hideKeyboard() {
    // Start keyboard slide-down animation
    _keyboardAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _keyboardVisible = false;
        });
      }
    });
  }

  void _scrollToFocus(BuildContext context) {
    // Try to find the primary scrollable in the widget tree
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable != null) {
      final focusedNode = FocusManager.instance.primaryFocus;
      if (focusedNode?.context != null) {
        // Get the RenderBox of the focused field
        final renderBox = focusedNode!.context!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          // Get the position of the focused field relative to the screen
          final position = renderBox.localToGlobal(Offset.zero);
          final fieldHeight = renderBox.size.height;
          final mediaQuery = MediaQuery.of(context);
          final screenHeight = mediaQuery.size.height;
          final screenWidth = mediaQuery.size.width;
          final isLandscape = mediaQuery.orientation == Orientation.landscape;
          final shortestSide = mediaQuery.size.shortestSide;
          final isTablet = shortestSide > 600; // More reliable tablet detection
          final isWeb = screenWidth > 800;
          
          // Calculate keyboard height dynamically
          double keyboardHeight;
          if (isWeb) {
            keyboardHeight = 300;
          } else if (isLandscape && !isTablet) {
            keyboardHeight = screenHeight * 0.35; // 35% of screen height + scale down in landscape
          } else if (isTablet) {
            keyboardHeight = 320;
          } else {
            keyboardHeight = 320;
          }

          // Calculate if we need to scroll - position field exactly at keyboard edge
          final targetFieldBottom = screenHeight - keyboardHeight; // Position field bottom at keyboard top
          final currentFieldBottom = position.dy + fieldHeight;
          
          // Only scroll if field is covered by keyboard
          if (currentFieldBottom > targetFieldBottom) {
            // Calculate exact scroll amount to position field at keyboard edge
            final scrollAmount = currentFieldBottom - targetFieldBottom; // No buffer - exact positioning
            final currentOffset = scrollable.position.pixels;
            final targetOffset = currentOffset + scrollAmount;
            
            scrollable.position.animateTo(
              targetOffset.clamp(0.0, scrollable.position.maxScrollExtent),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        }
      }
    }
  }

  void _handleTextInput(String text) {
    if (_currentController != null) {
      final currentText = _currentController!.text;
      final selection = _currentController!.selection;
      
      String newText;
      TextSelection newSelection;
      
      if (selection.isValid) {
        newText = currentText.replaceRange(
          selection.start,
          selection.end,
          text,
        );
        
        newSelection = TextSelection.collapsed(
          offset: selection.start + text.length,
        );
      } else {
        // If no selection, append to end
        newText = currentText + text;
        newSelection = TextSelection.collapsed(
          offset: newText.length,
        );
      }
      
      // Apply input formatters if available
      if (_currentFormatters != null && _currentFormatters!.isNotEmpty) {
        final oldValue = TextEditingValue(
          text: currentText,
          selection: selection.isValid ? selection : TextSelection.collapsed(offset: currentText.length),
        );
        
        TextEditingValue newValue = TextEditingValue(
          text: newText,
          selection: newSelection,
        );
        
        // Apply each formatter in sequence
        for (final formatter in _currentFormatters!) {
          final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
          
          // Check if formatter rejected the input by checking various rejection patterns
          bool wasRejected = false;
          
          // Pattern 1: FilteringTextInputFormatter returns empty string when rejecting
          if (formattedValue.text.isEmpty && oldValue.text.isNotEmpty) {
            wasRejected = true;
          }
          // Pattern 2: Formatter returns exactly the old value unchanged
          else if (formattedValue.text == oldValue.text && 
                   formattedValue.selection == oldValue.selection &&
                   newValue.text != oldValue.text) {
            wasRejected = true;
          }
          // Pattern 3: Length limiting formatter - if the result is shorter than expected
          else if (newValue.text.length > oldValue.text.length && 
                   formattedValue.text.length <= oldValue.text.length &&
                   formattedValue.text == oldValue.text) {
            wasRejected = true;
          }
          
          if (wasRejected) {
            // Input was rejected, don't update the controller
            return;
          }
          
          newValue = formattedValue;
        }
        
        _currentController!.value = newValue;
      } else {
        // No formatters, apply directly
        _currentController!.value = TextEditingValue(
          text: newText,
          selection: newSelection,
        );
      }
    }
  }

  void _handleBackspace() {
    if (_currentController != null) {
      final currentText = _currentController!.text;
      final selection = _currentController!.selection;

      String newText;
      TextSelection newSelection;

      if (selection.isValid) {
        if (selection.start == selection.end) {
          // Single cursor position
          if (selection.start > 0) {
            newText = currentText.substring(0, selection.start - 1) +
                currentText.substring(selection.start);
            newSelection = TextSelection.collapsed(
              offset: selection.start - 1,
            );
          } else {
            // At beginning, no change
            return;
          }
        } else {
          // Text is selected, delete selection
          newText = currentText.replaceRange(
            selection.start,
            selection.end,
            '',
          );
          newSelection = TextSelection.collapsed(
            offset: selection.start,
          );
        }
      } else if (currentText.isNotEmpty) {
        // If no valid selection but text exists, remove last character
        newText = currentText.substring(0, currentText.length - 1);
        newSelection = TextSelection.collapsed(
          offset: newText.length,
        );
      } else {
        // No text to delete
        return;
      }

      // Apply input formatters if available
      if (_currentFormatters != null && _currentFormatters!.isNotEmpty) {
        final oldValue = TextEditingValue(
          text: currentText,
          selection: selection.isValid ? selection : TextSelection.collapsed(offset: currentText.length),
        );
        
        TextEditingValue newValue = TextEditingValue(
          text: newText,
          selection: newSelection,
        );
        
        // Apply each formatter in sequence
        for (final formatter in _currentFormatters!) {
          final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
          
          // Check if formatter rejected the backspace by checking various rejection patterns
          bool wasRejected = false;
          
          // Pattern 1: FilteringTextInputFormatter returns empty string when rejecting
          if (formattedValue.text.isEmpty && oldValue.text.isNotEmpty && newValue.text.isNotEmpty) {
            wasRejected = true;
          }
          // Pattern 2: Formatter returns exactly the old value unchanged
          else if (formattedValue.text == oldValue.text && 
                   formattedValue.selection == oldValue.selection &&
                   newValue.text != oldValue.text) {
            wasRejected = true;
          }
          
          if (wasRejected) {
            // Backspace was rejected, don't update the controller
            return;
          }
          
          newValue = formattedValue;
        }
        
        _currentController!.value = newValue;
      } else {
        // No formatters, apply directly
        _currentController!.value = TextEditingValue(
          text: newText,
          selection: newSelection,
        );
      }
    }
  }

  void _handleEnter() {
    final focusedNode = FocusManager.instance.primaryFocus;
    if (focusedNode != null) {
      // Try to move to next field
      focusedNode.nextFocus();
      
      // If no next field (focus didn't change), hide keyboard
      if (FocusManager.instance.primaryFocus == focusedNode) {
        focusedNode.unfocus();
        _hideKeyboard();
        _clearCurrentController();
      }
      // If focus moved to next field, update the current controller
      else if (FocusManager.instance.primaryFocus != null) {
        // Small delay to allow the new field to register its controller
        Future.delayed(const Duration(milliseconds: 100), () {
          // The new field's onFocusChange will handle setting the new controller
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final shortestSide = mediaQuery.size.shortestSide;
    final isTablet = shortestSide > 600; // More reliable tablet detection
    final isWeb = screenWidth > 800;
    
    // Calculate keyboard height based on orientation and platform
    double keyboardHeight;
    if (isWeb) {
      keyboardHeight = 300; // Larger on web
    } else if (isLandscape && !isTablet) {
      keyboardHeight = screenHeight * 0.42; // 35% of screen height + scale down in landscape
    } else if (isTablet) {
      keyboardHeight = 320;
    } else {
      keyboardHeight = 280;
    }
    
    return PopScope(
      canPop: !_keyboardVisible, // Prevent back navigation when keyboard is open
      onPopInvoked: (didPop) {
        // If keyboard is visible, close it instead of popping the route
        if (_keyboardVisible && !didPop) {
          final currentFocus = FocusManager.instance.primaryFocus;
          if (currentFocus != null && currentFocus.hasFocus) {
            currentFocus.unfocus();
          }
          _hideKeyboard();
          _clearCurrentController();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
        children: [
          // Main content area
          Positioned.fill(
            bottom: _keyboardVisible ? keyboardHeight : 0,
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // Dismiss keyboard immediately when tapping in content area
                  if (_keyboardVisible) {
                    final currentFocus = FocusManager.instance.primaryFocus;
                    if (currentFocus != null && currentFocus.hasFocus) {
                      currentFocus.unfocus();
                    }
                    _hideKeyboard();
                    _clearCurrentController();
                  }
                },
                onTapDown: (_) {
                  // More responsive - start dismissal on tap down for faster feedback
                  if (_keyboardVisible) {
                    final currentFocus = FocusManager.instance.primaryFocus;
                    if (currentFocus != null && currentFocus.hasFocus) {
                      currentFocus.unfocus();
                      _hideKeyboard();
                      _clearCurrentController();
                    }
                  }
                },
                child: widget.child,
              ),
            ),
          ),
          // Keyboard area
          if (_keyboardVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: _keyboardSlideAnimation,
                child: FadeTransition(
                  opacity: _keyboardFadeAnimation,
                  child: GestureDetector(
                    onTap: () {
                      // Prevent taps on keyboard from closing it
                    },
                    child: Container(
                      height: keyboardHeight,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF8F9FA),
                            Color(0xFFE9ECEF),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, -4),
                            blurRadius: 16,
                          ),
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, -2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: CustomKeyboard(
                        onTextInput: _handleTextInput,
                        onBackspace: _handleBackspace,
                        onEnter: _handleEnter,
                        height: keyboardHeight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }
}

// Global functions to control keyboard
class KeyboardManager {
  static void show() {
    _KeyboardScaffoldState.showKeyboard();
  }

  static void hide() {
    _KeyboardScaffoldState.hideKeyboard();
  }

  static void scrollToField() {
    _KeyboardScaffoldState.scrollToFocusedField();
  }
  
  static void setCurrentController(TextEditingController controller) {
    _KeyboardScaffoldState.setCurrentController(controller);
  }
  
  static void setCurrentControllerWithType(TextEditingController controller, CustomKeyboardType type, [List<TextInputFormatter>? formatters]) {
    _KeyboardScaffoldState.setCurrentControllerWithType(controller, type, formatters);
  }
  
  static void clearCurrentController() {
    _KeyboardScaffoldState.clearCurrentController();
  }
  
  static void reset() {
    CustomKeyboard.resetKeyboard();
  }
  
  static void resetWithType(CustomKeyboardType type) {
    CustomKeyboard.resetKeyboardWithType(type);
  }
}