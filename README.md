# Flutter Custom Keyboard 🎹

A highly customizable Flutter keyboard widget with modern animations, haptic feedback, and cross-platform support. Perfect replacement for system keyboards in forms, login screens, and search fields.

![Flutter Version](https://img.shields.io/badge/Flutter-3.10.0+-blue.svg)
![Dart Version](https://img.shields.io/badge/Dart-3.0.0+-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey.svg)

## ✨ Features

- **🎨 Modern UI Design**: Beautiful keyboard with gradients, shadows, and rounded corners
- **⚡ Smooth Animations**: Multiple animation layers with scale, ripple, and flash effects
- **📱 Cross-Platform**: Works seamlessly on both Android and iOS
- **🎯 Multiple Layouts**: QWERTY, numeric, and symbols layouts with easy switching
- **💫 Haptic Feedback**: Different vibration patterns for different key types
- **🔄 State Management**: Smart shift/caps lock handling with visual indicators
- **📏 Responsive Design**: Automatically adapts to different screen sizes
- **🎮 Easy Integration**: Drop-in replacement for any TextField
- **⌨️ Rich Key Types**: Letters, numbers, symbols, space, backspace, enter, and more
- **🔒 Input Focus**: Automatic scrolling to keep focused fields visible
- **✨ Visual Feedback**: Instant visual response to key presses
- **🌐 Global Setup**: Configure once in MaterialApp for app-wide functionality
- **📱 Back Button Support**: Android back button closes keyboard instead of app
- **🎯 TextFormField Support**: Works with standard Flutter TextFormField widgets
- **📝 Input Formatters**: Full support for Flutter TextInputFormatter (filtering, length limiting, masking)
- **⚡ Ultra-Fast Response**: 75% faster keyboard opening (175ms total response time)

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_custom_keyboard: ^1.1.1
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### Option 1: Global Setup (Recommended)

Set up keyboard functionality for your entire app with one configuration:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_custom_keyboard/flutter_custom_keyboard.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      builder: (context, child) {
        // Global keyboard functionality for all screens
        return KeyboardScaffold(
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: MyHomePage(),
    );
  }
}
```

### Option 2: Per-Screen Setup

Wrap individual screens that need custom keyboard:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KeyboardScaffold(
        child: MyHomePage(),
      ),
    );
  }
}
```

### 2. Choose Your Input Method

#### Option A: Using Standard TextFormField (New in v1.0.9)

```dart
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool useCustomKeyboard = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Keyboard Demo')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: TextFormField(
          controller: _controller,
          focusNode: useCustomKeyboard ? _focusNode : null,
          keyboardType: useCustomKeyboard ? TextInputType.none : TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Enter your text',
            hintText: 'Start typing...',
          ),
        ),
      ),
    );
  }
}
```

#### Option B: Using CustomTextField

```dart
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Keyboard Demo')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: CustomTextField(
          controller: _controller,
          labelText: 'Enter your text',
          hintText: 'Start typing...',
        ),
      ),
    );
  }
}
```

That's it! Your custom keyboard is now ready to use.

## 📖 Detailed Usage

### Global vs Per-Screen Setup

#### Global Setup Benefits:
- ✅ Configure once, works everywhere
- ✅ Consistent behavior across all screens
- ✅ Automatic navigation support
- ✅ Android back button handling
- ✅ No need to wrap individual screens

#### Per-Screen Setup Benefits:
- ✅ Fine-grained control
- ✅ Only specific screens have custom keyboard
- ✅ Smaller memory footprint

### TextFormField Integration (v1.0.9+)

You can now use standard Flutter TextFormField widgets:

```dart
TextFormField(
  controller: _controller,
  focusNode: useCustomKeyboard ? _focusNode : null,
  keyboardType: useCustomKeyboard ? TextInputType.none : TextInputType.text,
  onTap: () {
    if (useCustomKeyboard) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _focusNode.requestFocus();
    }
  },
  decoration: InputDecoration(
    labelText: 'Username',
    hintText: 'Enter username',
    prefixIcon: Icon(Icons.person),
  ),
)
```

### CustomTextField Properties

```dart
CustomTextField(
  controller: _controller,
  labelText: 'Email',
  hintText: 'Enter your email',
  obscureText: false,              // For password fields
  keyboardType: TextInputType.text,
  prefixIcon: Icon(Icons.email),
  suffixIcon: Icon(Icons.visibility),
  maxLines: 1,
  enabled: true,
  inputFormatters: [               // NEW in v1.1.0+
    LengthLimitingTextInputFormatter(50),
  ],
  decoration: InputDecoration(     // NEW in v1.1.0+
    border: OutlineInputBorder(),
  ),
  onSubmitted: (value) {
    // Handle submission
  },
)
```

### Input Formatters (v1.1.0+)

Full support for Flutter's TextInputFormatter system:

#### Numbers Only
```dart
CustomTextField(
  controller: _phoneController,
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')), // Only 0-9
    LengthLimitingTextInputFormatter(15), // Max 15 digits
  ],
  decoration: InputDecoration(
    labelText: 'Phone Number',
    hintText: 'Enter phone number',
  ),
)
```

#### Decimal Numbers
```dart
CustomTextField(
  controller: _priceController,
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')), // Up to 2 decimal places
    LengthLimitingTextInputFormatter(10),
  ],
  decoration: InputDecoration(
    labelText: 'Price',
    hintText: 'Enter price (e.g., 99.99)',
  ),
)
```

#### Email Validation
```dart
CustomTextField(
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9@._-]*$')), // Email characters
    LengthLimitingTextInputFormatter(50),
  ],
  decoration: InputDecoration(
    labelText: 'Email Address',
    hintText: 'Enter email address',
  ),
)
```

#### Combined Formatters
```dart
CustomTextField(
  controller: _controller,
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')), // Only numbers
    LengthLimitingTextInputFormatter(3), // Max 3 characters
  ],
  decoration: InputDecoration(
    labelText: 'PIN',
    hintText: 'Enter 3-digit PIN',
  ),
)
```

**Behavior**: Invalid characters are simply ignored (not applied to the field) instead of clearing the text, providing a smooth user experience that matches system keyboard expectations.

### Multiple Text Fields

The keyboard automatically handles multiple text fields:

```dart
Column(
  children: [
    CustomTextField(
      controller: _usernameController,
      labelText: 'Username',
      prefixIcon: Icon(Icons.person),
    ),
    SizedBox(height: 16),
    CustomTextField(
      controller: _passwordController,
      labelText: 'Password',
      obscureText: true,
      prefixIcon: Icon(Icons.lock),
    ),
    SizedBox(height: 16),
    CustomTextField(
      controller: _emailController,
      labelText: 'Email',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icon(Icons.email),
    ),
  ],
)
```

### Advanced Usage with Custom Keyboard

If you need more control, you can use the keyboard widget directly:

```dart
class AdvancedKeyboardScreen extends StatefulWidget {
  @override
  _AdvancedKeyboardScreenState createState() => _AdvancedKeyboardScreenState();
}

class _AdvancedKeyboardScreenState extends State<AdvancedKeyboardScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Your content here
          Expanded(
            child: TextField(controller: _controller),
          ),
          // Custom keyboard
          CustomKeyboard(
            onTextInput: (text) {
              final value = _controller.value;
              final newText = value.text + text;
              _controller.value = TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: newText.length),
              );
            },
            onBackspace: () {
              final value = _controller.value;
              if (value.text.isNotEmpty) {
                final newText = value.text.substring(0, value.text.length - 1);
                _controller.value = TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(offset: newText.length),
                );
              }
            },
            onEnter: () {
              // Handle enter key
            },
            height: 280,
          ),
        ],
      ),
    );
  }
}
```

### Keyboard Layouts

The keyboard supports three built-in layouts:

- **QWERTY**: Standard alphabet layout with shift functionality
- **Numeric**: Number pad with special symbols switch
- **Symbols**: Special characters and punctuation

Users can switch between layouts using the layout switch keys (123, !@#, ABC).

### Keyboard States

The keyboard handles several states automatically:

- **Normal**: Lowercase letters
- **Single Shift**: Next letter will be uppercase
- **Caps Lock**: All letters uppercase (double-tap shift)

## 🎨 Customization

### Keyboard Appearance

```dart
CustomKeyboard(
  height: 320,                    // Custom height
  backgroundColor: Colors.grey.shade100,
  onTextInput: (text) { /* ... */ },
  onBackspace: () { /* ... */ },
  onEnter: () { /* ... */ },
)
```

### TextField Styling

```dart
CustomTextField(
  controller: _controller,
  decoration: InputDecoration(
    labelText: 'Custom Style',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
    fillColor: Colors.blue.shade50,
  ),
)
```

## 🎯 Key Features Explained

### 1. **Haptic Feedback**
Different key types provide different haptic feedback:
- Regular keys: Light selection click
- Backspace: Heavy impact
- Enter: Medium impact
- Shift/Layout: Light impact
- Space: Medium impact

### 2. **Visual Animations**
Each key press includes multiple animation layers:
- **Scale Animation**: Key shrinks slightly when pressed
- **Ripple Effect**: Expanding circle from tap point
- **Flash Animation**: Quick white flash for instant feedback
- **Glow Effect**: Special keys (Enter, Backspace, Shift) have colored glow
- **Elevation Changes**: Shadow depth changes during press

### 3. **Smart Scrolling**
When the keyboard appears, the widget automatically:
- Detects focused text field position
- Calculates if it will be hidden by keyboard
- Smoothly scrolls to keep the field visible
- Provides appropriate padding and spacing

### 4. **Focus Management**
The keyboard handles focus intelligently:
- Shows when any CustomTextField or TextFormField gains focus
- Hides when tapping outside text fields
- Moves between fields with Enter key
- Prevents system keyboard interference
- Android back button closes keyboard instead of app

### 5. **Global Architecture (v1.0.9+)**
New global setup provides:
- App-wide keyboard functionality with single configuration
- Automatic navigation support across all screens
- Consistent behavior throughout the application
- Better integration with existing Flutter apps

## 📱 Platform Support

| Feature | Android | iOS | Web |
|---------|---------|-----|-----|
| Basic Keyboard | ✅ | ✅ | ✅ |
| Haptic Feedback | ✅ | ✅ | ❌ |
| Animations | ✅ | ✅ | ✅ |
| Focus Management | ✅ | ✅ | ✅ |
| Auto Scrolling | ✅ | ✅ | ✅ |
| System KB Suppression | ✅ | ✅ | ✅ |
| Back Button Support | ✅ | N/A | ❌ |
| Global Setup | ✅ | ✅ | ✅ |
| TextFormField Support | ✅ | ✅ | ✅ |

## 🔧 Troubleshooting

### Keyboard not showing?
Make sure you've set up KeyboardScaffold correctly:

**Global Setup:**
```dart
MaterialApp(
  builder: (context, child) {
    return KeyboardScaffold(  // This is required!
      child: child ?? const SizedBox.shrink(),
    );
  },
  home: YourScreen(),
)
```

**Per-Screen Setup:**
```dart
MaterialApp(
  home: KeyboardScaffold(  // This is required!
    child: YourScreen(),
  ),
)
```

### System keyboard still appearing?
The package automatically suppresses the system keyboard, but if you're still seeing it:

```dart
import 'package:flutter/services.dart';

// Manually hide system keyboard
SystemChannels.textInput.invokeMethod('TextInput.hide');
```

### Text not inputting?
- For **CustomTextField**: Use directly, no additional setup needed
- For **TextFormField**: Set `keyboardType: TextInputType.none` and provide a FocusNode
- Ensure you're following the correct integration pattern for your chosen input method

### Keyboard not hiding?
The keyboard automatically hides when:
- Tapping outside input fields
- Pressing Enter key with no next field
- Programmatically calling `KeyboardManager.hide()`

## 📄 API Reference

### KeyboardScaffold
Main wrapper widget that provides keyboard functionality.

| Property | Type | Description |
|----------|------|-------------|
| `child` | `Widget` | The main content of your screen |

### CustomTextField
Drop-in replacement for TextField with custom keyboard integration.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `controller` | `TextEditingController` | required | Controls the text being edited |
| `hintText` | `String?` | null | Placeholder text when empty |
| `labelText` | `String?` | null | Label text for the field |
| `obscureText` | `bool` | false | Hide text for passwords |
| `keyboardType` | `TextInputType` | TextInputType.text | Hint for keyboard type |
| `prefixIcon` | `Widget?` | null | Icon at the start of field |
| `suffixIcon` | `Widget?` | null | Icon at the end of field |
| `maxLines` | `int?` | 1 | Maximum lines for text |
| `enabled` | `bool` | true | Whether the field is enabled |
| `onSubmitted` | `Function(String)?` | null | Called when submitted |

### CustomKeyboard
The keyboard widget itself for advanced usage.

| Property | Type | Description |
|----------|------|-------------|
| `onTextInput` | `Function(String)` | Called when text is inputted |
| `onBackspace` | `VoidCallback` | Called when backspace pressed |
| `onEnter` | `VoidCallback?` | Called when enter pressed |
| `height` | `double?` | Custom keyboard height |
| `backgroundColor` | `Color?` | Custom background color |

### KeyboardManager
Static class for programmatic keyboard control.

| Method | Description |
|--------|-------------|
| `show()` | Show the keyboard |
| `hide()` | Hide the keyboard |
| `scrollToField()` | Scroll to focused field |
| `setCurrentController(controller)` | Set active text controller |
| `clearCurrentController()` | Clear active text controller |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Community feedback and contributions
- Material Design guidelines for UI inspiration

## 📞 Support

If you have any questions or issues, please:

1. Check the [troubleshooting section](#🔧-troubleshooting)
2. Search existing [GitHub Issues](https://github.com/your-username/flutter_custom_keyboard/issues)
3. Create a new issue with detailed information

---

Made with ❤️ by robyy