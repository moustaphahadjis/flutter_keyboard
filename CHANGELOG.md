# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2025-01-15

### Performance 🚀
- **⚡ 75% Faster Keyboard Opening**: Dramatically improved keyboard response time
  - **Animation Duration**: Reduced from 300ms to 150ms (50% faster)
  - **Setup Process**: Eliminated 50ms keyboard type setup delay (now immediate)
  - **System Integration**: Reduced system keyboard hiding delay from 50ms to 25ms
  - **Scroll Response**: Reduced scroll delay from 300ms to 50ms (83% faster)
  - **Focus Animation**: Reduced from 200ms to 100ms (50% faster)
  - **Total Response Time**: Improved from ~700ms to ~175ms
- **🎯 Enhanced Animation Curves**: More responsive `Curves.easeOutQuart` for snappier feel
- **⚙️ Parallel Processing**: Keyboard setup, animations, and scrolling now run concurrently
- **📱 Better User Experience**: Keyboard feels as responsive as system keyboard

### Technical Improvements
- **Optimized Focus Handling**: Immediate keyboard display without unnecessary delays
- **Streamlined Animation Controllers**: Faster, more efficient animation management
- **Improved State Management**: Better coordination between keyboard state and UI updates
- **Enhanced Process Flow**: Eliminated bottlenecks in keyboard initialization sequence

### Backwards Compatibility
- **✅ Zero Breaking Changes**: All existing code works unchanged
- **✅ Automatic Benefits**: All implementations get performance improvements instantly
- **✅ Preserved Functionality**: All features, animations, and behaviors maintained
- **✅ Same APIs**: No changes to public interfaces or usage patterns

### Performance Metrics
- **Time to Keyboard Visible**: 700ms → 175ms (75% improvement)
- **Animation Completion**: 300ms → 150ms (50% improvement)
- **Focus Response**: 200ms → 100ms (50% improvement)
- **User Perceived Responsiveness**: Significantly improved across all interactions

### Breaking Changes
- None (performance optimizations only)

### Migration Notes
- **No Migration Required**: All improvements are automatic and backwards compatible
- **Immediate Benefits**: Simply update to v1.1.1 to get 75% faster keyboard performance
- **Enhanced Experience**: Users will notice immediate responsiveness improvements

## [1.1.0] - 2025-01-15

### Added
- **🎯 Input Formatter Support**: Complete implementation of Flutter TextInputFormatter support
  - Added `inputFormatters` parameter to `CustomTextField` for validation and filtering
  - Added `inputFormatters` parameter to `AdaptiveTextField` for enhanced form control
  - Full compatibility with all standard Flutter input formatters:
    - `FilteringTextInputFormatter.allow()` and `FilteringTextInputFormatter.deny()`
    - `LengthLimitingTextInputFormatter` for character limits
    - `MaskTextInputFormatter` and other third-party formatters
    - Custom formatters implementing `TextInputFormatter` interface
- **📝 Enhanced Widget APIs**: Extended widget APIs for better form integration
  - Added `decoration` parameter to `CustomTextField` for flexible styling
  - Enhanced `AdaptiveTextField` with comprehensive formatter support
  - Updated all example apps to demonstrate formatter usage

### Fixed
- **🔧 Critical Input Rejection Bug**: Fixed text field clearing when restricted characters are entered
  - **Root Cause**: `FilteringTextInputFormatter` returns empty string `""` for rejected input
  - **Solution**: Added intelligent rejection detection with multiple pattern matching:
    - Pattern 1: Detects empty string returns from filtering formatters
    - Pattern 2: Detects unchanged old value returns from limiting formatters  
    - Pattern 3: Handles combined formatter scenarios
  - **Behavior**: Invalid characters are now properly ignored instead of clearing the field
  - **Impact**: Numbers-only fields no longer clear when typing letters or symbols

### Enhanced
- **🎮 Keyboard Manager API**: Extended KeyboardManager with formatter support
  - Updated `setCurrentControllerWithType()` to accept optional input formatters
  - Enhanced `_handleTextInput()` and `_handleBackspace()` with rejection detection
  - Added proper cleanup of formatter references in controller lifecycle
- **📱 Smart Type Detection**: Improved automatic keyboard type selection
  - Enhanced test form with dynamic formatter assignment based on input type
  - Added helper methods for getting appropriate formatters per input type
  - Updated example usage with real-world formatting scenarios

### Technical Improvements
- **🧪 Comprehensive Testing**: Added extensive test coverage for formatter functionality
  - Created debug tests to verify `FilteringTextInputFormatter` behavior patterns
  - Added rejection detection verification tests with multiple formatter scenarios
  - Implemented integration tests demonstrating fix effectiveness
- **📚 Documentation**: Enhanced documentation with formatter usage examples
  - Created `INPUT_FORMATTER_FIX.md` with detailed technical explanation
  - Updated example apps with practical formatter demonstrations
  - Added test applications for manual verification of fix

### User Experience
- **✅ Predictable Behavior**: Input formatters now work exactly like system keyboard
  - Typing restricted characters: Simply ignored (no action)
  - Exceeding length limits: Additional characters ignored (no clearing)
  - Invalid patterns: Field content remains stable and unchanged
- **🔄 Seamless Integration**: Zero migration required for existing implementations
  - All existing code automatically benefits from the formatter fix
  - New formatter parameters are optional and backwards compatible
  - Enhanced functionality available through simple parameter addition

### Usage Examples
```dart
// Numbers only with length limit
CustomTextField(
  controller: controller,
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
    LengthLimitingTextInputFormatter(10),
  ],
)

// Decimal numbers with precision control
CustomTextField(
  controller: controller,
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
  ],
)

// Email with character filtering
CustomTextField(
  controller: controller,
  keyboardType: TextInputType.emailAddress,
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9@._-]*$')),
    LengthLimitingTextInputFormatter(50),
  ],
)
```

### Breaking Changes
- None (fully backward compatible)

### Migration Notes
- **Automatic Benefits**: All existing implementations automatically receive the input rejection fix
- **Optional Enhancement**: Add `inputFormatters` parameter to widgets for validation/filtering
- **Zero Breaking Changes**: All existing APIs remain unchanged and fully functional

## [1.0.9] - 2025-01-15

### Enhanced
- **Version Alignment**: Updated package version for consistency with latest feature set
- **Release Preparation**: Prepared package for publication with comprehensive feature set

### Stability
- **Production Ready**: All features tested and validated for production use
- **Cross-Platform Compatibility**: Verified functionality across Android, iOS, and web platforms
- **Performance Optimization**: Confirmed no performance regressions in latest build

### Documentation
- **Complete Coverage**: All new features documented in changelog and code comments
- **Usage Examples**: Updated examples demonstrate global setup and per-screen configurations
- **Migration Guide**: Clear guidance for upgrading from previous versions

### Quality Assurance
- **Layout Testing**: Verified resolution of all layout constraint issues
- **Integration Testing**: Confirmed global KeyboardScaffold works across complex app architectures
- **Edge Case Handling**: Tested behavior with various scroll configurations and widget hierarchies

### Breaking Changes
- None (fully backward compatible)

## [1.0.8] - 2025-01-15

### Fixed
- **Layout Constraints**: Fixed RenderFlex overflow errors and infinite height constraint issues
- **Global Architecture**: Resolved layout conflicts when using KeyboardScaffold globally in MaterialApp builder
- **Scroll Integration**: Fixed auto-scroll functionality to work with individual screen ScrollViews

### Enhanced
- **Global Setup Support**: KeyboardScaffold can now be applied globally in MaterialApp builder for app-wide functionality
- **Flexible Scrolling**: Redesigned scroll architecture to work with existing ScrollViews in screens
- **Layout Compatibility**: Improved compatibility with complex widget hierarchies and nested layouts

### Technical Improvements
- **Architecture Redesign**: Removed internal ScrollController from KeyboardScaffold
- **Dynamic Scroll Detection**: Uses `Scrollable.maybeOf(context)` to find existing scroll widgets
- **Layout Optimization**: Simplified widget tree structure to prevent constraint conflicts
- **Widget Integration**: Better integration with existing app architectures

### User Experience
- **Seamless Global Setup**: Configure once in MyApp, works across all screens automatically
- **Natural Scrolling**: Works with existing screen scroll behavior without conflicts
- **Consistent Behavior**: Same keyboard functionality across entire app with one setup

### Migration
- **Global Setup**: Recommended pattern now uses MaterialApp builder for app-wide keyboard support
- **Per-Screen Setup**: Still supported for apps requiring selective keyboard functionality
- **Backward Compatibility**: All existing implementations continue to work unchanged

### Breaking Changes
- None (fully backward compatible)

## [1.0.7] - 2025-01-15

### Fixed
- **Auto-Scroll Optimization**: Completely redesigned scroll behavior to eliminate excessive scrolling when keyboard opens
- **Precise Field Positioning**: Input fields now position exactly at keyboard edge with minimal movement
- **Enhanced Keyboard Dismissal**: Improved tap-outside-to-dismiss responsiveness with instant feedback
- **Android Back Button Handling**: Fixed app closing when back button pressed with keyboard open

### Enhanced
- **Smart Scroll Logic**: New algorithm calculates exact scroll amount needed without additional buffers
  - Removed all unnecessary spacing calculations (reduced from 50px total buffer to 0px)
  - Fields position precisely at keyboard boundary for optimal space usage
  - Eliminated over-scrolling that pushed fields too far above keyboard
- **Ultra-Responsive Dismissal**: Enhanced tap-outside-to-dismiss functionality
  - Added `onTapDown` callback for immediate keyboard dismissal on touch start
  - Changed to `HitTestBehavior.opaque` for better tap detection coverage
  - Added keyboard visibility state checking for smarter gesture handling
  - Keyboard now starts closing instantly when user touches outside area
- **Natural Scrolling Experience**: Auto-scroll now behaves like system keyboards
  - Minimal movement to position focused field just above keyboard
  - No excessive screen jumping or unnecessary spacing
  - Smooth positioning that feels natural and responsive
- **Android Back Button Integration**: Implemented smart back button handling
  - Back button closes keyboard when open instead of exiting app
  - Maintains normal navigation behavior when keyboard is closed
  - Follows standard Android UX patterns for keyboard dismissal

### Technical Improvements
- **Scroll Algorithm**: Simplified calculation logic for precise field positioning
  ```dart
  final targetFieldBottom = screenHeight - keyboardHeight;
  final scrollAmount = currentFieldBottom - targetFieldBottom;
  ```
- **Gesture Handling**: Enhanced tap detection with dual callback system
  - `onTapDown`: Immediate response for ultra-fast feedback
  - `onTap`: Backup handling for reliability
- **State Management**: Added keyboard visibility checks to prevent unnecessary processing
- **Navigation Control**: Implemented PopScope wrapper for back button interception
  - `canPop: !_keyboardVisible` prevents navigation when keyboard is open
  - `onPopInvoked` callback handles keyboard dismissal on back press
  - Smart focus management and controller cleanup on dismissal

### User Experience
- **Minimal Scrolling**: Fields now position with just enough movement to clear keyboard
- **Instant Dismissal**: Keyboard responds immediately to tap-outside gestures
- **Natural Feel**: Scrolling behavior matches user expectations from system keyboards
- **Precise Positioning**: No wasted space above keyboard, optimal screen real estate usage
- **Standard Android Behavior**: Back button now follows platform conventions
  - First press closes keyboard, second press exits app
  - No accidental app exits when trying to dismiss keyboard

### Validation
- **Cross-Platform Testing**: Verified improved scroll behavior on Android and iOS
- **Responsiveness Testing**: Confirmed instant keyboard dismissal across all devices
- **Positioning Accuracy**: Validated precise field placement at keyboard boundary
- **Performance**: No regression in typing performance or animation smoothness
- **Navigation Testing**: Confirmed proper back button behavior on Android devices
  - Keyboard dismissal works correctly with back button
  - Normal app navigation preserved when keyboard is closed

### Breaking Changes
- None (fully backward compatible)

## [1.0.6] - 2025-01-15

### Fixed
- **Critical Gesture Handling**: Fixed backspace key only responding to long press instead of single tap
- **Enter Key Responsiveness**: Improved Enter/Cancel key single tap detection for reliable keyboard dismissal  
- **TextFormField Integration**: Enhanced compatibility with standard Flutter TextFormField widgets
- **Clear Button Conflicts**: Resolved gesture conflicts between TextFormField suffix icons and custom keyboard
- **Cursor Visibility**: Fixed missing text cursor in TextFormField when using custom keyboard

### Enhanced
- **Gesture Detection**: Completely redesigned key gesture handling for better responsiveness
  - Added `handleGestures` parameter to CustomKey for flexible gesture management
  - Implemented proper gesture delegation for backspace key with parent-child coordination
  - Enhanced `HitTestBehavior` configuration for reliable tap detection across all keys
- **TextFormField Support**: Full compatibility with Flutter's standard TextFormField
  - Added `useCustomKeyboard` flag for seamless switching between custom and system keyboards
  - Proper focus management with conditional `readOnly` and `enableInteractiveSelection` handling
  - Dynamic suffix icon support (clear buttons) without gesture conflicts
- **Visual Feedback**: Improved key press animations and visual states
  - Maintained haptic feedback and press animations even with parent gesture handling
  - Enhanced button press states with proper color transitions and shadows
  - Added `showCursor: true` support for proper text editing experience

### Technical Improvements
- **Architecture**: Separated visual feedback from action execution in key components
  - Created reusable `_buildKeyContent()` method for consistent key rendering
  - Implemented conditional gesture handling based on parent-child relationships
  - Enhanced CustomKey widget with configurable gesture behavior
- **State Management**: Improved focus and controller management
  - Added proper focus node lifecycle management with setup and disposal
  - Enhanced controller listeners for dynamic UI updates (clear button visibility)
  - Implemented smart keyboard dismissal with tap-outside-to-dismiss functionality
- **Code Quality**: Better separation of concerns and maintainability
  - Cleaner gesture detector hierarchy with proper behavior flags
  - Enhanced method organization with logical separation of visual and functional code
  - Improved error handling and edge case management

### User Experience
- **Reliable Input**: All keyboard keys now respond consistently to single taps
- **Seamless Integration**: TextFormField works exactly like standard Flutter components
- **Smart Interactions**: Intelligent gesture handling prevents conflicts between UI elements
- **Visual Polish**: Smooth animations and proper visual states across all interactions
- **Accessibility**: Enhanced touch targets and proper gesture recognition

### Developer Experience  
- **Flexible Integration**: Easy switching between custom and system keyboards with simple flag
- **Standard APIs**: Full compatibility with Flutter's form validation and text editing patterns
- **Documentation**: Enhanced example implementations showing TextFormField integration
- **Debugging**: Better gesture handling makes touch interactions more predictable

### Validation
- **Cross-Platform Testing**: Verified gesture improvements on both Android and iOS
- **Form Integration**: Tested with complex forms containing multiple TextFormField widgets
- **Edge Cases**: Validated proper behavior with various suffix/prefix icon configurations
- **Performance**: Confirmed no regression in typing performance or animation smoothness

### Breaking Changes
- None (fully backward compatible)

### Migration Notes
- Existing CustomTextField implementations continue to work unchanged
- New TextFormField integration is opt-in with `useCustomKeyboard` flag
- No API changes to existing keyboard functionality

## [1.0.5] - 2025-09-09

### Enhanced
- **Landscape Mode Optimization**: Complete redesign of keyboard behavior in landscape orientation
- **Compact Design**: Keyboard now uses 35% of screen height instead of 50% in landscape mode
- **Visual Scaling**: Added intelligent height-only scaling (scaleY: 0.8) to maintain full width coverage
- **Responsive Sizing**: Ultra-compact 25px key height for landscape mode (down from 42px)
- **Zero Padding**: Removed all horizontal and vertical padding in landscape for maximum space efficiency
- **Smart Scrolling**: Optimized auto-scroll behavior to position focused fields just above keyboard with minimal movement

### Fixed
- **Tablet Detection**: Improved landscape detection using `MediaQuery.orientation` instead of size comparison
- **Device Classification**: Fixed tablet detection using `shortestSide > 600` for more reliable cross-device compatibility
- **Layout Consistency**: Resolved width scaling issues that caused keyboards to appear narrower than screen width
- **Border Radius Matching**: Added consistent 16px rounded corners to bottom modal sheet
- **Scroll Behavior**: Fixed excessive scrolling by implementing smart field coverage detection (>50% threshold)
- **Static Analysis**: Resolved deprecated `withOpacity` warnings and removed debug print statements

### Technical
- **Transform Optimization**: Implemented separate X/Y scaling (scaleX: 1.0, scaleY: 0.8) for landscape mode
- **Alignment Control**: Added `Alignment.bottomCenter` to maintain proper keyboard positioning
- **Cross-File Consistency**: Updated tablet detection logic across all scaffold files for unified behavior
- **Performance**: Maintained typing performance while adding landscape optimizations
- **Scroll Algorithm**: Reduced buffer from 150px to 50px total with intelligent field coverage detection
- **Animation Tuning**: Faster scroll animations (200ms) with smoother easeOut curve

### User Experience
- **Android-like Behavior**: Landscape keyboard now behaves similarly to default Android keyboard
- **Screen Real Estate**: Significantly more content visible in landscape mode
- **Visual Polish**: Seamless rounded corners between modal sheet and keyboard container
- **Responsive Design**: Automatic adaptation between portrait and landscape orientations
- **Natural Scrolling**: Focused text fields now appear with comfortable spacing above keyboard
- **Reduced Motion**: Eliminated excessive screen movement when keyboard appears

### Validation
- **Mobile Testing**: Verified compact landscape behavior on Android devices
- **Orientation Switching**: Confirmed smooth transitions between portrait and landscape modes
- **Cross-Device**: Tested tablet detection accuracy across different screen sizes
- **Visual Consistency**: Validated matching design elements and corner radius alignment

## [1.0.4] - 2025-08-31

### Fixed
- **Critical Layout Bug**: Fixed keyboard not updating visually when switching between QWERTY, numeric, and symbol layouts
- **State Management**: Resolved issue where layout data was cached outside AnimatedBuilder preventing UI updates
- **Layout Switching Logic**: Ensured proper keyboard rebuilding when tapping 123, !@#, and ABC keys

### Enhanced
- **Debug Support**: Added comprehensive debug logging for layout switching operations
- **Error Tracking**: Improved debugging capabilities for layout state changes
- **Development Tools**: Enhanced development experience with better error reporting

### Technical
- **Widget Lifecycle**: Moved layout data retrieval inside AnimatedBuilder for proper state updates
- **Performance**: Optimized layout switching without affecting typing performance
- **State Synchronization**: Improved synchronization between keyboard state and visual representation

### Validation
- **Layout Testing**: Verified all three keyboard layouts (QWERTY → Numeric → Symbols) switch correctly
- **User Experience**: Confirmed smooth transitions between different input modes
- **Production Ready**: Thoroughly tested layout switching in production-like scenarios

### Breaking Changes
- None (backward compatible)

### Migration Notes
- No migration required - all changes are internal improvements
- Existing implementations will automatically benefit from the fixes

## [1.0.3] - 2025-08-31

### Fixed
- **Layout Switching**: Fixed critical bug where number and symbol keyboards weren't displaying after tapping layout switch keys (123, !@#, ABC)
- **UI Refresh**: Fixed keyboard not rebuilding when layout state changes by moving layout data retrieval inside AnimatedBuilder
- **Backspace Long Press**: Improved continuous backspace deletion with proper gesture handling and faster repeat rate (50ms intervals)

### Improved
- **Ultra-Fast Response**: Optimized key tap responsiveness for instant character input
  - Moved text input to onTapDown for zero-delay typing experience
  - Reduced animation durations (80ms → 40ms) for faster visual feedback
  - Streamlined haptic feedback for better performance
- **Code Quality**: Significant improvements to code structure and documentation
  - Fixed 43 → 39 static analysis issues
  - Added comprehensive dartdoc comments to all public APIs
  - Improved import structure using proper package imports
  - Enhanced example app with publish_to: none configuration

### Performance
- **Memory Optimization**: Cleaned up unused animation controllers and variables
- **Widget Building**: Optimized layout caching and reduced unnecessary rebuilds  
- **State Management**: Improved keyboard state updates with synchronous processing
- **Gesture Detection**: Enhanced long press detection for backspace functionality

### Documentation
- **API Documentation**: Added detailed dartdoc comments for better developer experience
- **Library Documentation**: Comprehensive library-level documentation with usage examples
- **Troubleshooting**: Enhanced README with better examples and debugging guides

## [1.0.0] - 2025-01-30

### Added
- 🎉 Initial release of Flutter Custom Keyboard package
- ⌨️ Complete custom keyboard widget with QWERTY, numeric, and symbols layouts
- 🎨 Modern UI design with gradients, shadows, and rounded corners
- ⚡ Multi-layer animations including scale, ripple, flash, and glow effects
- 📱 Cross-platform support for Android and iOS
- 💫 Haptic feedback with different patterns for different key types
- 🔄 Smart state management for shift/caps lock functionality
- 📏 Responsive design that adapts to different screen sizes
- 🎯 Easy integration with drop-in `CustomTextField` widget
- 📦 `KeyboardScaffold` for global keyboard management
- 🔒 Automatic input focus and scrolling management
- ✨ Visual feedback with instant response to key presses
- 🎮 Programmatic keyboard control via `KeyboardManager`
- 📖 Comprehensive documentation and examples
- 🧪 Example app demonstrating all features

### Features
- **Keyboard Layouts**:
  - QWERTY layout with full alphabet support
  - Numeric layout with number pad
  - Symbols layout with special characters and punctuation
  - Easy switching between layouts with dedicated keys

- **Visual Effects**:
  - Scale animation on key press
  - Ripple effect expanding from tap point
  - Flash animation for instant visual feedback
  - Glow effect for special keys (Enter, Backspace, Shift)
  - Dynamic elevation changes during interaction
  - Modern gradient backgrounds and shadows

- **User Experience**:
  - Haptic feedback with contextual vibration patterns
  - Smooth keyboard slide-in/out animations
  - Automatic scrolling to keep focused fields visible
  - Smart focus management between multiple text fields
  - System keyboard suppression to prevent conflicts

- **Developer Experience**:
  - Simple drop-in replacement for TextField
  - Minimal setup with KeyboardScaffold wrapper
  - Flexible CustomKeyboard widget for advanced usage
  - Comprehensive API with KeyboardManager
  - TypeScript-like API documentation
  - Rich example app with multiple use cases

- **Technical**:
  - Built with Flutter 3.10.0+ and Dart 3.0.0+
  - Uses TickerProviderStateMixin for smooth animations
  - Proper memory management with dispose methods
  - Cross-platform haptic feedback implementation
  - Optimized for performance with efficient state management

### API Reference
- `KeyboardScaffold`: Main wrapper widget for global keyboard functionality
- `CustomTextField`: Drop-in TextField replacement with keyboard integration
- `CustomKeyboard`: Core keyboard widget for advanced usage
- `KeyboardManager`: Static class for programmatic keyboard control
- `KeyboardStateManager`: State management for keyboard layouts and modes
- `KeyboardLayouts`: Predefined layout configurations
- `KeyData`: Individual key configuration model

### Documentation
- Comprehensive README.md with installation and usage guide
- API documentation with detailed property descriptions
- Multiple usage examples from basic to advanced
- Troubleshooting guide for common issues
- Platform-specific feature compatibility table
- Contributing guidelines and development setup

### Known Issues
- None reported in initial release

### Breaking Changes
- None (initial release)

---

## Release Notes

### What's New in 1.0.0
This is the initial stable release of Flutter Custom Keyboard, providing a complete solution for custom keyboard implementation in Flutter applications.

**Key Highlights:**
- ✅ **Production Ready**: Thoroughly tested and optimized for performance
- ✅ **Easy Integration**: Drop-in replacement for standard TextField widgets  
- ✅ **Beautiful Design**: Modern Material Design with smooth animations
- ✅ **Cross-Platform**: Works seamlessly on both Android and iOS
- ✅ **Developer Friendly**: Comprehensive documentation and examples

**Perfect For:**
- Login and registration forms
- Search functionality
- Chat applications
- Data entry forms
- Any app requiring custom text input

**Get Started:**
```yaml
dependencies:
  flutter_custom_keyboard: ^1.0.0
```

We're excited to see what you build with Flutter Custom Keyboard! 🚀