# DeepFract - Complete System Sequence Diagram (Mermaid)

## Fractal Image Compression Using AI Techniques

### Graduation Project - UML Documentation

---

## Mermaid Code (For Draw.io)

```mermaid
sequenceDiagram
    autonumber

    actor User
    participant App as Application
    participant Splash as Splash Screen
    participant Onboarding as Onboarding Module
    participant Home as Home Screen
    participant ImagePicker as Image Picker Service
    participant Loading as Loading Overlay
    participant Compression as Compression Service
    participant Backend as Backend Server
    participant Result as Result Screen
    participant Storage as Local Storage

    %% ========== PHASE 1: APPLICATION INITIALIZATION ==========
    rect rgb(255, 255, 200)
        Note over User, Storage: Phase 1: Application Initialization

        User->>App: Launch Application
        activate App
        App->>Storage: Load Theme Preference
        Storage-->>App: Return Theme Mode
        App->>Splash: Display Splash Screen
        activate Splash
        Splash->>Splash: Play Animation (2.5 seconds)
    end

    %% ========== PHASE 2: ONBOARDING ==========
    rect rgb(255, 255, 200)
        Note over User, Storage: Phase 2: User Onboarding (Mobile Only)

        alt Web Platform
            Splash->>Home: Direct Navigation
        else Mobile Platform
            Splash->>Onboarding: Navigate to Onboarding
            deactivate Splash
            activate Onboarding
            Onboarding->>User: Screen 1 - Compression Power
            User->>Onboarding: Next
            Onboarding->>User: Screen 2 - AI Technology
            User->>Onboarding: Next
            Onboarding->>User: Screen 3 - Upload Guide
            User->>Onboarding: Get Started
            Onboarding->>Storage: Save Completion Status
            Onboarding->>Home: Navigate to Home
            deactivate Onboarding
        end
    end

    %% ========== PHASE 3: IMAGE SELECTION ==========
    rect rgb(255, 255, 200)
        Note over User, Storage: Phase 3: Image Selection

        activate Home
        Home->>User: Display Main Interface
        User->>Home: Select Image
        Home->>ImagePicker: Open Image Source Dialog
        activate ImagePicker
        ImagePicker->>User: Show Options (Gallery/Camera)

        alt Gallery
            User->>ImagePicker: Choose Gallery
            ImagePicker->>ImagePicker: Access Device Storage
        else Camera
            User->>ImagePicker: Choose Camera
            ImagePicker->>ImagePicker: Capture Photo
        end

        ImagePicker-->>Home: Return Image File
        deactivate ImagePicker
        Home->>User: Display Image Preview
    end

    %% ========== PHASE 4: COMPRESSION PROCESS ==========
    rect rgb(255, 255, 200)
        Note over User, Storage: Phase 4: AI Compression Process

        User->>Home: Compress Image
        Home->>Loading: Show Loading Overlay
        activate Loading
        Loading->>User: Display Progress Animation
        Loading->>Compression: Submit Image
        activate Compression

        Compression->>Backend: POST /api/compress (Image Data)
        activate Backend
        Backend->>Backend: Convert to Grayscale
        Backend->>Backend: Apply Fractal Decomposition
        Backend->>Backend: Execute AI Optimization
        Backend-->>Compression: Return Compressed Image + Metadata
        deactivate Backend

        Compression-->>Loading: Return Result
        deactivate Compression
        Loading->>Loading: Complete Animation
        Loading-->>Home: Close Overlay
        deactivate Loading
    end

    %% ========== PHASE 5: RESULT DISPLAY ==========
    rect rgb(255, 255, 200)
        Note over User, Storage: Phase 5: Result Presentation

        Home->>Result: Navigate with Results
        deactivate Home
        activate Result
        Result->>User: Display Compressed Image
        Result->>User: Show Statistics (Size, Ratio, Time)

        alt Download
            User->>Result: Download Image
            Result->>Storage: Save to Device
            Result-->>User: Confirm Download
        else Share
            User->>Result: Share Image
            Result-->>User: Open Share Dialog
        else New Image
            User->>Result: Compress Another
            Result-->>Home: Return to Home
            deactivate Result
        end
    end

    deactivate App
```

---

## Arrow Types

| Syntax | Type         | Usage             |
| ------ | ------------ | ----------------- |
| `->>`  | Solid arrow  | Request / Action  |
| `-->>` | Dashed arrow | Return / Response |

---

## Return Arrows (Dashed)

All return/response arrows now use `-->>`:

- `Storage-->>App: Return Theme Mode`
- `ImagePicker-->>Home: Return Image File`
- `Backend-->>Compression: Return Compressed Image + Metadata`
- `Compression-->>Loading: Return Result`
- `Loading-->>Home: Close Overlay`
- `Result-->>User: Confirm Download`
- `Result-->>User: Open Share Dialog`
- `Result-->>Home: Return to Home`

---

## Generate at:

**Draw.io: Arrange → Insert → Advanced → Mermaid**
