import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../utils/theme_provider.dart';
import '../services/image_picker_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/compression_loading_overlay.dart';
import 'compression_result_screen.dart';
import 'web_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Show web-specific design on web platform
    if (kIsWeb) {
      return const WebHomeScreen();
    }
    
    // Show mobile design on mobile platforms
    return const _MobileHomeScreen();
  }
}

class _MobileHomeScreen extends StatefulWidget {
  const _MobileHomeScreen();

  @override
  State<_MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<_MobileHomeScreen> {
  File? _selectedImage;
  bool _isProcessing = false;

  Future<void> _selectImage() async {
    final file = await ImagePickerService.showImageSourceDialog(context);
    
    if (file != null) {
      setState(() {
        _selectedImage = file;
      });
    }
  }

  Future<void> _compressImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    // TODO: Backend Integration - This will be replaced with actual API call
    // Show creative loading overlay with actual image
    final startTime = DateTime.now();
    
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: CompressionLoadingOverlay(
              imageFile: _selectedImage!,
              onComplete: () {
                Navigator.of(context).pop();
              },
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );

    final endTime = DateTime.now();
    final compressionTime = endTime.difference(startTime);

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      // Navigate to result screen
      // TODO: Backend Integration - Pass real compressed image and sizes from API
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompressionResultScreen(
            originalImage: _selectedImage!,
            originalSize: '10.0 MB', // TODO: Calculate actual size
            compressedSize: '1.0 MB', // TODO: Get from backend
            compressionTime: compressionTime,
          ),
        ),
      );
      
      // After returning from result screen, user can compress another image
      // The selected image is still available
    }
  }

  Widget _buildModernHeader(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.only(top: 48, bottom: 24, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App icon and name
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, Theme.of(context).colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.compress,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'AI-Powered Compression',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Theme toggle button
          Container(
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  key: ValueKey(isDark),
                  color: primaryColor,
                  size: 24,
                ),
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
              tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom modern header
          _buildModernHeader(context),
          
          // Main content
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              // Display selected image or placeholder
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 80,
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No image selected',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 32),

              // Select Image Button
              CustomButton(
                text: 'Select Image',
                icon: Icons.add_photo_alternate,
                onPressed: _selectImage,
                isFullWidth: true,
              ),

              const SizedBox(height: 16),

              // Compress Button (enabled only when image is selected)
              CustomButton(
                text: _isProcessing ? 'Processing...' : 'Compress Image',
                icon: Icons.compress,
                onPressed: _selectedImage != null && !_isProcessing
                    ? _compressImage
                    : () {},
                isOutlined: true,
                isFullWidth: true,
              ),

              const SizedBox(height: 32),

              // Info text
              Text(
                'Backend compression will be implemented in the next phase',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

