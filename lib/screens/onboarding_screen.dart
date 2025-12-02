import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../utils/theme_provider.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingCompleteKey, true);
    
    if (!mounted) return;
    
    // Navigate to home screen
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToLastPage() {
    _pageController.animateToPage(
      2, // Jump to page 3 (index 2)
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            themeProvider.toggleTheme();
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: AnimatedSwitcher(
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
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with theme toggle and skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Theme toggle button (sun/moon)
                  _buildThemeToggle(context),
                  
                  // Skip button (only on first two pages)
                  if (_currentPage < 2)
                    TextButton(
                      onPressed: _skipToLastPage,
                      child: Text(
                        AppConstants.skipButton,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: const [
                  OnboardingPage(
                    title: AppConstants.onboarding1Title,
                    description: AppConstants.onboarding1Description,
                    imagePath: AppConstants.onboarding1Image,
                  ),
                  OnboardingPage(
                    title: AppConstants.onboarding2Title,
                    description: AppConstants.onboarding2Description,
                    imagePath: AppConstants.onboarding2Image,
                  ),
                  OnboardingPage(
                    title: AppConstants.onboarding3Title,
                    description: AppConstants.onboarding3Description,
                    imagePath: AppConstants.onboarding3Image,
                  ),
                ],
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: ExpandingDotsEffect(
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  dotColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 4,
                ),
              ),
            ),

            // Bottom navigation buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button (only visible after first page)
                  if (_currentPage > 0)
                    IconButton(
                      onPressed: _previousPage,
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  else
                    const SizedBox(width: 48),

                  // Next/Get Started button
                  if (_currentPage < 2)
                    ElevatedButton.icon(
                      onPressed: _nextPage,
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(AppConstants.nextButton),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: _completeOnboarding,
                      icon: const Icon(Icons.check),
                      label: Text(AppConstants.getStartedButton),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
