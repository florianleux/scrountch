# Scrountch Project Implementation Guide

**Project-specific configurations, design system, and implementation details**

This collection contains customizations and configurations specific to the Scrountch family inventory application. These documents build upon the universal Flutter standards found in `/agnostic/` and provide project-specific implementation guidance.

## 📋 Project Overview

**Scrountch** is a family inventory management application that helps families track and organize their belongings across different rooms and storage locations.

### Key Features

- **Item Management**: Add, edit, and delete family inventory items
- **Location Tracking**: Organize items by room, shelf, and storage location
- **Search & Filter**: Find items quickly with advanced search capabilities
- **CSV Import/Export**: Bulk import existing inventory data
- **Family Sharing**: Multi-user access for family members

## 📁 Documentation Structure

| Document                               | Purpose                                   | Language       | Priority |
| -------------------------------------- | ----------------------------------------- | -------------- | -------- |
| [`design-rules.mdc`](design-rules.mdc) | UI design system and visual standards     | French/English | **High** |
| [`build-rules.mdc`](build-rules.mdc)   | Build processes and development workflows | French         | **High** |

## 🎨 Design System ([`design-rules.mdc`](design-rules.mdc))

### Visual Philosophy: "Jaune Bold"

The Scrountch app follows a distinctive **"Jaune Bold"** design philosophy characterized by:

- **Dominant Yellow Color Scheme**: Consistent `#FFE333` background across all screens
- **Bold Typography**: Ultra-heavy fonts for maximum impact
- **Minimalist Interface**: Clean layouts without visual clutter
- **Strong Contrast**: Black elements on yellow backgrounds for accessibility

### Key Design Elements

- **Primary Color**: `#FFE333` (Yellow) - Used for all screen backgrounds
- **Typography**:
  - **Titles & Buttons**: Dela Gothic One (bold, impactful)
  - **Body Text**: Chivo Regular (readable, elegant)
- **Button System**: Three standardized button variants (Primary, Secondary, Tertiary)
- **Layout**: Consistent 24px padding and standardized spacing throughout

### Implementation Requirements

- All screens must use the unified yellow background color
- Custom button widgets must be used instead of default Flutter buttons
- Font usage is strictly limited to the two specified families
- Screen headers must follow the standardized navigation pattern

## 🔧 Build System ([`build-rules.mdc`](build-rules.mdc))

### Critical Build Requirements

- **MANDATORY**: Use only the provided build scripts (`./build_apk_simple.sh` or `./build_apk.sh`)
- **FORBIDDEN**: Never use `flutter build apk --release` directly
- **NDK Configuration**: Scripts automatically configure Android NDK version 26.1.10909125

### Development Workflow

1. **Pre-commit**: Ensure all lints are resolved and tests pass
2. **Commit Standards**: Use standardized commit message format (`feat:`, `fix:`, `style:`, etc.)
3. **Build Process**: Always use provided build scripts for consistency
4. **Verification**: Check APK output and expected file sizes

### Project-Specific Configurations

- **Firebase Integration**: Cloud Firestore for data storage
- **Target Platform**: Android APK for family device installation
- **Build Size**: Expected ~50MB APK with tree-shaking optimization
- **Development Environment**: Specific NDK and SDK requirements

## 🔄 Integration with Universal Standards

### How Project-Specific Rules Extend Universal Patterns

#### Architecture Integration

- **Universal Foundation**: Layered architecture from `/agnostic/architecture_patterns.mdc`
- **Project Customization**: Firebase service integration and family-specific business logic
- **Service Layer**: Extends universal service patterns with inventory-specific operations

#### UI Component Integration

- **Universal Patterns**: Base widget patterns from `/agnostic/widget_guidelines.mdc`
- **Project Customization**: Yellow-themed components with custom typography
- **Design System**: Project-specific button system and color scheme overrides

#### Performance Integration

- **Universal Optimizations**: All performance rules from `/agnostic/performance_rules.mdc`
- **Project Specifics**: Image optimization for inventory photos and CSV processing performance

## 🚀 Getting Started for New Contributors

### Prerequisites

1. **Universal Standards Knowledge**: Read all documents in `/agnostic/` folder first
2. **Development Environment**: Set up Flutter development environment
3. **Project Access**: Ensure access to project repository and Firebase configuration

### Setup Steps

1. **Environment Setup**:

   ```bash
   flutter doctor  # Verify Flutter installation
   cd project_root
   flutter pub get  # Install dependencies
   ```

2. **Build Verification**:

   ```bash
   ./build_apk_simple.sh  # Test build process
   ```

3. **Design System Familiarization**:

   - Review color palette and typography rules
   - Understand the three-button system
   - Study screen layout patterns

4. **Code Standards Application**:
   - Apply universal Flutter standards for architecture
   - Customize with project-specific design rules
   - Follow build and commit workflow requirements

## 🎯 Project-Specific Success Metrics

### Design Consistency

- [ ] All screens use unified `#FFE333` background color
- [ ] Typography strictly follows Dela Gothic One + Chivo usage rules
- [ ] Button system implemented with three standardized variants
- [ ] Screen headers follow consistent navigation pattern
- [ ] 24px padding applied consistently across all screens

### Build Quality

- [ ] All builds use provided scripts (never direct Flutter commands)
- [ ] APK size stays within ~50MB target range
- [ ] Tree-shaking optimization successfully applied
- [ ] Firebase integration properly configured
- [ ] All linting errors resolved before commits

### User Experience

- [ ] Family-friendly interface with clear visual hierarchy
- [ ] Consistent interaction patterns across all features
- [ ] Efficient inventory management workflows
- [ ] Reliable CSV import/export functionality
- [ ] Multi-user family access properly implemented

## 🔧 Customization Guidelines

### When to Follow Project-Specific Rules

- **Visual Design**: Always use project color scheme and typography
- **Build Process**: Always use provided build scripts and configurations
- **User Interface**: Follow established button system and layout patterns
- **Business Logic**: Implement family inventory-specific features

### When to Apply Universal Standards

- **Code Architecture**: Use universal layered architecture patterns
- **Performance Optimization**: Apply all universal performance rules
- **Code Organization**: Follow universal folder structure and naming
- **Testing Patterns**: Use universal testing templates and strategies

## 📊 Quality Assurance Checklist

### Design Compliance

- [ ] Yellow background (`#FFE333`) used on all screens
- [ ] Only Dela Gothic One and Chivo fonts used
- [ ] Custom button widgets implemented (no default Flutter buttons)
- [ ] Consistent 24px padding and spacing
- [ ] Standardized screen header navigation

### Build Compliance

- [ ] Build scripts used exclusively (no direct Flutter commands)
- [ ] APK size within expected range (~50MB)
- [ ] Firebase configuration properly integrated
- [ ] All dependencies up to date and compatible
- [ ] Commit messages follow standardized format

### Functionality Compliance

- [ ] Inventory management features working correctly
- [ ] CSV import/export functionality operational
- [ ] Multi-user family access properly implemented
- [ ] Search and filtering features responsive
- [ ] Data persistence reliable across app sessions

## 🚨 Common Pitfalls

### Design System Violations

- ❌ Using default Flutter button widgets instead of custom components
- ❌ Mixing other fonts with the two approved font families
- ❌ Inconsistent color usage or non-yellow backgrounds
- ❌ Deviating from standardized spacing and layout rules

### Build Process Violations

- ❌ Using `flutter build apk --release` directly
- ❌ Skipping linting or testing before commits
- ❌ Not using standardized commit message formats
- ❌ Ignoring build script warnings or errors

### Architecture Violations

- ❌ Not following universal layered architecture patterns
- ❌ Implementing business logic in UI components
- ❌ Skipping proper error handling and resource disposal
- ❌ Not applying performance optimization patterns

## 📞 Support and Maintenance

### Documentation Updates

- **Design Changes**: Update `design-rules.mdc` when visual standards evolve
- **Build Changes**: Update `build-rules.mdc` when development workflow changes
- **Integration Changes**: Ensure compatibility with universal standard updates

### Team Communication

- **Design Decisions**: Document rationale for project-specific customizations
- **Build Issues**: Share solutions for environment-specific problems
- **Feature Implementation**: Coordinate between universal patterns and project needs

---

_This project implementation guide ensures consistent application of Scrountch-specific requirements while maintaining compatibility with universal Flutter development standards._
