# DeepFract - Screens Overview

## 1. Splash Screen
**File:** `lib/screens/splash_screen.dart`

**Purpose:** App launch screen with branding

**Elements:**
- Blue background
- White rounded square icon container
- "DeepFract" title in white
- "Fractal Image Compression" tagline
- Loading spinner at bottom

**Behavior:**
- Displays for 2.5 seconds
- Checks if onboarding is completed via SharedPreferences
- Routes to Onboarding (first time) or Home (returning user)

**Layout:**
```
┌─────────────────────────┐
│                         │
│         ┌─────┐         │
│         │ 🔄  │         │  Icon
│         └─────┘         │
│                         │
│       DeepFract         │  Title
│                         │
│ Fractal Image          │  Tagline
│    Compression         │
│                         │
│          ○              │  Loading
│                         │
└─────────────────────────┘
```

---

## 2. Onboarding Screen - Page 1
**File:** `lib/screens/onboarding_screen.dart`

**Purpose:** Introduce fractal compression concept

**Elements:**
- Skip button (top-right)
- Large icon/illustration area
- "Fractal Compression" title
- Description text
- Page indicators (dots)
- Previous/Next arrows

**Layout:**
```
┌─────────────────────────┐
│                    Skip │  Skip Button
│                         │
│                         │
│       ┌─────┐           │
│       │ 📊  │           │  Illustration
│       └─────┘           │
│                         │
│  Fractal Compression    │  Title
│                         │
│ Advanced compression    │  Description
│ using fractal math      │
│                         │
│  ◀   ● ○ ○   ▶         │  Navigation
│                         │
└─────────────────────────┘
```

---

## 3. Onboarding Screen - Page 2
**File:** `lib/screens/onboarding_screen.dart`

**Purpose:** Explain AI-powered features

**Elements:**
- Skip button (top-right)
- Large icon/illustration area
- "AI-Powered" title
- Description text
- Page indicators (dots - page 2 active)
- Previous/Next arrows

**Layout:**
```
┌─────────────────────────┐
│                    Skip │  Skip Button
│                         │
│                         │
│       ┌─────┐           │
│       │ 🧠  │           │  Illustration
│       └─────┘           │
│                         │
│      AI-Powered         │  Title
│                         │
│ Leveraging AI for       │  Description
│   optimal results       │
│                         │
│  ◀   ○ ● ○   ▶         │  Navigation
│                         │
└─────────────────────────┘
```

---

## 4. Onboarding Screen - Page 3
**File:** `lib/screens/onboarding_screen.dart`

**Purpose:** Enable image upload

**Elements:**
- NO skip button (last page)
- Large icon/illustration area
- "Easy to Use" title
- Description text
- "Upload from Gallery" button (filled)
- "Take Photo" button (outlined)
- Page indicators (dots - page 3 active)
- Previous arrow only (no next)

**Layout:**
```
┌─────────────────────────┐
│                         │  (No Skip)
│                         │
│       ┌─────┐           │
│       │ ☁️  │           │  Illustration
│       └─────┘           │
│                         │
│     Easy to Use         │  Title
│                         │
│  Upload your image      │  Description
│ and let AI do the work  │
│                         │
│ ┌─────────────────────┐ │  Upload Gallery
│ │ 📷 Upload from...   │ │  Button (Filled)
│ └─────────────────────┘ │
│ ┌─────────────────────┐ │  Take Photo
│ │ 📸 Take Photo       │ │  Button (Outlined)
│ └─────────────────────┘ │
│                         │
│  ◀   ○ ○ ●             │  Navigation
│                         │
└─────────────────────────┘
```

---

## 5. Image Source Modal
**File:** `lib/services/image_picker_service.dart`

**Purpose:** Choose image source

**Elements:**
- Modal bottom sheet
- "Choose Image Source" header
- Gallery option with icon
- Camera option with icon

**Layout:**
```
┌─────────────────────────┐
│                         │
│  Choose Image Source    │  Header
│                         │
│  📁  Gallery            │  Gallery Option
│  ─────────────────      │
│  📷  Camera             │  Camera Option
│                         │
└─────────────────────────┘
```

---

## 6. Home Screen (No Image)
**File:** `lib/screens/home_screen.dart`

**Purpose:** Main app screen for compression

**Elements:**
- App bar with "DeepFract" title
- Large image preview area (placeholder)
- "Select Image" button (filled)
- "Compress Image" button (outlined, disabled)
- Info text about backend

**Layout:**
```
┌─────────────────────────┐
│      DeepFract          │  App Bar
├─────────────────────────┤
│                         │
│  ┌───────────────────┐  │
│  │                   │  │
│  │        🖼️         │  │  Image Preview
│  │   No image        │  │  (Placeholder)
│  │   selected        │  │
│  │                   │  │
│  └───────────────────┘  │
│                         │
│ ┌─────────────────────┐ │  Select Image
│ │ 🖼️ Select Image    │ │  Button
│ └─────────────────────┘ │
│ ┌─────────────────────┐ │  Compress Button
│ │ 🗜️ Compress Image   │ │  (Disabled)
│ └─────────────────────┘ │
│                         │
│  Backend compression    │  Info Text
│  will be implemented    │
│                         │
└─────────────────────────┘
```

---

## 7. Home Screen (With Image)
**File:** `lib/screens/home_screen.dart`

**Purpose:** Display selected image and enable compression

**Elements:**
- App bar with "DeepFract" title
- Large image preview (actual image)
- "Select Image" button (filled)
- "Compress Image" button (outlined, ENABLED)
- Info text about backend

**Layout:**
```
┌─────────────────────────┐
│      DeepFract          │  App Bar
├─────────────────────────┤
│                         │
│  ┌───────────────────┐  │
│  │                   │  │
│  │   [USER IMAGE]    │  │  Selected Image
│  │                   │  │
│  │                   │  │
│  │                   │  │
│  └───────────────────┘  │
│                         │
│ ┌─────────────────────┐ │  Select Image
│ │ 🖼️ Select Image    │ │  Button
│ └─────────────────────┘ │
│ ┌─────────────────────┐ │  Compress Button
│ │ 🗜️ Compress Image   │ │  (ENABLED)
│ └─────────────────────┘ │
│                         │
│  Backend compression    │  Info Text
│  will be implemented    │
│                         │
└─────────────────────────┘
```

---

## User Flow Diagram

```
┌──────────┐
│  Launch  │
│   App    │
└────┬─────┘
     │
     ▼
┌──────────────┐
│   Splash     │
│   Screen     │  (2.5s delay)
└──────┬───────┘
       │
       ├─────────────┐
       │             │
  First Time    Returning
    User          User
       │             │
       ▼             ▼
┌─────────────┐  ┌──────────┐
│ Onboarding  │  │   Home   │
│   Page 1    │  │  Screen  │
└──────┬──────┘  └────┬─────┘
       │              │
  Next or Skip        │
       │              │
       ▼              │
┌─────────────┐       │
│ Onboarding  │       │
│   Page 2    │       │
└──────┬──────┘       │
       │              │
  Next or Skip        │
       │              │
       ▼              │
┌─────────────┐       │
│ Onboarding  │       │
│   Page 3    │       │
└──────┬──────┘       │
       │              │
  Upload Image        │
       │              │
       ├──────────────┘
       │
       ▼
   ┌──────────┐
   │   Home   │
   │  Screen  │
   └──────────┘
```

---

## Color Scheme

**Theme:** Minimal Flat Design

| Element | Color | Hex Code |
|---------|-------|----------|
| Primary | Blue | #2196F3 |
| Secondary | Light Blue | #64B5F6 |
| Background | Light Gray | #F5F5F5 |
| Surface | White | #FFFFFF |
| Text Primary | Dark Gray | #212121 |
| Text Secondary | Medium Gray | #757575 |
| Accent | Accent Blue | #42A5F5 |
| Error | Red | #E53935 |

---

## Interactive Elements

### Buttons
1. **Filled Button** (Primary action)
   - Blue background (#2196F3)
   - White text
   - 12px rounded corners
   - No shadow (flat)
   - 16px vertical padding

2. **Outlined Button** (Secondary action)
   - Transparent background
   - Blue border (2px)
   - Blue text
   - 12px rounded corners
   - 16px vertical padding

3. **Text Button** (Tertiary action - Skip)
   - No background
   - Blue text
   - No border

### Icons
- Material Icons used throughout
- 24px default size
- Primary blue color (#2196F3)
- Larger icons (80-120px) for illustrations

### Page Indicators
- Expanding dots effect
- Active: Blue solid circle
- Inactive: Blue 30% opacity
- Smooth animations

---

## Responsiveness

- All screens use `SingleChildScrollView` where needed
- Padding: 24px standard
- Images scale to container width
- Buttons span full width for better mobile UX
- Safe areas respected (notches, status bars)

---

## Animations

1. **Page Transitions**
   - 300ms ease-in-out curve
   - Smooth horizontal slide

2. **Page Indicators**
   - Expanding dots effect
   - Smooth color transition

3. **Loading**
   - Circular progress indicator
   - Continuous rotation

4. **Navigation**
   - Standard Material page transitions
   - Push/Pop animations

---

## Accessibility

- Semantic widget usage
- Proper contrast ratios
- Touchable areas (48x48 minimum)
- Clear visual hierarchy
- Descriptive button labels

