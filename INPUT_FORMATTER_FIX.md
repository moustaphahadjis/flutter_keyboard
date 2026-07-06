# Input Formatter Fix: Proper Rejection Handling

## Problem Description

Previously, when using input formatters with the custom keyboard, if a user pressed a restricted character (like "." when only numbers 0-9 were allowed), the entire text field would be cleared instead of simply ignoring the invalid character.

For example:
- Text field contains: "123"
- User presses "." (restricted by FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')))
- **Before fix**: Text field becomes empty ""
- **After fix**: Text field remains "123"

## Root Cause

The issue occurred in the `_handleTextInput` and `_handleBackspace` methods in `KeyboardScaffold`. When input formatters like `FilteringTextInputFormatter` reject a character, they return an **empty string** `""` instead of the original text, which was causing the text field to be cleared.

For example, `FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))` returns:
- `"1234"` for valid input like adding "4" to "123"  
- `""` (empty string) for invalid input like adding "a" to "123"

The previous code was blindly applying this empty string result, causing the text clearing behavior.

## Solution

### 1. Rejection Detection
Added logic to detect when an input formatter rejects input by checking for the specific rejection patterns:

```dart
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
// Pattern 3: Length limiting formatter - result is shorter than expected
else if (newValue.text.length > oldValue.text.length && 
         formattedValue.text.length <= oldValue.text.length &&
         formattedValue.text == oldValue.text) {
  wasRejected = true;
}

if (wasRejected) {
  // Input was rejected, don't update the controller
  return;
}
```

### 2. Early Return on Rejection
When a formatter rejects input, the method now returns early without updating the controller, effectively ignoring the invalid character.

### 3. Sequential Formatter Application
Multiple formatters are applied in sequence, and if any formatter rejects the input, the entire operation is cancelled.

## Technical Implementation

### Modified Methods

#### `_handleTextInput(String text)`
- Added rejection detection logic
- Early return when formatters reject input
- Preserves existing text when invalid characters are entered

#### `_handleBackspace()`
- Added similar rejection detection for backspace operations
- Prevents unwanted deletions when formatters restrict them

### Code Changes

```dart
// OLD: Direct application without rejection handling
for (final formatter in _currentFormatters!) {
  newValue = formatter.formatEditUpdate(oldValue, newValue);
}
_currentController!.value = newValue; // This would apply empty string!

// NEW: Rejection detection and handling
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
  
  if (wasRejected) {
    return; // Don't update the controller - ignore the character
  }
  
  newValue = formattedValue;
}
_currentController!.value = newValue;
```

## Usage Examples

### Numbers Only
```dart
CustomTextField(
  controller: controller,
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')), // Only 0-9
    LengthLimitingTextInputFormatter(15),
  ],
)
```

**Behavior**: 
- Typing "123" → Shows "123"
- Typing "." → Ignored, still shows "123"
- Typing "abc" → Ignored, still shows "123"

### Decimal Numbers
```dart
CustomTextField(
  controller: controller,
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')), // Up to 2 decimal places
    LengthLimitingTextInputFormatter(10),
  ],
)
```

**Behavior**:
- Typing "99.99" → Shows "99.99"
- Typing a third decimal digit → Ignored, still shows "99.99"
- Typing "99.999" → Shows "99.99" (third decimal place ignored)

### Email Validation
```dart
CustomTextField(
  controller: controller,
  keyboardType: TextInputType.emailAddress,
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9@._-]*$')), // Email chars
    LengthLimitingTextInputFormatter(50),
  ],
)
```

**Behavior**:
- Typing "test@example.com" → Shows "test@example.com"
- Typing special characters like "!" → Ignored
- Typing beyond 50 characters → Ignored

## Testing

### Test Cases Added
1. **Numbers-only rejection**: Verify non-numeric characters are ignored
2. **Length limiting**: Verify characters beyond limit are ignored
3. **Decimal pattern**: Verify invalid decimal patterns are ignored
4. **Multiple formatters**: Verify multiple formatters work together

### Running Tests
```bash
flutter test test/input_formatter_rejection_test.dart
```

## Benefits

1. **User-Friendly**: Invalid input is simply ignored instead of clearing the field
2. **Predictable**: Behavior matches standard Flutter TextFormField expectations
3. **Robust**: Works with any combination of input formatters
4. **Backwards Compatible**: Existing code continues to work without changes

## Migration

No migration required - this is a bug fix that improves existing functionality without breaking changes. All existing input formatter configurations will automatically benefit from the improved behavior.