import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_custom_keyboard/src/layouts/keyboard_layouts.dart';
import 'package:flutter_custom_keyboard/src/models/keyboard_models.dart';

class KeyboardStateManager extends ChangeNotifier {
  KeyboardState _state = const KeyboardState(
    currentLayout: KeyboardLayout.qwerty,
    shiftState: ShiftState.none,
  );

  KeyboardState get state => _state;
  
  KeyboardLayout get currentLayout => _state.currentLayout;
  ShiftState get shiftState => _state.shiftState;
  bool get isUpperCase => _state.isUpperCase;
  CustomKeyboardType get keyboardType => _state.keyboardType;

  void switchLayout(KeyboardLayout newLayout) {
    _state = _state.copyWith(
      currentLayout: newLayout,
      shiftState: ShiftState.none, // Reset shift when switching layouts
    );
    notifyListeners();
  }

  void handleLayoutSwitchKey(String switchValue) {
    final newLayout = KeyboardLayouts.getNextLayout(_state.currentLayout, switchValue);
    switchLayout(newLayout);
  }

  void handleShiftKey() {
    switch (_state.shiftState) {
      case ShiftState.none:
        // First press: single shift
        _state = _state.copyWith(shiftState: ShiftState.single);
        break;
      case ShiftState.single:
        // Second press (double tap): caps lock
        _state = _state.copyWith(shiftState: ShiftState.capsLock);
        break;
      case ShiftState.capsLock:
        // Third press: back to normal
        _state = _state.copyWith(shiftState: ShiftState.none);
        break;
    }
    notifyListeners();
  }

  void resetShift() {
    if (_state.shiftState == ShiftState.single) {
      _state = _state.copyWith(shiftState: ShiftState.none);
      notifyListeners();
    }
  }

  void setShiftPressed(bool isPressed) {
    _state = _state.copyWith(isShiftPressed: isPressed);
    notifyListeners();
  }

  String getKeyValue(KeyData keyData) {
    switch (keyData.type) {
      case KeyType.letter:
        if (_state.isUpperCase) {
          return keyData.shiftValue ?? keyData.value.toUpperCase();
        }
        return keyData.value;
      case KeyType.number:
      case KeyType.special:
        return keyData.value;
      case KeyType.space:
        return ' ';
      default:
        return keyData.value;
    }
  }

  bool isShiftActive() {
    return _state.shiftState != ShiftState.none || _state.isShiftPressed;
  }

  void setKeyboardType(CustomKeyboardType type) {
    final initialLayout = _getInitialLayoutForType(type);
    _state = _state.copyWith(
      keyboardType: type,
      currentLayout: initialLayout,
      shiftState: ShiftState.none,
    );
    notifyListeners();
  }

  KeyboardLayout _getInitialLayoutForType(CustomKeyboardType type) {
    switch (type) {
      case CustomKeyboardType.number:
      case CustomKeyboardType.phone:
        return KeyboardLayout.numericPure; // Use pure numeric layout for number inputs
      case CustomKeyboardType.decimal:
        return KeyboardLayout.numericDecimal; // Use decimal-optimized layout for decimal inputs
      case CustomKeyboardType.text:
      case CustomKeyboardType.email:
      case CustomKeyboardType.url:
        return KeyboardLayout.qwerty;
    }
  }

  void reset() {
    _state = const KeyboardState(
      currentLayout: KeyboardLayout.qwerty,
      shiftState: ShiftState.none,
      keyboardType: CustomKeyboardType.text,
    );
    notifyListeners();
  }

  void resetWithType(CustomKeyboardType type) {
    final initialLayout = _getInitialLayoutForType(type);
    _state = KeyboardState(
      currentLayout: initialLayout,
      shiftState: ShiftState.none,
      keyboardType: type,
    );
    notifyListeners();
  }

  static CustomKeyboardType textInputTypeToCustomKeyboardType(TextInputType textInputType) {
    if (textInputType == TextInputType.number) {
      return CustomKeyboardType.number;
    } else if (textInputType == TextInputType.phone) {
      return CustomKeyboardType.phone;
    } else if (textInputType == TextInputType.emailAddress) {
      return CustomKeyboardType.email;
    } else if (textInputType == TextInputType.url) {
      return CustomKeyboardType.url;
    } else if (textInputType.runtimeType.toString().contains('numberWithOptions')) {
      return CustomKeyboardType.decimal;
    } else {
      return CustomKeyboardType.text;
    }
  }
}