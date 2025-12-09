import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../services/auth_service.dart';
import '../utils/theme_provider.dart';
import '../widgets/theme_switcher.dart';
import '../widgets/animated_background.dart';

/// Premium profile screen with modern design.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Show web-specific design on web platform
    if (kIsWeb) {
      return const _WebProfileScreen();
    }
    return const _MobileProfileScreen();
  }
}

/// Web-specific profile screen with modern spacious design
class _WebProfileScreen extends StatefulWidget {
  const _WebProfileScreen();

  @override
  State<_WebProfileScreen> createState() => _WebProfileScreenState();
}

class _WebProfileScreenState extends State<_WebProfileScreen> {
  bool _imageLoadError = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 900;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          const AnimatedBackground(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top navigation bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      // Back button
                      _buildNavButton(
                        context,
                        icon: Icons.arrow_back_rounded,
                        label: 'Back to Home',
                        onTap: () => Navigator.pop(context),
                        primaryColor: primaryColor,
                        isDark: isDark,
                      ),
                      const Spacer(),
                      // Page title
                      Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      // Placeholder for balance
                      const SizedBox(width: 140),
                    ],
                  ),
                ),

                // Content area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child:
                            isWideScreen
                                ? _buildWideLayout(
                                  context,
                                  user,
                                  authService,
                                  isDark,
                                  primaryColor,
                                  secondaryColor,
                                  themeProvider,
                                )
                                : _buildNarrowLayout(
                                  context,
                                  user,
                                  authService,
                                  isDark,
                                  primaryColor,
                                  secondaryColor,
                                  themeProvider,
                                ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color primaryColor,
    required bool isDark,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : primaryColor.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: primaryColor),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideLayout(
    BuildContext context,
    User? user,
    AuthService authService,
    bool isDark,
    Color primaryColor,
    Color secondaryColor,
    ThemeProvider themeProvider,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left panel - Profile info
        Expanded(
          flex: 2,
          child: _buildProfileCard(
            context,
            user,
            isDark,
            primaryColor,
            secondaryColor,
          ),
        ),
        const SizedBox(width: 32),
        // Right panel - Settings
        Expanded(
          flex: 3,
          child: _buildSettingsCard(
            context,
            user,
            authService,
            isDark,
            primaryColor,
            themeProvider,
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(
    BuildContext context,
    User? user,
    AuthService authService,
    bool isDark,
    Color primaryColor,
    Color secondaryColor,
    ThemeProvider themeProvider,
  ) {
    return Column(
      children: [
        _buildProfileCard(context, user, isDark, primaryColor, secondaryColor),
        const SizedBox(height: 24),
        _buildSettingsCard(
          context,
          user,
          authService,
          isDark,
          primaryColor,
          themeProvider,
        ),
      ],
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    User? user,
    bool isDark,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isDark
                      ? [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                      ]
                      : [
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.85),
                      ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : primaryColor.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.15),
                blurRadius: 50,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            children: [
              // Profile avatar with gradient border
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, secondaryColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.5),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
                    border: Border.all(
                      color: isDark ? const Color(0xFF2D2D44) : Colors.white,
                      width: 5,
                    ),
                  ),
                  child: ClipOval(
                    child: _buildProfileImage(user, primaryColor),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // User name with gradient
              ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      colors: [primaryColor, secondaryColor],
                    ).createShader(bounds),
                child: Text(
                  user?.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Email with icon
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 16,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user?.email ?? 'No email',
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  if (user?.emailVerified == true) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 32),

              // Stats grid
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.black.withValues(alpha: 0.2)
                          : primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      value: '0',
                      label: 'Compressions',
                      icon: Icons.compress_rounded,
                      color: primaryColor,
                      isDark: isDark,
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                    _buildStatItem(
                      context,
                      value: '0 MB',
                      label: 'Saved',
                      icon: Icons.savings_outlined,
                      color: Colors.green,
                      isDark: isDark,
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                    _buildStatItem(
                      context,
                      value: _formatMemberSince(user?.metadata.creationTime),
                      label: 'Member',
                      icon: Icons.calendar_today_rounded,
                      color: secondaryColor,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Version info
              Text(
                'DeepFract v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white30 : Colors.black26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(User? user, Color primaryColor) {
    if (user?.photoURL != null && !_imageLoadError) {
      // For web, use a CORS-friendly approach
      final photoUrl = user!.photoURL!;

      return Image.network(
        photoUrl,
        fit: BoxFit.cover,
        width: 140,
        height: 140,
        // Add headers for CORS
        headers: const {'Access-Control-Allow-Origin': '*'},
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
              strokeWidth: 2,
              color: primaryColor,
            ),
          );
        },
        errorBuilder: (_, error, stackTrace) {
          debugPrint('Profile image load error: $error');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_imageLoadError) {
              setState(() => _imageLoadError = true);
            }
          });
          return _buildAvatarFallback(user, primaryColor);
        },
      );
    }
    return _buildAvatarFallback(user, primaryColor);
  }

  Widget _buildAvatarFallback(User? user, Color primaryColor) {
    final initial =
        (user?.displayName?.isNotEmpty == true)
            ? user!.displayName![0].toUpperCase()
            : (user?.email?.isNotEmpty == true)
            ? user!.email![0].toUpperCase()
            : 'U';
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    User? user,
    AuthService authService,
    bool isDark,
    Color primaryColor,
    ThemeProvider themeProvider,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isDark
                      ? [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                      ]
                      : [
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.85),
                      ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : primaryColor.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 40,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.settings_rounded,
                      color: primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Appearance section
              _buildSectionHeader(context, 'Appearance', isDark),
              const SizedBox(height: 16),
              _buildSettingsTile(
                context,
                isDark: isDark,
                icon:
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                iconColor: Colors.amber,
                title: 'Dark Mode',
                subtitle:
                    isDark
                        ? 'Currently using dark theme'
                        : 'Currently using light theme',
                trailing: Switch(
                  value: isDark,
                  onChanged: (_) {
                    ThemeSwitcher.of(context).changeTheme(() {
                      themeProvider.toggleTheme();
                    });
                  },
                  activeColor: primaryColor,
                ),
              ),

              const SizedBox(height: 32),

              // General section
              _buildSectionHeader(context, 'General', isDark),
              const SizedBox(height: 16),
              _buildSettingsTile(
                context,
                isDark: isDark,
                icon: Icons.info_outline_rounded,
                iconColor: primaryColor,
                title: 'About DeepFract',
                subtitle: 'Version, licenses, and more',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                onTap: () => Navigator.pushNamed(context, '/about'),
              ),

              const SizedBox(height: 16),

              _buildSettingsTile(
                context,
                isDark: isDark,
                icon: Icons.help_outline_rounded,
                iconColor: Colors.blue,
                title: 'Help & Feedback',
                subtitle: 'Get help or send feedback',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help section coming soon!')),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Sign out button
              _buildSignOutButton(context, authService, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isDark) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: isDark ? Colors.white38 : Colors.black38,
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : primaryColor.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(
    BuildContext context,
    AuthService authService,
    bool isDark,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await authService.signOut();
          if (context.mounted) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/auth', (route) => false);
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.withValues(alpha: 0.15),
                Colors.red.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withValues(alpha: 0.25)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: Colors.red, size: 22),
              SizedBox(width: 12),
              Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatMemberSince(DateTime? date) {
    if (date == null) return 'New';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays < 30) return '${diff.inDays}d';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo';
    return '${(diff.inDays / 365).floor()}y';
  }
}

/// Mobile profile screen (original design)
class _MobileProfileScreen extends StatelessWidget {
  const _MobileProfileScreen();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDark
                    ? [
                      primaryColor.withValues(alpha: 0.2),
                      Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context).scaffoldBackgroundColor,
                    ]
                    : [
                      primaryColor.withValues(alpha: 0.1),
                      Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      _buildIconButton(
                        context,
                        Icons.arrow_back_ios_new,
                        () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 44), // Balance the back button
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Profile Avatar with glow effect
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withValues(alpha: 0.6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Colors.grey[900] : Colors.white,
                      border: Border.all(
                        color: isDark ? Colors.grey[800]! : Colors.white,
                        width: 4,
                      ),
                    ),
                    child:
                        user?.photoURL != null
                            ? ClipOval(
                              child: Image.network(
                                user!.photoURL!,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) =>
                                        _buildAvatarContent(user, primaryColor),
                              ),
                            )
                            : _buildAvatarContent(user, primaryColor),
                  ),
                ),

                const SizedBox(height: 20),

                // User name with verified badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user?.displayName ?? 'User',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (user?.emailVerified == true) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 6),

                // User email
                Text(
                  user?.email ?? 'No email',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),

                const SizedBox(height: 32),

                // Stats row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                      ],
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          context,
                          '0',
                          'Compressions',
                          primaryColor,
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                        _buildStatItem(context, '0 MB', 'Saved', primaryColor),
                        Container(
                          height: 40,
                          width: 1,
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                        _buildStatItem(
                          context,
                          _formatMemberSince(user?.metadata.creationTime),
                          'Member',
                          primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Settings Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 12),
                        child: Text(
                          'SETTINGS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white38 : Colors.black38,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      _buildSettingsCard(
                        context,
                        isDark,
                        children: [
                          _buildSettingsTile(
                            context,
                            icon: isDark ? Icons.dark_mode : Icons.light_mode,
                            iconColor: Colors.amber,
                            title: 'Dark Mode',
                            trailing: Switch(
                              value: isDark,
                              onChanged: (_) {
                                ThemeSwitcher.of(context).changeTheme(() {
                                  themeProvider.toggleTheme();
                                });
                              },
                              activeColor: primaryColor,
                            ),
                          ),
                          _buildDivider(isDark),
                          _buildSettingsTile(
                            context,
                            icon: Icons.notifications_outlined,
                            iconColor: Colors.red,
                            title: 'Notifications',
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                            onTap: () {},
                          ),
                          _buildDivider(isDark),
                          _buildSettingsTile(
                            context,
                            icon: Icons.security_outlined,
                            iconColor: Colors.green,
                            title: 'Privacy & Security',
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 12),
                        child: Text(
                          'ACCOUNT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white38 : Colors.black38,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      _buildSettingsCard(
                        context,
                        isDark,
                        children: [
                          _buildSettingsTile(
                            context,
                            icon: Icons.help_outline,
                            iconColor: Colors.blue,
                            title: 'Help & Support',
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                            onTap: () {},
                          ),
                          _buildDivider(isDark),
                          _buildSettingsTile(
                            context,
                            icon: Icons.info_outline,
                            iconColor: Colors.purple,
                            title: 'About',
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                            onTap: () => Navigator.pushNamed(context, '/about'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Sign out button
                      _buildSettingsCard(
                        context,
                        isDark,
                        children: [
                          _buildSettingsTile(
                            context,
                            icon: Icons.logout,
                            iconColor: Colors.red,
                            title: 'Sign Out',
                            titleColor: Colors.red,
                            onTap: () async {
                              await authService.signOut();
                              if (context.mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/auth',
                                  (route) => false,
                                );
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // App version
                      Center(
                        child: Text(
                          'DeepFract v1.0.0',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white24 : Colors.black26,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color:
              isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildAvatarContent(User? user, Color primaryColor) {
    final initial =
        (user?.displayName?.isNotEmpty == true)
            ? user!.displayName![0].toUpperCase()
            : (user?.email?.isNotEmpty == true)
            ? user!.email![0].toUpperCase()
            : 'U';
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 44,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    Color primaryColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    bool isDark, {
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
        ],
        border: Border.all(color: isDark ? Colors.white10 : Colors.transparent),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color:
                        titleColor ?? (isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(left: 70),
      height: 1,
      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
    );
  }

  String _formatMemberSince(DateTime? date) {
    if (date == null) return 'New';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays < 30) return '${diff.inDays}d';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo';
    return '${(diff.inDays / 365).floor()}y';
  }
}
