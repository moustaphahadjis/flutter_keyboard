import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_custom_keyboard/src/layouts/keyboard_layouts.dart';
import 'package:flutter_custom_keyboard/src/models/keyboard_models.dart';
import 'package:flutter_custom_keyboard/src/state/keyboard_state_manager.dart';
import 'package:flutter_custom_keyboard/src/widgets/custom_key.dart';

class CustomKeyboard extends StatefulWidget {
  final Function(String) onTextInput;
  final VoidCallback onBackspace;
  final VoidCallback? onEnter;
  final double? height;
  final Color? backgroundColor;

  const CustomKeyboard({
    super.key,
    required this.onTextInput,
    required this.onBackspace,
    this.onEnter,
    this.height,
    this.backgroundColor,
  });

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
  
  static void resetKeyboard() {
    _CustomKeyboardState._resetKeyboard();
  }
  
  static void resetKeyboardWithType(CustomKeyboardType type) {
    _CustomKeyboardState._resetKeyboardWithType(type);
  }
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  late KeyboardStateManager _stateManager;
  bool _isBackspacePressed = false;
  
  static _CustomKeyboardState? _instance;
  
  @override
  void initState() {
    super.initState();
    _instance = this;
    _stateManager = KeyboardStateManager();
  }

  @override
  void dispose() {
    _stateManager.dispose();
    _instance = null;
    super.dispose();
  }
  
  static void _resetKeyboard() {
    _instance?._stateManager.reset();
  }
  
  static void _resetKeyboardWithType(CustomKeyboardType type) {
    if (_instance != null) {
      _instance!._stateManager.resetWithType(type);
    }
  }

  void _startBackspaceRepeating() {
    if (_isBackspacePressed) return;
    
    _isBackspacePressed = true;
    widget.onBackspace();
    
    // Start repeating after shorter initial delay
    Future.delayed(const Duration(milliseconds: 400), () {
      _continueBackspaceRepeating();
    });
  }

  void _continueBackspaceRepeating() {
    if (!_isBackspacePressed) return;
    
    widget.onBackspace();
    // Faster continuous deletion
    Future.delayed(const Duration(milliseconds: 50), () {
      _continueBackspaceRepeating();
    });
  }

  void _stopBackspaceRepeating() {
    _isBackspacePressed = false;
  }

  double _getKeyHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    // final screenHeight = mediaQuery.size.height;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final shortestSide = mediaQuery.size.shortestSide;
    final isTablet = shortestSide > 600; // More reliable tablet detection
    final isWeb = screenWidth > 800;
    if (isWeb) {
      return 60;
    } else if (isLandscape && !isTablet) {
      return 40; // Ultra compact key height in landscape
    } else if (isTablet) {
      return 64;
    } else {
      return 56;
    }

  }

  void _handleKeyPress(KeyData keyData) {
    // ULTRA-FAST processing - no delays whatsoever
    switch (keyData.type) {
      case KeyType.letter:
      case KeyType.number:
      case KeyType.special:
      case KeyType.space:
        // Direct value calculation and immediate input
        final value = _stateManager.getKeyValue(keyData);
        widget.onTextInput(value);
        // Reset shift state synchronously for letters only
        if (keyData.type == KeyType.letter && _stateManager.shiftState == ShiftState.single) {
          _stateManager.resetShift();
        }
        break;
      case KeyType.backspace:
        widget.onBackspace();
        break;
      case KeyType.enter:
        widget.onEnter?.call();
        break;
      case KeyType.shift:
        _stateManager.handleShiftKey();
        break;
      case KeyType.layoutSwitch:
        _stateManager.handleLayoutSwitchKey(keyData.value);
        break;
      default:
        break;
    }
  }

  Widget _buildKeyRow(List<KeyData> rowData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowData.map((keyData) {
        return Expanded(
          flex: keyData.flex?.toInt() ?? 1,
          child: keyData.type == KeyType.backspace
              ? GestureDetector(
                  onTap: () => _handleKeyPress(keyData),
                  onLongPressStart: (_) => _startBackspaceRepeating(),
                  onLongPressEnd: (_) => _stopBackspaceRepeating(),
                  onLongPressCancel: () => _stopBackspaceRepeating(),
                  behavior: HitTestBehavior.opaque,
                  child: CustomKey(
                    keyData: keyData,
                    onTap: () {}, // Empty - handled by GestureDetector
                    isUpperCase: _stateManager.isUpperCase,
                    isPressed: keyData.type == KeyType.shift && _stateManager.isShiftActive(),
                    height: _getKeyHeight(context),
                    handleGestures: false, // Parent GestureDetector handles this
                  ),
                )
              : CustomKey(
                  keyData: keyData,
                  onTap: () => _handleKeyPress(keyData),
                  isUpperCase: _stateManager.isUpperCase,
                  isPressed: keyData.type == KeyType.shift && _stateManager.isShiftActive(),
                  height: _getKeyHeight(context),
                ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // final screenWidth = mediaQuery.size.width;
    // final screenHeight = mediaQuery.size.height;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final shortestSide = mediaQuery.size.shortestSide;
    final isTablet = shortestSide > 600; // More reliable tablet detection
    
    return AnimatedBuilder(
      animation: _stateManager,
      builder: (context, child) {
        // Get current layout data inside AnimatedBuilder so it updates when layout changes
        final currentLayoutData = KeyboardLayouts.getLayoutForKeyboard(
          _stateManager.currentLayout,
        );

        // Calculate compact padding for landscape
        double horizontalPadding;
        double verticalPadding;

        if (isLandscape && !isTablet) {
          horizontalPadding = 5; // No horizontal padding in landscape
          verticalPadding = 5;   // No vertical padding in landscape
        } else if (isTablet) {
          horizontalPadding = 16;
          verticalPadding = 12;
        } else {
          horizontalPadding = 4;
          verticalPadding = 8;
        }

        final containerWidget = Container(
          height: widget.height ?? (isLandscape && !isTablet ? 200 : isTablet ? 300 : 280),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8F9FA),
                Color(0xFFE9ECEF),
                Color(0xFFDEE2E6),
              ],
              stops: [0.0, 0.7, 1.0],
            ),
            border: Border(
              top: BorderSide(
                color: Colors.grey.shade400,
                width: 0.5,
              ),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, -3),
                blurRadius: 12,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                offset: const Offset(0, -1),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: currentLayoutData.map((rowData) {
              return Expanded(
                child: _buildKeyRow(rowData),
              );
            }).toList(),
          ),
        );

        // Apply scale transformation for landscape mode to make keyboard more compact
        if (isLandscape && !isTablet) {
          return Transform.scale(
            scaleY: 1, // Scale down height only to 80% in landscape mode
            scaleX: 1.0, // Keep full width
            alignment: Alignment.bottomCenter, // Keep aligned to bottom
            child: containerWidget,
          );
        }
        
        return containerWidget;
      },
    );
  }
}