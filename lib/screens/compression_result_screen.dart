import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/constants/app_durations.dart';
import '../utils/theme_provider.dart';
import '../widgets/animated_theme_toggle.dart';
import '../widgets/premium_button.dart';
import '../widgets/premium_alert_dialog.dart';
import '../widgets/web_navbar.dart';
import '../widgets/upload_modal.dart';
import '../widgets/compression_loading_overlay.dart';

class CompressionResultScreen extends StatefulWidget {
  final File originalImage;
  final Uint8List? imageBytes;
  final String originalSize;
  final String compressedSize;
  final Duration compressionTime;

  const CompressionResultScreen({
    super.key,
    required this.originalImage,
    this.imageBytes,
    required this.originalSize,
    required this.compressedSize,
    required this.compressionTime,
  });

  @override
  State<CompressionResultScreen> createState() =>
      _CompressionResultScreenState();
}

class _CompressionResultScreenState extends State<CompressionResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _particleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // State variables for dynamic updates
  late File _originalImage;
  late Uint8List? _imageBytes;
  late String _originalSize;
  late String _compressedSize;
  late Duration _compressionTime;

  bool _showOriginal = false;

  @override
  void initState() {
    super.initState();

    // Initialize state from widget parameters
    _originalImage = widget.originalImage;
    _imageBytes = widget.imageBytes;
    _originalSize = widget.originalSize;
    _compressedSize = widget.compressedSize;
    _compressionTime = widget.compressionTime;

    _entranceController = AnimationController(
      duration: AppDurations.entranceAnimation,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    _particleController = AnimationController(
      duration: AppDurations.particleAnimation,
      vsync: this,
    )..repeat();

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor:
          isDark ? Colors.black : Colors.white, // Match gradient end
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false, // Prevent resizing when keyboard opens
      body: Stack(
        fit: StackFit.expand, // Force background to fill screen
        children: [
          // 1. Minimalist Animated Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:
                      isDark
                          ? [const Color(0xFF121212), const Color(0xFF000000)]
                          : [const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)],
                ),
              ),
            ),
          ),

          // Subtle Particles
          ...List.generate(8, (index) {
            return AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                final random = math.Random(index);
                final speed = 0.2 + (random.nextDouble() * 0.2);
                final angle =
                    (index * math.pi / 4) +
                    (_particleController.value * 2 * math.pi * speed);

                final dx = math.cos(angle) * 150 * (index % 2 + 1);
                final dy = math.sin(angle) * 150 * (index % 2 + 1);

                final isSecondary = index % 2 == 0;
                final particleColor =
                    isSecondary ? secondaryColor : primaryColor;

                return Positioned(
                  left: MediaQuery.of(context).size.width / 2 + dx,
                  top: MediaQuery.of(context).size.height / 2 + dy,
                  child: Opacity(
                    opacity: 0.05, // Very subtle
                    child: Container(
                      width: 100.0 + (index * 20),
                      height: 100.0 + (index * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [particleColor, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // 2. Main Content
          SafeArea(
            bottom: false, // Allow content to go to the very bottom
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    kIsWeb ? 32 : 16,
                    kIsWeb ? 100 : 16, // Less top padding on mobile (no navbar)
                    kIsWeb ? 32 : 16,
                    32,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child:
                          kIsWeb
                              ? _buildWebLayout(context, isDark, primaryColor)
                              : _buildMobileLayout(
                                context,
                                isDark,
                                primaryColor,
                              ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Web Navbar (Top Layer) - Only show on web
          if (kIsWeb)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: WebNavbar(
                onHomeTap:
                    () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWebLayout(
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: Image (The Hero)
        Expanded(
          flex: 6,
          child: _buildImagePreview(context, isDark, primaryColor),
        ),

        const SizedBox(width: 60),

        // Right: Details & Actions (Clean & Minimal)
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, primaryColor),
              const SizedBox(height: 40),
              _buildStatsMinimal(context, isDark, primaryColor),
              const SizedBox(height: 40),
              _buildActionButtons(context, primaryColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    return Column(
      children: [
        // Mobile header with back button and success icon
        _buildMobileHeader(context, primaryColor),
        const SizedBox(height: 24),
        _buildImagePreview(context, isDark, primaryColor),
        const SizedBox(height: 24),
        _buildStatsMinimal(context, isDark, primaryColor),
        const SizedBox(height: 24),
        _buildActionButtons(context, primaryColor),
      ],
    );
  }

  Widget _buildMobileHeader(BuildContext context, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button and title section
          Row(
            children: [
              // Back button with gradient background (matching home screen icon style)
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        Theme.of(context).colorScheme.secondary,
                      ],
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
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Result',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'Compression Complete',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Theme toggle (matching home screen)
          const AnimatedThemeToggle(size: 24, padding: 12),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Color primaryColor, {
    bool center = false,
  }) {
    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Compression Complete',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w300, // Thin, elegant font
            letterSpacing: -1.0,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          textAlign: center ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 12),
        Text(
          'Your image has been optimized with precision.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            fontWeight: FontWeight.w400,
          ),
          textAlign: center ? TextAlign.center : TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildImagePreview(
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // Image
            AspectRatio(
              aspectRatio: 1, // Keep it square or adjust based on image
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  key: ValueKey<bool>(_showOriginal),
                  child:
                      kIsWeb && _imageBytes != null
                          ? (_showOriginal
                              ? Image.memory(
                                _imageBytes!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                              : Image.memory(
                                _imageBytes!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ))
                          : Image.file(
                            _originalImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                ),
              ),
            ),

            // Elegant Toggle Overlay
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildToggleChip('Compressed', !_showOriginal),
                          _buildToggleChip('Original', _showOriginal),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleChip(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showOriginal = text == 'Original';
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
                isActive ? Colors.black : Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsMinimal(
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            'Original',
            _originalSize,
            Icons.data_usage,
            Colors.grey,
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          ),
          _buildStatItem(
            context,
            'Compressed',
            _compressedSize,
            Icons.compress,
            primaryColor,
            isBold: true,
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          ),
          _buildStatItem(
            context,
            'Time',
            _formatDuration(_compressionTime),
            Icons.timer_outlined,
            Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color, {
    bool isBold = false,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color:
                isBold ? color : Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Color primaryColor) {
    return Column(
      children: [
        PremiumButton(
          text: 'Download Image',
          icon: Icons.download_rounded,
          onPressed: () => _downloadImage(context),
          isPrimary: true,
          isFullWidth: true,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PremiumButton(
                text: 'Share',
                icon: Icons.share_rounded,
                onPressed: () => _shareImage(context),
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PremiumButton(
                text: 'New',
                icon: Icons.add_photo_alternate_rounded,
                onPressed: () => _confirmNewImage(context),
                isPrimary: false,
                customColor: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _confirmNewImage(BuildContext context) async {
    showDialog(
      context: context,
      builder:
          (context) => PremiumAlertDialog(
            title: 'Start New Compression?',
            content:
                'Your current image will be lost if you haven\'t downloaded it.',
            confirmText: 'Discard & New',
            onCancel: () => Navigator.pop(context),
            onConfirm: () {
              Navigator.pop(context); // Close alert
              _showUploadModal(context);
            },
          ),
    );
  }

  Future<void> _showUploadModal(BuildContext context) async {
    await showDialog(
      context: context,
      builder:
          (context) => UploadModal(
            onImageSelected: (file, bytes) {
              if (file != null || bytes != null) {
                _compressAndShowResult(context, file, bytes);
              }
            },
          ),
    );
  }

  Future<void> _compressAndShowResult(
    BuildContext context,
    File? file,
    Uint8List? bytes,
  ) async {
    // Show loading overlay
    final startTime = DateTime.now();

    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: CompressionLoadingOverlay(
              imageFile:
                  file ??
                  _originalImage, // Fallback if file is null (shouldn't happen)
              imageBytes: bytes,
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
        _originalImage = file ?? _originalImage;
        _imageBytes = bytes;
        _originalSize = '10.0 MB'; // Mock data for demo
        _compressedSize = '1.0 MB'; // Mock data for demo
        _compressionTime = compressionTime;
        _showOriginal = false; // Reset view to compressed
      });

      // Re-run entrance animation for fresh feel
      _entranceController.reset();
      _entranceController.forward();
    }
  }

  void _downloadImage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.download_done, color: Colors.white),
            SizedBox(width: 12),
            Text('Download functionality will be implemented with backend'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _shareImage(BuildContext context) async {
    try {
      await Share.shareXFiles(
        [XFile(_originalImage.path)],
        text:
            'Check out this compressed image! Original: $_originalSize, Compressed: $_compressedSize, Time: ${_formatDuration(_compressionTime)}',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Failed to share: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds < 1) {
      return '${duration.inMilliseconds}ms';
    } else if (duration.inSeconds < 60) {
      final seconds = duration.inSeconds;
      final milliseconds = duration.inMilliseconds % 1000;
      return milliseconds > 0
          ? '$seconds.${(milliseconds / 100).floor()}s'
          : '${seconds}s';
    } else {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      return '${minutes}m ${seconds}s';
    }
  }
}
