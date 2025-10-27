# PicPol

A modern iOS photo editor built with SwiftUI, featuring powerful editing tools with an intuitive interface.

## Features

- **Authentication** — Email/password and Google Sign-In
- **Photo Editing** — Transform, rotate, scale, and move images
- **Filters** — Apply Core Image filters for artistic effects
- **Drawing** — Draw on images with support for undo/redo using PencilKit
- **Text Overlays** — Add customizable text with full editor
- **Export** — Save edited images to photo library

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/NadeKoles/picpol.git
   ```

2. Open `PicPol.xcodeproj` in Xcode

3. Configure Firebase:
   - Replace `GoogleService-Info.plist` with your own Firebase configuration
   - Enable Email/Password and Google Sign-In authentication in Firebase Console

4. Run the project on simulator or device

## Architecture

PicPol follows **MVVM** architecture with clear separation of concerns:

- `AuthViewModel` — Authentication and user management
- `PhotoEditorViewModel` — Image manipulation and transformations
- `DrawingViewModel` — Drawing logic with undo/redo functionality
- `FilterViewModel` — Core Image filter processing
- `TextOverlayViewModel` — Text overlay management

## Project Structure

```
PicPol/
├── App/                    # App entry point
├── Models/                 # Data models
├── Views/                  # SwiftUI views
│   ├── Auth/              # Authentication screens
│   └── PhotoEditor/       # Editor interface
├── ViewModels/            # Business logic
├── Shared/                # Common utilities
│   ├── UI/                # Reusable UI components
│   ├── Utils/             # Helper functions
│   └── Constants/         # App-wide constants
└── Persistence/           # Core Data stack
```

## Technologies

- **SwiftUI** — UI framework
- **Firebase** — Authentication
- **Core Image** — Image filtering
- **PencilKit** — Drawing capabilities
- **PhotosUI** — Image picker
- **Core Data** — Local persistence

## License

This project is a test assignment for iOS developer position.

---

Built with ❤️ by [Nadia K]
