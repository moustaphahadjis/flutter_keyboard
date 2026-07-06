import 'package:flutter_custom_keyboard/src/models/keyboard_models.dart';

class KeyboardLayouts {
  static const List<List<KeyData>> qwertyLayout = [
    // Row 1
    [
      KeyData(value: 'q', type: KeyType.letter),
      KeyData(value: 'w', type: KeyType.letter),
      KeyData(value: 'e', type: KeyType.letter),
      KeyData(value: 'r', type: KeyType.letter),
      KeyData(value: 't', type: KeyType.letter),
      KeyData(value: 'y', type: KeyType.letter),
      KeyData(value: 'u', type: KeyType.letter),
      KeyData(value: 'i', type: KeyType.letter),
      KeyData(value: 'o', type: KeyType.letter),
      KeyData(value: 'p', type: KeyType.letter),
    ],
    // Row 2
    [
      KeyData(value: 'a', type: KeyType.letter),
      KeyData(value: 's', type: KeyType.letter),
      KeyData(value: 'd', type: KeyType.letter),
      KeyData(value: 'f', type: KeyType.letter),
      KeyData(value: 'g', type: KeyType.letter),
      KeyData(value: 'h', type: KeyType.letter),
      KeyData(value: 'j', type: KeyType.letter),
      KeyData(value: 'k', type: KeyType.letter),
      KeyData(value: 'l', type: KeyType.letter),
    ],
    // Row 3
    [
      KeyData(value: 'shift', type: KeyType.shift, flex: 1.5),
      KeyData(value: 'z', type: KeyType.letter),
      KeyData(value: 'x', type: KeyType.letter),
      KeyData(value: 'c', type: KeyType.letter),
      KeyData(value: 'v', type: KeyType.letter),
      KeyData(value: 'b', type: KeyType.letter),
      KeyData(value: 'n', type: KeyType.letter),
      KeyData(value: 'm', type: KeyType.letter),
      KeyData(value: 'backspace', type: KeyType.backspace, flex: 1.5),
    ],
    // Row 4
    [
      KeyData(value: '123', type: KeyType.layoutSwitch, flex: 1.5),
      KeyData(value: ' ', type: KeyType.space, flex: 5),
      KeyData(value: 'return', type: KeyType.enter, flex: 1.5),
    ],
  ];

  static const List<List<KeyData>> numericLayout = [
    // Row 1
    [
      KeyData(value: '1', type: KeyType.number),
      KeyData(value: '2', type: KeyType.number),
      KeyData(value: '3', type: KeyType.number),
    ],
    // Row 2
    [
      KeyData(value: '4', type: KeyType.number),
      KeyData(value: '5', type: KeyType.number),
      KeyData(value: '6', type: KeyType.number),
    ],
    // Row 3
    [
      KeyData(value: '7', type: KeyType.number),
      KeyData(value: '8', type: KeyType.number),
      KeyData(value: '9', type: KeyType.number),
    ],
    // Row 4
    [
      KeyData(value: '!@#', type: KeyType.layoutSwitch, flex: 1.5),
      KeyData(value: '0', type: KeyType.number),
      KeyData(value: 'backspace', type: KeyType.backspace, flex: 1.5),
    ],
    // Row 5
    [
      KeyData(value: 'ABC', type: KeyType.layoutSwitch, flex: 1.5),
      KeyData(value: ' ', type: KeyType.space, flex: 5),
      KeyData(value: 'return', type: KeyType.enter, flex: 1.5),
    ],
  ];

  static const List<List<KeyData>> numericPureLayout = [
    // Row 1
    [
      KeyData(value: '1', type: KeyType.number),
      KeyData(value: '2', type: KeyType.number),
      KeyData(value: '3', type: KeyType.number),
    ],
    // Row 2
    [
      KeyData(value: '4', type: KeyType.number),
      KeyData(value: '5', type: KeyType.number),
      KeyData(value: '6', type: KeyType.number),
    ],
    // Row 3
    [
      KeyData(value: '7', type: KeyType.number),
      KeyData(value: '8', type: KeyType.number),
      KeyData(value: '9', type: KeyType.number),
    ],
    // Row 4
    [
      KeyData(value: '.', type: KeyType.special, flex: 1.5),
      KeyData(value: '0', type: KeyType.number),
      KeyData(value: 'backspace', type: KeyType.backspace, flex: 1.5),
    ],
    // Row 5
    [
      KeyData(value: ' ', type: KeyType.space, flex: 6),
      KeyData(value: 'return', type: KeyType.enter, flex: 2),
    ],
  ];

  static const List<List<KeyData>> numericDecimalLayout = [
    // Row 1
    [
      KeyData(value: '1', type: KeyType.number),
      KeyData(value: '2', type: KeyType.number),
      KeyData(value: '3', type: KeyType.number),
    ],
    // Row 2
    [
      KeyData(value: '4', type: KeyType.number),
      KeyData(value: '5', type: KeyType.number),
      KeyData(value: '6', type: KeyType.number),
    ],
    // Row 3
    [
      KeyData(value: '7', type: KeyType.number),
      KeyData(value: '8', type: KeyType.number),
      KeyData(value: '9', type: KeyType.number),
    ],
    // Row 4
    [
      KeyData(value: '.', type: KeyType.special, flex: 1),
      KeyData(value: '0', type: KeyType.number, flex: 1),
      KeyData(value: '.', type: KeyType.special, flex: 1), // Duplicate for easier access
    ],
    // Row 5
    [
      KeyData(value: ' ', type: KeyType.space, flex: 4),
      KeyData(value: 'backspace', type: KeyType.backspace, flex: 2),
      KeyData(value: 'return', type: KeyType.enter, flex: 2),
    ],
  ];

  static const List<List<KeyData>> symbolsLayout = [
    // Row 1
    [
      KeyData(value: '!', type: KeyType.special),
      KeyData(value: '@', type: KeyType.special),
      KeyData(value: '#', type: KeyType.special),
      KeyData(value: '\$', type: KeyType.special),
      KeyData(value: '%', type: KeyType.special),
      KeyData(value: '^', type: KeyType.special),
      KeyData(value: '&', type: KeyType.special),
      KeyData(value: '*', type: KeyType.special),
      KeyData(value: '(', type: KeyType.special),
      KeyData(value: ')', type: KeyType.special),
    ],
    // Row 2
    [
      KeyData(value: '-', type: KeyType.special),
      KeyData(value: '_', type: KeyType.special),
      KeyData(value: '=', type: KeyType.special),
      KeyData(value: '+', type: KeyType.special),
      KeyData(value: '[', type: KeyType.special),
      KeyData(value: ']', type: KeyType.special),
      KeyData(value: '{', type: KeyType.special),
      KeyData(value: '}', type: KeyType.special),
      KeyData(value: '|', type: KeyType.special),
    ],
    // Row 3
    [
      KeyData(value: ';', type: KeyType.special),
      KeyData(value: ':', type: KeyType.special),
      KeyData(value: '\'', type: KeyType.special),
      KeyData(value: '"', type: KeyType.special),
      KeyData(value: '<', type: KeyType.special),
      KeyData(value: '>', type: KeyType.special),
      KeyData(value: '?', type: KeyType.special),
      KeyData(value: '/', type: KeyType.special),
      KeyData(value: 'backspace', type: KeyType.backspace, flex: 1.5),
    ],
    // Row 4
    [
      KeyData(value: '123', type: KeyType.layoutSwitch, flex: 1.5),
      KeyData(value: '.', type: KeyType.special),
      KeyData(value: ',', type: KeyType.special),
      KeyData(value: '`', type: KeyType.special),
      KeyData(value: '~', type: KeyType.special),
      KeyData(value: '\\', type: KeyType.special),
    ],
    // Row 5
    [
      KeyData(value: 'ABC', type: KeyType.layoutSwitch, flex: 1.5),
      KeyData(value: ' ', type: KeyType.space, flex: 5),
      KeyData(value: 'return', type: KeyType.enter, flex: 1.5),
    ],
  ];

  static List<List<KeyData>> getLayoutForKeyboard(KeyboardLayout layout) {
    switch (layout) {
      case KeyboardLayout.qwerty:
        return qwertyLayout;
      case KeyboardLayout.numeric:
        return numericLayout;
      case KeyboardLayout.numericPure:
        return numericPureLayout;
      case KeyboardLayout.numericDecimal:
        return numericDecimalLayout;
      case KeyboardLayout.symbols:
        return symbolsLayout;
    }
  }

  static KeyboardLayout getNextLayout(KeyboardLayout currentLayout, String switchValue) {
    switch (switchValue) {
      case '123':
        return KeyboardLayout.numeric;
      case '!@#':
        return KeyboardLayout.symbols;
      case 'ABC':
        return KeyboardLayout.qwerty;
      default:
        return currentLayout;
    }
  }
}