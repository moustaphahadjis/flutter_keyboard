import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_keyboard/flutter_custom_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Keyboard Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const KeyboardScaffold(
        child: KeyboardDemoScreen(),
      ),
    );
  }
}

class KeyboardDemoScreen extends StatefulWidget {
  const KeyboardDemoScreen({super.key});

  @override
  State<KeyboardDemoScreen> createState() => _KeyboardDemoScreenState();
}

class _KeyboardDemoScreenState extends State<KeyboardDemoScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _searchFocus = FocusNode();
  final FocusNode _notesFocus = FocusNode();

  // Flag to control custom keyboard usage
  bool useCustomKeyboard = true;

  @override
  void initState() {
    super.initState();
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    _usernameFocus.addListener(() => _onFocusChange(_usernameFocus, _usernameController));
    _passwordFocus.addListener(() => _onFocusChange(_passwordFocus, _passwordController));
    _emailFocus.addListener(() => _onFocusChange(_emailFocus, _emailController));
    _phoneFocus.addListener(() => _onFocusChange(_phoneFocus, _phoneController));
    _searchFocus.addListener(() => _onFocusChange(_searchFocus, _searchController));
    _notesFocus.addListener(() => _onFocusChange(_notesFocus, _notesController));
  }

  void _onFocusChange(FocusNode focusNode, TextEditingController controller) {
    if (!useCustomKeyboard) return; // Skip custom keyboard logic if flag is false
    
    if (focusNode.hasFocus) {
      // Register this controller as the active one
      KeyboardManager.setCurrentController(controller);
      
      // Hide system keyboard
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      
      // Show custom keyboard
      KeyboardManager.show();
      
      // Scroll to make field visible
      Future.delayed(const Duration(milliseconds: 300), () {
        KeyboardManager.scrollToField();
      });
    } else {
      // Unregister this controller
      KeyboardManager.clearCurrentController();
      
      // Hide custom keyboard if no other field is focused
      Future.delayed(const Duration(milliseconds: 100), () {
        if (FocusManager.instance.primaryFocus == null) {
          KeyboardManager.hide();
        }
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _searchController.dispose();
    _notesController.dispose();
    
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _searchFocus.dispose();
    _notesFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Custom Keyboard Demo'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade100,
                    Colors.deepPurple.shade50,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepPurple.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.keyboard_alt_outlined,
                        color: Colors.deepPurple.shade700,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Custom Keyboard Package',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    useCustomKeyboard 
                        ? 'Tap any input field below to see the custom keyboard in action!'
                        : 'Custom keyboard is disabled. Fields will use system keyboard.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Use Custom Keyboard',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple.shade800,
                        ),
                      ),
                      Switch(
                        value: useCustomKeyboard,
                        onChanged: (value) {
                          setState(() {
                            useCustomKeyboard = value;
                            // Hide keyboard when switching modes
                            if (!value) {
                              KeyboardManager.hide();
                              KeyboardManager.clearCurrentController();
                            }
                          });
                        },
                        activeColor: Colors.deepPurple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // Login Form Section
            _buildSection(
              title: '🔐 Login Form',
              subtitle: 'Username and password fields',
              children: [
                TextFormField(
                  controller: _usernameController,
                  focusNode: useCustomKeyboard ? _usernameFocus : null,
                  readOnly: useCustomKeyboard,
                  enableInteractiveSelection: !useCustomKeyboard,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  focusNode: useCustomKeyboard ? _passwordFocus : null,
                  readOnly: useCustomKeyboard,
                  enableInteractiveSelection: !useCustomKeyboard,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Contact Information Section
            _buildSection(
              title: '📧 Contact Information',
              subtitle: 'Email and phone number',
              children: [
                TextFormField(
                  controller: _emailController,
                  focusNode: useCustomKeyboard ? _emailFocus : null,
                  readOnly: useCustomKeyboard,
                  enableInteractiveSelection: !useCustomKeyboard,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'your.email@example.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  focusNode: useCustomKeyboard ? _phoneFocus : null,
                  readOnly: useCustomKeyboard,
                  enableInteractiveSelection: !useCustomKeyboard,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '+1 (555) 123-4567',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Search Section
            _buildSection(
              title: '🔍 Search',
              subtitle: 'Quick search functionality',
              children: [
                TextFormField(
                  controller: _searchController,
                  focusNode: useCustomKeyboard ? _searchFocus : null,
                  readOnly: useCustomKeyboard,
                  enableInteractiveSelection: !useCustomKeyboard,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    hintText: 'What are you looking for?',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Notes Section
            _buildSection(
              title: '📝 Notes',
              subtitle: 'Multi-line text input',
              children: [
                TextFormField(
                  controller: _notesController,
                  focusNode: useCustomKeyboard ? _notesFocus : null,
                  readOnly: useCustomKeyboard,
                  enableInteractiveSelection: !useCustomKeyboard,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Enter your notes here...',
                    prefixIcon: const Icon(Icons.note_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Features Section
            _buildFeaturesSection(),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearAllFields,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear All'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showSummary,
                    icon: const Icon(Icons.summarize),
                    label: const Text('Show Summary'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: Colors.amber.shade700,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Package Features',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            icon: Icons.animation,
            title: 'Smooth Animations',
            description: 'Multi-layer animations with scale, ripple, and flash effects',
          ),
          _buildFeatureItem(
            icon: Icons.vibration,
            title: 'Haptic Feedback',
            description: 'Different vibration patterns for different key types',
          ),
          _buildFeatureItem(
            icon: Icons.keyboard_alt,
            title: 'Multiple Layouts',
            description: 'QWERTY, numeric, and symbols layouts',
          ),
          _buildFeatureItem(
            icon: Icons.devices,
            title: 'Cross-Platform',
            description: 'Works seamlessly on Android and iOS',
          ),
          _buildFeatureItem(
            icon: Icons.auto_fix_high,
            title: 'Smart Features',
            description: 'Auto-scrolling, focus management, and more',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.deepPurple.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFields() {
    _usernameController.clear();
    _passwordController.clear();
    _emailController.clear();
    _phoneController.clear();
    _searchController.clear();
    _notesController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All fields cleared!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSummary() {
    final summary = '''
Username: ${_usernameController.text}
Password: ${'•' * _passwordController.text.length}
Email: ${_emailController.text}
Phone: ${_phoneController.text}
Search: ${_searchController.text}
Notes: ${_notesController.text}
    '''.trim();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Summary'),
        content: SingleChildScrollView(
          child: Text(summary.isEmpty ? 'No input provided.' : summary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}