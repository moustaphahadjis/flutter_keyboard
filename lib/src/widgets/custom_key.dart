import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_custom_keyboard/src/models/keyboard_models.dart';

class CustomKey extends StatefulWidget {
  final KeyData keyData;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isUpperCase;
  final bool isPressed;
  final double? width;
  final double? height;
  final bool handleGestures;

  const CustomKey({
    super.key,
    required this.keyData,
    required this.onTap,
    this.onLongPress,
    this.isUpperCase = false,
    this.isPressed = false,
    this.width,
    this.height,
    this.handleGestures = true,
  });

  @override
  State<CustomKey> createState() => _CustomKeyState();
}

class _CustomKeyState extends State<CustomKey>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _tapFlashController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isPressed = false;
  bool _showTapFlash = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 40),
      vsync: this,
    );
    
    _tapFlashController = AnimationController(
      duration: const Duration(milliseconds: 60),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tapFlashController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    // Visual feedback only - action triggered by onTap or parent GestureDetector
    setState(() {
      _isPressed = true;
      _showTapFlash = true;
    });
    
    // Skip slow ripple animation for speed
    _tapFlashController.reset();
    _tapFlashController.forward();
    
    // Minimal haptic feedback - only for special keys
    if (widget.keyData.type == KeyType.backspace || 
        widget.keyData.type == KeyType.enter) {
      HapticFeedback.selectionClick();
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    
    // Ultra-fast feedback reset
    Future.delayed(const Duration(milliseconds: 60), () {
      if (mounted) {
        setState(() {
          _showTapFlash = false;
        });
      }
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
      _showTapFlash = false;
    });
    _tapFlashController.reset();
  }

  String _getDisplayText() {
    switch (widget.keyData.type) {
      case KeyType.letter:
        String text = widget.keyData.value;
        if (widget.isUpperCase) {
          return widget.keyData.shiftValue ?? text.toUpperCase();
        }
        return text;
      case KeyType.backspace:
        return '⌫';
      case KeyType.enter:
        return '↵';
      case KeyType.shift:
        return '⇧';
      case KeyType.space:
        return 'space';
      case KeyType.layoutSwitch:
        return widget.keyData.displayText ?? widget.keyData.value;
      default:
        return widget.keyData.displayValue;
    }
  }

  Color _getKeyColor() {
    if (widget.keyData.type == KeyType.shift && widget.isPressed) {
      return const Color(0xFF4A90E2);
    }
    switch (widget.keyData.type) {
      case KeyType.letter:
      case KeyType.number:
      case KeyType.special:
        return Colors.white;
      case KeyType.space:
        return const Color(0xFFF8F9FA);
      case KeyType.backspace:
      case KeyType.enter:
        return const Color(0xFF6C757D);
      case KeyType.shift:
        return widget.isPressed ? const Color(0xFF4A90E2) : const Color(0xFFE9ECEF);
      case KeyType.layoutSwitch:
        return const Color(0xFFE9ECEF);
      default:
        return Colors.white;
    }
  }
  
  Color _getPressedColor() {
    if (widget.keyData.type == KeyType.shift && widget.isPressed) {
      return const Color(0xFF2563EB);
    }
    switch (widget.keyData.type) {
      case KeyType.letter:
      case KeyType.number:
      case KeyType.special:
        return const Color(0xFF3B82F6);
      case KeyType.space:
        return const Color(0xFF6B7280);
      case KeyType.backspace:
      case KeyType.enter:
        return const Color(0xFF374151);
      case KeyType.shift:
      case KeyType.layoutSwitch:
        return const Color(0xFF9CA3AF);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  Color _getTextColor() {
    switch (widget.keyData.type) {
      case KeyType.backspace:
      case KeyType.enter:
        return Colors.white;
      case KeyType.shift:
        return widget.isPressed ? Colors.white : const Color(0xFF495057);
      case KeyType.layoutSwitch:
        return const Color(0xFF495057);
      default:
        return const Color(0xFF212529);
    }
  }
  
  Color _getPressedTextColor() {
    switch (widget.keyData.type) {
      case KeyType.backspace:
      case KeyType.enter:
        return Colors.white;
      case KeyType.shift:
      case KeyType.layoutSwitch:
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  double _getFontSize() {
    switch (widget.keyData.type) {
      case KeyType.backspace:
      case KeyType.enter:
      case KeyType.shift:
        return 18;
      case KeyType.space:
        return 14;
      case KeyType.layoutSwitch:
        return 12;
      default:
        return 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width ?? double.infinity,
            height: widget.height ?? 52,
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
            child: widget.handleGestures
                ? GestureDetector(
                    onTap: widget.onTap,
                    onTapDown: _onTapDown,
                    onTapUp: _onTapUp,
                    onTapCancel: _onTapCancel,
                    onLongPress: widget.onLongPress,
                    behavior: HitTestBehavior.opaque,
                    child: _buildKeyContent(),
                  )
                : _buildKeyContent(),
          ),
        );
      },
    );
  }

  Widget _buildKeyContent() {
    return Stack(
      children: [
        // Main key container - instant response
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: _isPressed ? Alignment.bottomCenter : Alignment.topCenter,
              end: _isPressed ? Alignment.topCenter : Alignment.bottomCenter,
              colors: _isPressed ? [
                _getPressedColor(),
                Color.fromRGBO(_getPressedColor().red, _getPressedColor().green, _getPressedColor().blue, 0.8),
              ] : [
                _getKeyColor(),
                Color.fromRGBO(_getKeyColor().red, _getKeyColor().green, _getKeyColor().blue, 0.85),
              ],
            ),
            border: Border.all(
              color: _isPressed 
                  ? const Color.fromRGBO(33, 150, 243, 0.6)
                  : const Color.fromRGBO(158, 158, 158, 0.2),
              width: _isPressed ? 2.0 : 0.5,
            ),
            boxShadow: _isPressed ? [
              const BoxShadow(
                color: Color.fromRGBO(33, 150, 243, 0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: Offset(0, 2),
              ),
              const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(0, 1),
              ),
            ] : [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.15),
                blurRadius: _elevationAnimation.value * 2,
                spreadRadius: 0,
                offset: Offset(0, _elevationAnimation.value),
              ),
            ],
          ),
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: _getFontSize(),
                fontWeight: _isPressed ? FontWeight.w700 : FontWeight.w600,
                color: _isPressed ? _getPressedTextColor() : _getTextColor(),
                letterSpacing: 0.3,
                shadows: _isPressed
                    ? [
                        const Shadow(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : [
                        const Shadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 1,
                          offset: Offset(0, 0.5),
                        ),
                      ],
              ),
              child: Text(_getDisplayText()),
            ),
          ),
        ),
        // Instant flash effect
        if (_isPressed)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromRGBO(255, 255, 255, 0.4),
              ),
            ),
          ),
        // Simple tap flash - no animation
        if (_showTapFlash)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromRGBO(33, 150, 243, 0.2),
                border: Border.all(
                  color: const Color.fromRGBO(33, 150, 243, 0.4),
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}