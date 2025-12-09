import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'animated_theme_toggle.dart';

class WebNavbar extends StatelessWidget {
  final GlobalKey? logoKey;
  final GlobalKey? themeToggleKey;
  final VoidCallback? onHomeTap;

  const WebNavbar({
    super.key,
    this.logoKey,
    this.themeToggleKey,
    this.onHomeTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).scaffoldBackgroundColor.withValues(alpha: 0.7),
            border: Border(
              bottom: BorderSide(
                color: primaryColor.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Logo and brand
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onHomeTap,
                  child: Row(
                    key: logoKey,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor,
                              Theme.of(context).colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.25),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.compress,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      ShaderMask(
                        shaderCallback:
                            (bounds) => LinearGradient(
                              colors: [
                                primaryColor,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ).createShader(bounds),
                        child: Text(
                          AppConstants.appName,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 26,
                            letterSpacing: -0.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Navigation items
              _buildNavItem(context, 'Home', true),
              const SizedBox(width: 32),
              _buildNavItem(context, 'Help', false),
              const SizedBox(width: 32),
              _buildNavItem(context, 'About', false),

              const SizedBox(width: 40),

              // Theme toggle - using reusable widget with ThemeSwitcher animation
              AnimatedThemeToggle(
                widgetKey: themeToggleKey,
                size: 22,
                padding: 12,
                useThemeSwitcherAnimation: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String text, bool isActive) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: text == 'Home' ? onHomeTap : () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                isActive
                    ? primaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(
              color:
                  isActive
                      ? primaryColor
                      : Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
