# Scrountch - Family Home Inventory App

A simple Flutter application for managing family home inventory with Firebase backend.

> ⚠️ **Firebase Configuration Required**: This repository requires Firebase setup. See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for complete instructions.

## Overview

Scrountch helps families track and locate household items across different rooms and locations. Designed with extreme simplicity in mind, it uses Firebase for data storage and anonymous authentication.

## Features

- **Item Management**: Create, edit, and search for household items
- **Room Organization**: Complete hierarchy Room → Location → Sub-location
- **Categorization**: Main categories and subcategories with dynamic additions
- **Search**: Name-based search with instant results
- **CSV Import/Export**: Bulk import and export functionality
- **Offline Support**: Works offline with Firebase caching
- **Multi-device Sync**: Data synchronized across family devices
- **100% Free**: No costs, no photos to avoid Firebase charges

## Tech Stack

- **Framework**: Flutter (Dart)
- **Database**: Firebase Firestore
- **Authentication**: Firebase Anonymous Authentication
- **Target**: Android API level 23+
- **Dependencies**: Firebase Core 4.1.0, Firestore 6.0.1, Auth 6.0.2

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── constants/
│   ├── app_constants.dart       # Reference data and constants
│   └── location_data.dart       # Complete location hierarchy
├── models/
│   └── item.dart               # Item data model
├── services/
│   ├── firebase_service.dart   # Firebase CRUD operations
│   ├── navigation_service.dart # Centralized navigation
│   └── csv_service.dart        # CSV import/export functionality
├── screens/
│   ├── home_screen.dart        # Main navigation screen
│   ├── search_screen.dart      # Search input screen
│   ├── results_screen.dart     # Search results display
│   ├── no_results_screen.dart  # No results found screen
│   ├── item_detail_screen.dart # Item details display
│   ├── csv_import_screen.dart  # CSV import interface
│   └── item_form_screen.dart   # Create/edit item form
├── widgets/
│   ├── item_card.dart          # Reusable item display card
│   ├── app_header.dart         # Consistent navigation header
│   ├── background_image.dart   # Reusable background component
│   ├── custom_buttons.dart     # Themed button components
│   ├── custom_dropdown.dart    # Searchable dropdown widget
│   ├── custom_text_field.dart  # Themed text input fields
│   ├── tag_input_field.dart    # Tag management with chips
│   └── confirmation_dialog.dart # Reusable confirmation dialog
└── theme/
    └── unified_theme.dart      # Centralized theme definitions
```

## Quick Start

### 1. Prerequisites

- Flutter SDK 3.1.0+
- Android development environment
- Java 17 (OpenJDK Temurin recommended)
- Firebase account

### 2. Firebase Setup

1. Create a new Firebase project
2. Enable Anonymous Authentication
3. Create Firestore database with security rules
4. Copy configuration files using the provided templates

**Detailed setup instructions**: [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

### 3. Installation

```bash
# Clone the repository
git clone https://github.com/florianleux/scrountch.git
cd scrountch

# Install dependencies
flutter pub get

# Configure Firebase (see FIREBASE_SETUP.md)
# Copy your firebase_options.dart and google-services.json

# Run the app
flutter run
```

### 4. Build APK

#### Option A: Automated Script (Recommended)

```bash
# Production build
./build_apk_simple.sh release

# Debug build
./build_apk_simple.sh debug
```

#### Option B: Manual Commands

```bash
# Set environment variables
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools

# Clean and build
flutter clean
flutter build apk --release
```

**APK Output**: `build/app/outputs/flutter-apk/app-release.apk`

## Usage

### Creating Items

1. Tap "STORE" on the home screen
2. Tap "NEW ITEM"
3. Fill required fields (Name, Room)
4. Optionally add location, category, owner, tags, etc.
5. Tap "Save"

### Finding Items

1. Tap "FIND" on the home screen
2. Enter the item name
3. Tap "SEARCH"
4. View results or item details

### CSV Import/Export

1. Tap "IMPORT" on the home screen
2. Select CSV file with proper format
3. Review and import items
4. Export functionality available in settings

### Managing Items

- Edit items by tapping the edit icon in item details
- Delete items with confirmation dialog
- Add custom subcategories when "Other..." is selected
- Use tags for better organization (max 5 per item)

## Data Model

Items contain:

- **Name** (required) - Item identifier
- **Room** (required) - One of 13 predefined rooms
- **Location** (optional) - Specific furniture/area within room
- **Sub-location** (optional) - Precise placement (drawer, shelf, etc.)
- **Owner** (optional) - Family member
- **Main Category** (optional) - Broad item classification
- **Subcategory** (optional) - Specific item type
- **Tags** (optional) - Up to 5 searchable keywords
- **Description** (optional) - Additional details

## Location Hierarchy

- **13 Rooms**: Living room, Kitchen, Bathroom, Office, Bedrooms, etc.
- **~92 Locations**: Specific furniture and areas per room
- **~400 Sub-locations**: Precise placements (drawers, shelves, compartments)

## Theme & Design

- **Primary Color**: Yellow (#FFE333)
- **Fonts**: 
  - Headers: DelaGothicOne
  - Body: Chivo Regular
- **UI Elements**: Black borders, consistent spacing
- **Icons**: Custom PNG assets for navigation and actions

## Firebase Configuration

### Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /items/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Quotas (Spark Plan)
Monitor usage to stay within free tier limits:
- **Firestore**: 50K reads, 20K writes per day
- **Authentication**: Unlimited anonymous users
- **Storage**: No file storage used (text-only)

## Troubleshooting

### Common Build Issues

1. **"Command not found: flutter"**:
   ```bash
   export PATH="/path/to/flutter/bin:$PATH"
   ```

2. **Java/Gradle compatibility errors**:
   - Use Java 17 (not Java 21 or 24)
   - Ensure Gradle 8.7+ is configured
   - Clean cache: `rm -rf ~/.gradle/caches/`

3. **"minSdkVersion cannot be smaller than version 23"**:
   - Firebase requires Android API 23+
   - Update `minSdkVersion 23` in `android/app/build.gradle`

4. **Firebase configuration errors**:
   - Ensure `google-services.json` is in `android/app/`
   - Verify `firebase_options.dart` is properly configured
   - Check Firebase project settings

### Tested Environment

- **Flutter**: 3.1.0+
- **Java**: OpenJDK 17 (Temurin)
- **Gradle**: 8.7
- **Android Gradle Plugin**: 8.5.0
- **Kotlin**: 2.1.0
- **Android SDK**: API 23+ (Android 6.0+)

## Performance & Optimization

- **Offline-first**: Firebase caching enabled
- **Efficient widgets**: ValueListenableBuilder for minimal rebuilds
- **Optimized search**: Keyword-based Firestore queries
- **Memory management**: Proper disposal of controllers
- **Tree shaking**: Unused code eliminated in release builds

## Key Specifications

- **Target Users**: Small families (2-3 users, 2 devices)
- **Storage**: Text-only, no images (cost optimization)
- **Network**: Works offline, syncs when connected
- **Maintenance**: Zero-maintenance design
- **Cost**: 100% free with Firebase Spark plan

## Security Features

- **Anonymous Authentication**: No personal data collection
- **Firestore Rules**: Authenticated access only
- **Local Storage**: Secure Firebase caching
- **Public Repository**: Sensitive credentials excluded via templates

## Contributing

This is a family project, but contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Follow the existing code style and architecture
4. Test thoroughly on Android devices
5. Update documentation if needed
6. Submit a pull request

## Build Information

- **Package**: com.famille.scrountch
- **Version**: 1.0.0+1
- **Min SDK**: Android API 23 (Android 6.0)
- **Target SDK**: Latest Android SDK
- **Build Tools**: Android Gradle Plugin 8.5.0

## Roadmap

- [ ] iOS support (future consideration)
- [ ] Advanced filtering options
- [ ] Barcode scanning integration
- [ ] Multi-language support
- [ ] Enhanced CSV import validation

## License

Private family application - not for commercial distribution.

---

**Made with ❤️ for family organization**

*Last updated: January 2025*