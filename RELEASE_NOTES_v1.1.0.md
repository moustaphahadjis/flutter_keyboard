# Flutter Custom Keyboard v1.1.0 Release Notes

## 🎉 **Major Feature Release: Input Formatter Support**

We're excited to announce Flutter Custom Keyboard v1.1.0, featuring complete support for Flutter's TextInputFormatter system and a critical bug fix for input rejection behavior.

---

## ✨ **What's New**

### 🎯 **Full Input Formatter Support**
- **NEW**: `inputFormatters` parameter added to `CustomTextField` and `AdaptiveTextField`
- **Support for all standard Flutter formatters**:
  - `FilteringTextInputFormatter.allow()` and `FilteringTextInputFormatter.deny()`
  - `LengthLimitingTextInputFormatter` for character limits
  - `MaskTextInputFormatter` and other third-party formatters
  - Custom formatters implementing `TextInputFormatter` interface

### 🔧 **Critical Bug Fix: Text Field Clearing**
**Problem**: When using input formatters with restricted characters (e.g., typing "." in a numbers-only field), the entire text would be cleared.

**Root Cause**: `FilteringTextInputFormatter` returns an empty string `""` when rejecting input, which was being applied to the field.

**Solution**: Implemented intelligent rejection detection that properly ignores invalid characters instead of clearing the field.

**Impact**: 
- ✅ **Before**: Type "123" → Press "." → Field becomes empty ""
- ✅ **After**: Type "123" → Press "." → Field remains "123" (character ignored)

---

## 📋 **Usage Examples**

### Numbers Only with Length Limit
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

### Decimal Numbers with Precision
```dart
CustomTextField(
  controller: _priceController,
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')), // Up to 2 decimals
    LengthLimitingTextInputFormatter(10),
  ],
  decoration: InputDecoration(
    labelText: 'Price',
    hintText: 'Enter price (e.g., 99.99)',
  ),
)
```

### Email with Character Filtering
```dart
CustomTextField(
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9@._-]*$')), // Email chars
    LengthLimitingTextInputFormatter(50),
  ],
  decoration: InputDecoration(
    labelText: 'Email Address',
    hintText: 'Enter email address',
  ),
)
```

---

## 🔄 **Migration Guide**

### Zero Breaking Changes
- ✅ All existing code continues to work unchanged
- ✅ All existing APIs remain fully functional
- ✅ Existing implementations automatically benefit from the input rejection fix

### Optional Enhancements
```dart
// OLD (still works)
CustomTextField(
  controller: _controller,
  labelText: 'Phone',
)

// NEW (enhanced with formatters)
CustomTextField(
  controller: _controller,
  labelText: 'Phone',
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
    LengthLimitingTextInputFormatter(10),
  ],
)
```

---

## 🧪 **Quality Assurance**

### Comprehensive Testing
- ✅ **Debug Tests**: Verified `FilteringTextInputFormatter` behavior patterns
- ✅ **Fix Verification**: Confirmed rejection detection works with all formatter types
- ✅ **Integration Tests**: Validated real-world usage scenarios
- ✅ **Backwards Compatibility**: Ensured no regressions in existing functionality

### Test Coverage
- Numbers-only formatter rejection behavior
- Length limiting formatter behavior  
- Combined formatters working together
- Edge cases and error scenarios

---

## 📈 **Performance Impact**

- ✅ **Zero Performance Regression**: No impact on typing speed or responsiveness
- ✅ **Memory Efficient**: Formatters are only stored when needed
- ✅ **Animation Smoothness**: All animations and haptic feedback preserved

---

## 🔗 **Installation**

```yaml
dependencies:
  flutter_custom_keyboard: ^1.1.0
```

Then run:
```bash
flutter pub get
```

---

## 🎯 **Next Steps**

1. **Update your pubspec.yaml** to use version `^1.1.0`
2. **Add input formatters** to your text fields for enhanced validation
3. **Test the improved behavior** - invalid characters are now properly ignored
4. **Enjoy the enhanced user experience** with predictable, system-keyboard-like behavior

---

## 🤝 **Community**

- **Report Issues**: [GitHub Issues](https://github.com/flutter-community/flutter_custom_keyboard/issues)
- **Documentation**: [pub.dev](https://pub.dev/documentation/flutter_custom_keyboard/latest/)
- **Examples**: Check out the updated example app for formatter demonstrations

---

## 🙏 **Thank You**

Thank you to the Flutter community for feedback and bug reports that led to this important improvement. Your input helps make Flutter Custom Keyboard better for everyone!

---

**Flutter Custom Keyboard Team**  
January 15, 2025