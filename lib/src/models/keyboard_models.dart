enum KeyboardLayout {
  qwerty,
  numeric,
  numericPure, // Pure numeric layout with only numbers and decimal point
  numericDecimal, // Numeric layout optimized for decimal input
  symbols,
}

enum CustomKeyboardType {
  text,        // Default QWERTY keyboard
  number,      // Numeric keypad only
  phone,       // Phone number layout
  email,       // QWERTY with @ and . easily accessible
  url,         // QWERTY with / and . easily accessible
  decimal,     // Numeric with decimal point
}

enum KeyType {
  letter,
  number,
  special,
  space,
  backspace,
  enter,
  shift,
  capsLock,
  layoutSwitch,
}

enum ShiftState {
  none,
  single,
  capsLock,
}

class KeyData {
  final String value;
  final String? shiftValue;
  final KeyType type;
  final double? flex;
  final String? displayText;

  const KeyData({
    required this.value,
    this.shiftValue,
    required this.type,
    this.flex,
    this.displayText,
  });

  String get displayValue {
    return displayText ?? value;
  }
}

class KeyboardState {
  final KeyboardLayout currentLayout;
  final ShiftState shiftState;
  final bool isShiftPressed;
  final CustomKeyboardType keyboardType;

  const KeyboardState({
    required this.currentLayout,
    required this.shiftState,
    this.isShiftPressed = false,
    this.keyboardType = CustomKeyboardType.text,
  });

  KeyboardState copyWith({
    KeyboardLayout? currentLayout,
    ShiftState? shiftState,
    bool? isShiftPressed,
    CustomKeyboardType? keyboardType,
  }) {
    return KeyboardState(
      currentLayout: currentLayout ?? this.currentLayout,
      shiftState: shiftState ?? this.shiftState,
      isShiftPressed: isShiftPressed ?? this.isShiftPressed,
      keyboardType: keyboardType ?? this.keyboardType,
    );
  }

  bool get isUpperCase {
    return shiftState == ShiftState.single || 
           shiftState == ShiftState.capsLock ||
           isShiftPressed;
  }
}