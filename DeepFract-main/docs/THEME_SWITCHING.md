# Theme Switching Feature

## Overview

The app now supports modern light and dark theme switching with a beautiful sun/moon toggle button. The theme preference is persisted across app restarts using SharedPreferences.

## Features

### 🎨 Light & Dark Themes
- **Light Theme**: Clean minimal design with blue primary color (#2196F3)
- **Dark Theme**: Modern dark design with lighter blue (#42A5F5) and dark backgrounds

### 🌓 Theme Toggle Button

**Onboarding Screen:**
- Located at **top-left corner**
- Modern rounded container with subtle background
- Animated icon transition (rotation + fade)
- Moon icon 🌙 for light mode (click to go dark)
- Sun icon ☀️ for dark mode (click to go light)

**Home Screen:**
- Located in **app bar actions** (top-right)
- Same animated icon transition
- Includes tooltip text

### 💾 Persistence
- Theme choice is saved to device storage
- Preference persists across app restarts
- Uses SharedPreferences for storage

## Implementation Details

### Files Added/Modified

**New Files:**
1. `lib/utils/theme_provider.dart` - State management for theme switching

**Modified Files:**
1. `lib/utils/theme.dart` - Added dark theme configuration
2. `lib/main.dart` - Integrated Provider and theme management
3. `lib/screens/onboarding_screen.dart` - Added sun/moon toggle at top-left
4. `lib/screens/home_screen.dart` - Added theme toggle in app bar
5. `lib/screens/splash_screen.dart` - Updated to respect theme
6. `pubspec.yaml` - Added provider package

### Dependencies Added

```yaml
provider: ^6.1.1  # State management for theme
```

## Theme Colors

### Light Theme
```dart
Primary Color:        #2196F3 (Blue)
Secondary Color:      #64B5F6 (Light Blue)
Background Color:     #F5F5F5 (Light Gray)
Surface Color:        #FFFFFF (White)
Text Primary:         #212121 (Dark Gray)
Text Secondary:       #757575 (Medium Gray)
```

### Dark Theme
```dart
Primary Color:        #42A5F5 (Lighter Blue)
Secondary Color:      #64B5F6 (Light Blue)
Background Color:     #121212 (Dark Background)
Surface Color:        #1E1E1E (Dark Surface)
Text Primary:         #E0E0E0 (Light Gray)
Text Secondary:       #B0B0B0 (Medium Gray)
```

## Usage

### In Onboarding Screen

The theme toggle appears at the top-left corner:

```
┌─────────────────────────┐
│ 🌙              Skip    │  ← Theme toggle at top-left
│                         │
│       Onboarding        │
│        Content          │
│                         │
└─────────────────────────┘
```

### In Home Screen

The theme toggle appears in the app bar:

```
┌─────────────────────────┐
│ DeepFract           ☀️  │  ← Theme toggle in app bar
├─────────────────────────┤
│                         │
│      App Content        │
│                         │
└─────────────────────────┘
```

## Animation Details

The theme toggle button features smooth animations:

1. **Rotation Transition**: Icon rotates when switching
2. **Fade Transition**: Smooth opacity change
3. **Duration**: 300ms for smooth feel
4. **Icon Change**: Moon ↔ Sun with AnimatedSwitcher

## Code Example

### Toggle Theme Programmatically

```dart
// Get the theme provider
final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

// Toggle theme
themeProvider.toggleTheme();

// Set specific theme
themeProvider.setThemeMode(ThemeMode.dark);
themeProvider.setThemeMode(ThemeMode.light);

// Check current theme
bool isDark = themeProvider.isDarkMode;
```

### Access Theme in Widgets

```dart
// Listen to theme changes
final themeProvider = Provider.of<ThemeProvider>(context);
bool isDark = themeProvider.isDarkMode;

// Without listening (for one-time actions)
final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
```

## Technical Architecture

### State Management Flow

```
User Taps Toggle
      ↓
ThemeProvider.toggleTheme()
      ↓
Update ThemeMode State
      ↓
Save to SharedPreferences
      ↓
notifyListeners()
      ↓
Rebuild UI with new theme
```

### Theme Provider Class

```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  Future<void> toggleTheme() async {
    // Toggle and save
  }
}
```

## UI/UX Benefits

### ✅ User Experience
- Smooth, modern animations
- Persistent preference
- Easy to find toggle button
- Clear visual feedback
- Works across all screens

### ✅ Accessibility
- High contrast in both themes
- Clear icon meanings (universal sun/moon symbols)
- Tooltip text for clarity
- Smooth transitions (not jarring)

### ✅ Modern Design
- Follows Material Design 3 guidelines
- Minimal flat design maintained
- Consistent across all screens
- Professional appearance

## Testing the Feature

### First Launch
1. App starts in light mode (default)
2. Navigate to onboarding
3. Tap moon icon (top-left) → Switches to dark mode
4. Theme immediately updates across entire screen

### Theme Persistence
1. Switch to dark mode
2. Close app completely
3. Reopen app
4. App starts in dark mode (preference saved)

### Animation Test
1. Tap theme toggle rapidly
2. Observe smooth rotation and fade
3. No lag or stuttering
4. Icon changes correctly

## Future Enhancements

Potential improvements for future updates:

1. **System Theme**: Follow device theme automatically
2. **Schedule**: Auto-switch based on time of day
3. **More Themes**: Add additional color schemes
4. **Accent Colors**: Allow user to customize colors
5. **Theme Preview**: Show preview before applying

## Troubleshooting

### Theme Not Persisting
- Check SharedPreferences permissions
- Ensure app has storage access
- Clear app data and retry

### Animation Issues
- Check Flutter version compatibility
- Ensure Material Design 3 is enabled
- Verify AnimatedSwitcher is working

### Icons Not Showing
- Verify Material Icons are included
- Check icon names are correct
- Ensure proper imports

## Conclusion

The theme switching feature is fully implemented with:
- ✅ Modern sun/moon toggle UI
- ✅ Top-left placement on onboarding
- ✅ Smooth animations
- ✅ Persistent preferences
- ✅ Complete dark theme
- ✅ Zero code issues
- ✅ Works across all screens

The feature enhances user experience by providing customization options and respecting user preferences for light or dark interfaces.

