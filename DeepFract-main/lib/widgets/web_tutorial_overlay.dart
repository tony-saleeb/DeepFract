import 'dart:ui';
import 'package:flutter/material.dart';
import 'premium_button.dart';

enum ContentPosition {
  bottom,
  bottomLeft,
  bottomRight,
  top,
  topLeft,
  topRight,
  left,
  right,
  center,
}

class TutorialStep {
  final GlobalKey key;
  final String title;
  final String description;
  final ContentPosition position;

  TutorialStep({
    required this.key,
    required this.title,
    required this.description,
    this.position = ContentPosition.bottom,
  });
}

class WebTutorialOverlay extends StatefulWidget {
  final List<TutorialStep> steps;
  final VoidCallback onComplete;

  const WebTutorialOverlay({
    super.key,
    required this.steps,
    required this.onComplete,
  });

  static void show(BuildContext context, List<TutorialStep> steps) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => WebTutorialOverlay(
            steps: steps,
            onComplete: () {
              overlayEntry.remove();
            },
          ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  State<WebTutorialOverlay> createState() => _WebTutorialOverlayState();
}

class _WebTutorialOverlayState extends State<WebTutorialOverlay> {
  int _currentIndex = 0;
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTargetRect();
    });
  }

  void _updateTargetRect() {
    final key = widget.steps[_currentIndex].key;
    final context = key.currentContext;
    if (context != null) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      setState(() {
        _targetRect = position & size;
      });
    }
  }

  void _nextStep() {
    if (_currentIndex < widget.steps.length - 1) {
      setState(() {
        _currentIndex++;
        _targetRect =
            null; // Reset to trigger recalculation or hide temporarily
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateTargetRect();
      });
    } else {
      widget.onComplete();
    }
  }

  void _previousStep() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _targetRect = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateTargetRect();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_currentIndex];
    final isLast = _currentIndex == widget.steps.length - 1;
    final isFirst = _currentIndex == 0;

    // Window size (approximate or fixed)
    const double windowWidth = 380.0;

    return Stack(
      children: [
        // Dimmed background
        Positioned.fill(
          child: GestureDetector(
            onTap: () {},
            child: Container(color: Colors.black.withValues(alpha: 0.4)),
          ),
        ),

        // The Floating Window
        if (_targetRect != null)
          _buildPositionedWindow(context, step, isFirst, isLast, windowWidth),

        // Highlight the target
        if (_targetRect != null)
          Positioned(
            top: _targetRect!.top,
            left: _targetRect!.left,
            width: _targetRect!.width,
            height: _targetRect!.height,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPositionedWindow(
    BuildContext context,
    TutorialStep step,
    bool isFirst,
    bool isLast,
    double width,
  ) {
    const double spacing = 24.0;

    // Determine positioning properties
    double? top;
    double? bottom;
    double? left;
    double? right;

    switch (step.position) {
      case ContentPosition.bottom:
        top = _targetRect!.bottom + spacing;
        left = _targetRect!.center.dx - (width / 2);
        break;
      case ContentPosition.bottomLeft:
        top = _targetRect!.bottom + spacing;
        left = _targetRect!.left;
        break;
      case ContentPosition.bottomRight:
        top = _targetRect!.bottom + spacing;
        right = MediaQuery.of(context).size.width - _targetRect!.right;
        break;
      case ContentPosition.top:
        bottom =
            MediaQuery.of(context).size.height - _targetRect!.top + spacing;
        left = _targetRect!.center.dx - (width / 2);
        break;
      case ContentPosition.topLeft:
        bottom =
            MediaQuery.of(context).size.height - _targetRect!.top + spacing;
        left = _targetRect!.left;
        break;
      case ContentPosition.topRight:
        bottom =
            MediaQuery.of(context).size.height - _targetRect!.top + spacing;
        right = MediaQuery.of(context).size.width - _targetRect!.right;
        break;
      case ContentPosition.left:
        top = _targetRect!.center.dy - 100;
        right = MediaQuery.of(context).size.width - _targetRect!.left + spacing;
        break;
      case ContentPosition.right:
        top = _targetRect!.center.dy - 100;
        left = _targetRect!.right + spacing;
        break;
      case ContentPosition.center:
        top = _targetRect!.center.dy - 100;
        left = _targetRect!.center.dx - (width / 2);
        break;
    }

    // Ensure we don't go off screen (basic clamping)
    final screenWidth = MediaQuery.of(context).size.width;
    if (left != null) {
      left = left.clamp(16.0, screenWidth - width - 16.0);
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              width: width,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.lightbulb,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          step.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      if (!isLast)
                        TextButton(
                          onPressed: widget.onComplete,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: Theme.of(context).disabledColor,
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    step.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.color?.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Footer
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Step ${_currentIndex + 1} of ${widget.steps.length}',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Previous Button
                      if (!isFirst)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: PremiumButton(
                            text: 'Back',
                            onPressed: _previousStep,
                            isPrimary: false,
                          ),
                        ),

                      // Next/Finish Button
                      PremiumButton(
                        text: isLast ? 'Finish' : 'Next',
                        onPressed: _nextStep,
                        isPrimary: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
