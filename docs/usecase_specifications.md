# DeepFract Use Case Specifications

> **Version:** 1.0  
> **Date:** December 2024  
> **Standard:** UML 2.0 Academic Standards

---

## Table of Contents

1. [User Authentication Use Cases](#user-authentication-use-cases)
2. [Image Management Use Cases](#image-management-use-cases)
3. [Compression Use Cases](#compression-use-cases)
4. [Result Management Use Cases](#result-management-use-cases)
5. [System Preferences Use Cases](#system-preferences-use-cases)
6. [Administration Use Cases](#administration-use-cases)

---

## User Authentication Use Cases

### UC-01: Login

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-01 |
| **Name** | Login |
| **Actor** | User |
| **Description** | Allows registered users to authenticate and access the DeepFract system using their credentials |
| **Preconditions** | User has a registered account; User is not currently logged in |
| **Postconditions** | User is authenticated and redirected to Home Screen |
| **Trigger** | User opens the app and selects login option |
| **Includes** | UC-02 (Login Verification) |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | User opens DeepFract application | System displays the Login Screen with email and password fields |
| 2 | User enters email address | System validates email format in real-time |
| 3 | User enters password | System masks password characters |
| 4 | User taps "Login" button | System validates that both fields are filled |
| 5 | | System calls Login Verification (UC-02) |
| 6 | | System displays loading indicator |
| 7 | | System receives authentication success from Firebase Auth |
| 8 | | System navigates to Home Screen |
| 9 | | System displays welcome message |

#### Alternative Flows

| ID | Condition | Steps |
|----|-----------|-------|
| A1 | Invalid email format | 2a. System shows "Invalid email format" error; Flow returns to step 2 |
| A2 | Empty fields | 4a. System shows "Please fill all fields" error; Flow returns to step 2 |
| A3 | Wrong credentials | 7a. Firebase returns authentication error; 7b. System shows "Invalid email or password"; Flow returns to step 2 |
| A4 | Network error | 6a. System detects no internet; 6b. System shows "Check your connection" error; Flow returns to step 4 |

---

### UC-02: Login Verification

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-02 |
| **Name** | Login Verification |
| **Actor** | Firebase Auth (Secondary Actor) |
| **Description** | Verifies user credentials against Firebase Authentication service |
| **Preconditions** | Valid email and password received from Login use case |
| **Postconditions** | User credentials are verified; Authentication token is generated |
| **Trigger** | Included by Login (UC-01) |

#### Main Success Scenario

| Step | System Action | Firebase Auth Response |
|------|---------------|------------------------|
| 1 | System sends email and password to Firebase Auth | Firebase receives authentication request |
| 2 | | Firebase validates email exists in database |
| 3 | | Firebase verifies password hash matches |
| 4 | | Firebase generates authentication token |
| 5 | | Firebase returns UserCredential object |
| 6 | System receives UserCredential | |
| 7 | System stores authentication state locally | |
| 8 | System returns success to calling use case | |

#### Alternative Flows

| ID | Condition | Steps |
|----|-----------|-------|
| A1 | Email not found | 2a. Firebase returns "user-not-found" error; System propagates error |
| A2 | Wrong password | 3a. Firebase returns "wrong-password" error; System propagates error |
| A3 | Account disabled | 3a. Firebase returns "user-disabled" error; System shows account disabled message |
| A4 | Too many attempts | 3a. Firebase returns "too-many-requests" error; System shows rate limit message |

---

### UC-03: Sign Up

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-03 |
| **Name** | Sign Up |
| **Actor** | User, Firebase Auth |
| **Description** | Allows new users to create an account in the DeepFract system |
| **Preconditions** | User does not have an existing account |
| **Postconditions** | New user account is created; User is automatically logged in |
| **Trigger** | User selects "Sign Up" or "Create Account" option |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | User navigates to Sign Up screen | System displays registration form (email, password, confirm password) |
| 2 | User enters email address | System validates email format |
| 3 | User enters password | System checks password strength (min 6 characters) |
| 4 | User enters confirm password | System validates passwords match |
| 5 | User taps "Sign Up" button | System validates all fields |
| 6 | | System sends registration request to Firebase Auth |
| 7 | | Firebase Auth creates new user account |
| 8 | | Firebase Auth returns UserCredential |
| 9 | | System creates user profile in Firestore |
| 10 | | System automatically logs in user |
| 11 | | System navigates to Home Screen |

#### Alternative Flows

| ID | Condition | Steps |
|----|-----------|-------|
| A1 | Email already exists | 7a. Firebase returns "email-already-in-use"; System shows "Email already registered" |
| A2 | Weak password | 3a. System shows "Password must be at least 6 characters" |
| A3 | Passwords don't match | 4a. System shows "Passwords do not match" |
| A4 | Invalid email | 2a. System shows "Please enter a valid email address" |

---

## Image Management Use Cases

### UC-04: View Home Screen

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-04 |
| **Name** | View Home Screen |
| **Actor** | User |
| **Description** | Displays the main interface where users can select images for compression |
| **Preconditions** | User is authenticated |
| **Postconditions** | Home screen is displayed with image selection options |
| **Trigger** | User completes login or navigates to home |
| **Extends** | UC-05 (Take A Photo), UC-06 (Select Image) |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | User is authenticated | System determines platform (Mobile/Web) |
| 2 | | System loads Home Screen layout |
| 3 | | System displays app header with navigation |
| 4 | | System shows image selection area (placeholder or instructions) |
| 5 | | System displays "Gallery" button |
| 6 | | System displays "Camera" button (mobile only) |
| 7 | | System shows "Compress" button (initially disabled) |
| 8 | User views home screen | System awaits user interaction |

#### Alternative Flows

| ID | Condition | Steps |
|----|-----------|-------|
| A1 | First-time user | 2a. System shows onboarding tutorial overlay |
| A2 | Web platform | 6a. Camera button is hidden or shows file upload only |
| A3 | Previous session exists | 4a. System may show last used image preview |

---

### UC-05: Take A Photo

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-05 |
| **Name** | Take A Photo |
| **Actor** | User |
| **Description** | Allows user to capture a photo using device camera for compression |
| **Preconditions** | User is on Home Screen; Device has a camera |
| **Postconditions** | Photo is captured and displayed in preview area |
| **Trigger** | User selects camera option (extends View Home Screen) |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | User taps "Camera" button | System checks camera permission status |
| 2 | | System requests camera permission if not granted |
| 3 | | System opens native camera interface |
| 4 | User positions camera and captures photo | Device captures image |
| 5 | User confirms the captured photo | System receives image file |
| 6 | | System reads image bytes |
| 7 | | System calculates original file size |
| 8 | | System displays image in preview area |
| 9 | | System enables "Compress" button |
| 10 | | System displays original file size information |

#### Alternative Flows

| ID | Condition | Steps |
|----|-----------|-------|
| A1 | Permission denied | 2a. System shows permission rationale dialog; 2b. User denies; 2c. System shows "Camera permission required" message |
| A2 | User cancels capture | 5a. User taps cancel; 5b. System returns to Home Screen without changes |
| A3 | Camera not available | 1a. System shows "Camera not available on this device" |
| A4 | User retakes photo | 5a. User taps retake; 5b. Flow returns to step 3 |

---

### UC-06: Select Image

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-06 |
| **Name** | Select Image |
| **Actor** | User |
| **Description** | Allows user to select an existing image from device gallery |
| **Preconditions** | User is on Home Screen |
| **Postconditions** | Selected image is displayed in preview area |
| **Trigger** | User selects gallery option (extends View Home Screen) |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | User taps "Gallery" button | System checks storage/photos permission |
| 2 | | System requests permission if not granted |
| 3 | | System opens native image picker |
| 4 | User browses through images | Device displays available images |
| 5 | User selects an image | System receives selected file |
| 6 | | System validates image format (JPG, PNG, etc.) |
| 7 | | System reads image bytes |
| 8 | | System calculates original file size |
| 9 | | System displays image in preview area |
| 10 | | System enables "Compress" button |
| 11 | | System displays original file size information |

#### Alternative Flows

| ID | Condition | Steps |
|----|-----------|-------|
| A1 | Permission denied | 2a. System shows permission dialog; 2b. User denies; 2c. System shows "Storage permission required" |
| A2 | User cancels selection | 5a. User taps cancel; 5b. System returns to Home Screen |
| A3 | Invalid format | 6a. System detects unsupported format; 6b. System shows "Unsupported image format" |
| A4 | File too large | 7a. System detects file > limit; 7b. System shows size warning |

---

## Compression Use Cases

### UC-07: Press Compress Button

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-07 |
| **Name** | Press Compress Button |
| **Actor** | User |
| **Description** | Initiates the AI-powered fractal compression process on the selected image |
| **Preconditions** | Image is selected/captured and displayed in preview |
| **Postconditions** | Image is compressed; Results are ready for display |
| **Trigger** | User taps the Compress button |
| **Includes** | UC-08 (View Compressed Image) |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | User taps "Compress" button | System validates image is selected |
| 2 | | System displays loading overlay with animation |
| 3 | | System shows progress indicator |
| 4 | | System starts compression timer |
| 5 | | System sends image to Compression Service |
| 6 | | Compression Service applies AI fractal algorithm |
| 7 | | Compression Service returns compressed image |
| 8 | | System receives compressed result |
| 9 | | System stops compression timer |
| 10 | | System calculates compression statistics |
| 11 | | System saves transaction to Firestore |
| 12 | | System hides loading overlay |
| 13 | | System navigates to View Compressed Image (UC-08) |

#### Alternative Flows

| ID | Condition | Steps |
|----|-----------|-------|
| A1 | No image selected | 1a. Button is disabled; No action occurs |
| A2 | Compression fails | 7a. Service returns error; 7b. System shows error dialog with retry option |
| A3 | Network error | 5a. System detects connection issue; 5b. System shows "Network error" with retry |
| A4 | User cancels | 3a. User taps cancel; 3b. System aborts compression; 3c. Returns to Home |
| A5 | Timeout | 6a. Request exceeds timeout; 6b. System shows timeout error |

---

### UC-08: View Compressed Image

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-08 |
| **Name** | View Compressed Image |
| **Actor** | User |
| **Description** | Displays the compression result with before/after comparison |
| **Preconditions** | Compression completed successfully |
| **Postconditions** | Compressed image and statistics are displayed |
| **Trigger** | Included by Press Compress Button (UC-07) |
| **Includes** | UC-09 (View Compression Statistics) |
| **Extends** | UC-10 (Share Compressed Image), UC-11 (Download Compressed Image) |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | | System navigates to Compression Result Screen |
| 2 | | System displays compressed image in main view |
| 3 | | System shows before/after toggle or comparison slider |
| 4 | | System displays compression statistics (UC-09) |
| 5 | | System shows action buttons (Share, Download, New Compression) |
| 6 | User views the result | System awaits user interaction |
| 7 | User can toggle between original/compressed | System updates image preview accordingly |
| 8 | User can zoom/pan the image | System enables gesture controls |

#### Alternative Flows

| ID | Condition | Steps |
|----|-----------|-------|
| A1 | User wants to share | 5a. User taps Share; 5b. Extends to UC-10 |
| A2 | User wants to download | 5a. User taps Download; 5b. Extends to UC-11 |
| A3 | User wants new compression | 5a. User taps New; 5b. System navigates to Home Screen |

---

## Result Management Use Cases

### UC-09: View Compression Statistics

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-09 |
| **Name** | View Compression Statistics |
| **Actor** | User |
| **Description** | Displays detailed statistics about the compression operation |
| **Preconditions** | Compression result is available |
| **Postconditions** | Statistics are calculated and displayed |
| **Trigger** | Included by View Compressed Image (UC-08) |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | | System retrieves original file size from compression result |
| 2 | | System retrieves compressed file size |
| 3 | | System calculates compression ratio: ((original - compressed) / original) × 100 |
| 4 | | System retrieves compression duration |
| 5 | | System formats sizes to human-readable (e.g., "10.5 MB") |
| 6 | | System formats ratio to percentage (e.g., "90.0%") |
| 7 | | System formats time (e.g., "2.5 seconds") |
| 8 | | System displays statistics panel with: |
| | | • Original Size |
| | | • Compressed Size |
| | | • Compression Ratio |
| | | • Processing Time |
| 9 | User views statistics | Statistics remain visible on result screen |

#### Statistics Display Format

| Statistic | Example Value | Calculation |
|-----------|---------------|-------------|
| Original Size | 10.5 MB | Direct from file |
| Compressed Size | 1.05 MB | Direct from result |
| Compression Ratio | 90.0% | ((10.5 - 1.05) / 10.5) × 100 |
| Processing Time | 2.5 seconds | End time - Start time |

---

### UC-10: Share Compressed Image

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-10 |
| **Name** | Share Compressed Image |
| **Actor** | User |
| **Description** | Allows user to share the compressed image via platform sharing mechanisms |
| **Preconditions** | Compressed image is available on result screen |
| **Postconditions** | Image is shared through selected application |
| **Trigger** | User taps Share button (extends View Compressed Image) |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | User taps "Share" button | System retrieves compressed image file |
| 2 | | System validates file exists and is accessible |
| 3 | | System invokes platform share sheet |
| 4 | User sees sharing options | Platform displays available sharing targets |
| 5 | User selects a sharing app | Platform handles the share intent |
| 6 | User completes sharing in target app | Target app processes the shared image |
| 7 | | System receives share completion callback |
| 8 | | System shows "Shared successfully" confirmation |

#### Alternative Flows

| ID | Condition | Steps |
|----|-----------|-------|
| A1 | Web platform | 3a. System uses Web Share API; 3b. If not supported, copies to clipboard |
| A2 | User cancels sharing | 5a. User dismisses share sheet; 5b. System returns to result screen silently |
| A3 | Sharing fails | 6a. Target app reports error; 6b. System shows "Sharing failed" message |
| A4 | File not found | 2a. System shows "Image not available" error |

---

### UC-11: Download Compressed Image

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-11 |
| **Name** | Download Compressed Image |
| **Actor** | User |
| **Description** | Saves the compressed image to device storage |
| **Preconditions** | Compressed image is available on result screen |
| **Postconditions** | Image is saved to device Pictures/Downloads folder |
| **Trigger** | User taps Download button (extends View Compressed Image) |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | User taps "Download" button | System checks platform (Mobile/Web) |
| 2 | | System checks storage write permission (mobile) |
| 3 | | System requests permission if needed |
| 4 | | System generates unique filename with timestamp |
| 5 | | System determines save location (Pictures/Downloads) |
| 6 | | System writes image bytes to file |
| 7 | | System updates device media gallery |
| 8 | | System shows "Image saved successfully" snackbar |
| 9 | | System may show file location in message |

#### Alternative Flows

| ID | Condition | Steps |
|----|-----------|-------|
| A1 | Web platform | 2a. System creates download blob; 2b. System triggers browser download; 2c. Browser handles file save |
| A2 | Permission denied | 3a. User denies permission; 3b. System shows "Storage permission required" |
| A3 | Storage full | 6a. System detects insufficient space; 6b. System shows "Not enough storage" |
| A4 | Write fails | 6a. File operation fails; 6b. System shows "Failed to save image" |

---

## System Preferences Use Cases

### UC-12: Switch Theme

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-12 |
| **Name** | Switch Theme |
| **Actor** | User |
| **Description** | Allows user to toggle between light and dark theme modes |
| **Preconditions** | User is authenticated; User is on a screen with theme toggle |
| **Postconditions** | Application theme is changed; Preference is persisted |
| **Trigger** | User toggles the theme switch |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | User navigates to Profile/Settings | System displays current theme setting |
| 2 | User locates Dark Mode toggle | System shows toggle in current state (on/off) |
| 3 | User taps the theme toggle | System captures current screen for transition |
| 4 | | System determines new theme (Dark ↔ Light) |
| 5 | | System updates ThemeProvider state |
| 6 | | System applies smooth transition animation |
| 7 | | System updates all UI colors and styles |
| 8 | | System saves preference to local storage |
| 9 | | System completes theme transition |
| 10 | User sees new theme applied | All screens now use new theme |

#### Alternative Flows

| ID | Condition | Steps |
|----|-----------|-------|
| A1 | Animation fails | 6a. System applies theme without animation |
| A2 | Storage unavailable | 8a. Theme changes but may not persist after restart |

---

## Administration Use Cases

### UC-13: Monitor System Performance

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-13 |
| **Name** | Monitor System Performance |
| **Actor** | Clerk (Admin) |
| **Description** | Allows administrators to view system metrics and performance data |
| **Preconditions** | Admin is authenticated with elevated privileges |
| **Postconditions** | Performance metrics are displayed |
| **Trigger** | Admin accesses monitoring dashboard |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | Admin logs into admin dashboard | System verifies admin credentials |
| 2 | Admin navigates to Performance section | System loads performance module |
| 3 | | System queries aggregated metrics from backend |
| 4 | | System retrieves: |
| | | • Total compressions count |
| | | • Success/failure rates |
| | | • Average compression time |
| | | • Average compression ratio |
| | | • Active users count |
| 5 | | System displays metrics in dashboard |
| 6 | Admin reviews metrics | System shows graphical representations |
| 7 | Admin can filter by date range | System updates metrics for selected period |
| 8 | Admin can drill down into details | System shows detailed breakdowns |

#### Metrics Displayed

| Metric | Description | Example |
|--------|-------------|---------|
| Total Compressions | All-time compression count | 15,234 |
| Success Rate | Percentage of successful compressions | 98.5% |
| Avg Compression Time | Mean processing duration | 2.3 seconds |
| Avg Compression Ratio | Mean compression achieved | 87.2% |
| Active Users | Users active in last 30 days | 1,250 |
| Total Data Saved | Cumulative bytes saved | 45.6 GB |

---

### UC-14: Manage AI Models

| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-14 |
| **Name** | Manage AI Models |
| **Actor** | Clerk (Admin) |
| **Description** | Allows administrators to update and configure AI compression models |
| **Preconditions** | Admin has model management privileges |
| **Postconditions** | AI model configuration is updated |
| **Trigger** | Admin accesses model management interface |

#### Main Success Scenario

| Step | Actor Action | System Response |
|------|--------------|-----------------|
| 1 | Admin navigates to AI Models section | System displays current model information |
| 2 | | System shows: |
| | | • Current model version |
| | | • Model status (active/inactive) |
| | | • Last updated date |
| | | • Performance metrics |
| 3 | Admin selects model action | System presents available operations |
| 4 | (If uploading new model) | |
| 5 | Admin uploads new model file | System validates model format |
| 6 | | System runs validation tests |
| 7 | | System deploys model to backend |
| 8 | | System updates model version |
| 9 | (If configuring parameters) | |
| 10 | Admin adjusts model parameters | System validates parameter ranges |
| 11 | Admin saves configuration | System applies new configuration |
| 12 | | System logs configuration change |
| 13 | | System shows success confirmation |

#### Model Management Operations

| Operation | Description | Admin Level Required |
|-----------|-------------|---------------------|
| View Status | View current model info | Read |
| Upload Model | Deploy new model version | Write |
| Configure | Adjust model parameters | Write |
| Rollback | Revert to previous version | Admin |
| Delete | Remove model version | Super Admin |

---

## Use Case Relationships Summary

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          USE CASE RELATIONSHIPS                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Login ─────────<<include>>─────────► Login Verification                    │
│                                              │                               │
│                                              ▼                               │
│                                       Firebase Auth                          │
│                                                                              │
│  Sign Up ────────────────────────────► Firebase Auth                        │
│                                                                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  View Home Screen ──<<extend>>──┬──► Take A Photo                           │
│                                 │                                            │
│                                 └──► Select Image                            │
│                                                                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Press Compress Button ──<<include>>──► View Compressed Image               │
│                                              │                               │
│                         ┌───<<include>>──────┤                               │
│                         │                    │                               │
│                         ▼                    ├───<<extend>>──► Share         │
│            View Compression                  │                               │
│                Statistics                    └───<<extend>>──► Download      │
│                                                                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Switch Theme ─────────► (User preference stored locally)                   │
│                                                                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Clerk ──► Monitor System Performance                                        │
│       │                                                                      │
│       └──► Manage AI Models                                                  │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Glossary

| Term | Definition |
|------|------------|
| **Actor** | An entity that interacts with the system (User, Admin, External System) |
| **Precondition** | State that must be true before the use case can execute |
| **Postcondition** | State that is true after the use case completes successfully |
| **Trigger** | Event that initiates the use case |
| **Include** | Mandatory sub-use case that is always executed |
| **Extend** | Optional sub-use case executed under certain conditions |
| **Alternative Flow** | Path taken when main scenario cannot complete |
| **Firebase Auth** | Google's authentication service handling user credentials |
| **Firestore** | Google's NoSQL cloud database for data persistence |

---

*Document generated based on DeepFract System Analysis and Use Case Diagram*
