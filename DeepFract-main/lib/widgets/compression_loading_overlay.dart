import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

class CompressionLoadingOverlay extends StatefulWidget {
  final File imageFile;
  final Uint8List? imageBytes;
  final VoidCallback onComplete;

  const CompressionLoadingOverlay({
    super.key,
    required this.imageFile,
    this.imageBytes,
    required this.onComplete,
  });

  @override
  State<CompressionLoadingOverlay> createState() =>
      _CompressionLoadingOverlayState();
}

class _CompressionLoadingOverlayState extends State<CompressionLoadingOverlay>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;

  int _currentStep = 0;
  final List<String> _steps = [
    'Analyzing image structure...',
    'Applying fractal algorithms...',
    'Optimizing neural weights...',
    'Compressing data blocks...',
    'Finalizing output...',
  ];

  @override
  void initState() {
    super.initState();

    // Progress animation (0 to 100%)
    _progressController = AnimationController(
      duration: const Duration(
        milliseconds: 3500,
      ), // Slightly longer for dramatic effect
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic, // Smoother curve
      ),
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    // Pulse animation for the glow
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _startCompression();
  }

  void _startCompression() async {
    _progressController.forward();

    // Update steps during progress
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(Duration(milliseconds: 700));
      if (mounted) {
        setState(() {
          _currentStep = i;
        });
      }
    }

    // Wait a bit before completing
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.black.withValues(alpha: 0.85), // Darker overlay background
      child: Stack(
        children: [
          // 1. Animated Background Particles
          ...List.generate(40, (index) {
            return AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                final random = math.Random(index);
                final speed = 0.2 + (random.nextDouble() * 0.8);
                final angle =
                    (index * math.pi / 20) +
                    (_particleController.value * 2 * math.pi * speed);
                final distanceBase = 150.0 + (index * 5);
                final distance =
                    distanceBase +
                    (math.sin(_particleController.value * math.pi) * 20);

                final centerX = MediaQuery.of(context).size.width / 2;
                final centerY = MediaQuery.of(context).size.height / 2;

                final x = centerX + (math.cos(angle) * distance);
                final y = centerY + (math.sin(angle) * distance);
                final size = 2.0 + (random.nextDouble() * 4.0);

                return Positioned(
                  left: x,
                  top: y,
                  child: Opacity(
                    opacity: (0.1 +
                            (math.sin(
                                      _particleController.value * math.pi +
                                          index,
                                    ) +
                                    1) /
                                4)
                        .clamp(0.0, 1.0),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index % 2 == 0 ? primaryColor : secondaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: (index % 2 == 0
                                    ? primaryColor
                                    : secondaryColor)
                                .withValues(alpha: 0.5),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // 2. Main Glassmorphic Card
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 450, // Fixed width for consistency
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: theme.cardColor.withValues(
                      alpha: isDark ? 0.3 : 0.7,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image Processing Visualizer
                      SizedBox(
                        height: 280,
                        width: 280,
                        child: AnimatedBuilder(
                          animation: Listenable.merge([
                            _progressAnimation,
                            _pulseController,
                          ]),
                          builder: (context, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                // Pulsing Glow
                                Container(
                                  width: 260,
                                  height: 260,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        primaryColor.withValues(
                                          alpha: 0.2 * _pulseController.value,
                                        ),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),

                                // Rotating Rings
                                Transform.rotate(
                                  angle:
                                      _particleController.value * 2 * math.pi,
                                  child: Container(
                                    width: 240,
                                    height: 240,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: primaryColor.withValues(
                                          alpha: 0.1,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Transform.rotate(
                                  angle:
                                      -_particleController.value * 2 * math.pi,
                                  child: Container(
                                    width: 220,
                                    height: 220,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: secondaryColor.withValues(
                                          alpha: 0.1,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),

                                // The Image
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 20,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        kIsWeb && widget.imageBytes != null
                                            ? Image.memory(
                                              widget.imageBytes!,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.file(
                                              widget.imageFile,
                                              fit: BoxFit.cover,
                                            ),

                                        // Scanning Line
                                        AnimatedBuilder(
                                          animation: _particleController,
                                          builder: (context, _) {
                                            return Positioned(
                                              top:
                                                  (_particleController.value *
                                                      200) -
                                                  10,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      primaryColor,
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: primaryColor,
                                                      blurRadius: 10,
                                                      spreadRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Percentage Text
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Text(
                            '${(_progressAnimation.value * 100).toInt()}%',
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: primaryColor,
                              letterSpacing: -1,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 8),

                      // Step Text
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _steps[_currentStep],
                          key: ValueKey(_currentStep),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Premium Progress Bar
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.dividerColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progressAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primaryColor, secondaryColor],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withValues(
                                        alpha: 0.5,
                                      ),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Size Reduction Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSizeBadge(
                            context,
                            'Original',
                            '10.0 MB',
                            false,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: theme.disabledColor,
                              size: 16,
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              final currentSize =
                                  10.0 - (_progressAnimation.value * 9.0);
                              return _buildSizeBadge(
                                context,
                                'Compressed',
                                '${currentSize.toStringAsFixed(1)} MB',
                                true,
                              );
                            },
                          ),
                        ],
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

  Widget _buildSizeBadge(
    BuildContext context,
    String label,
    String size,
    bool isActive,
  ) {
    final theme = Theme.of(context);
    final color = isActive ? theme.colorScheme.primary : theme.disabledColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color.withValues(alpha: 0.7),
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            size,
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
