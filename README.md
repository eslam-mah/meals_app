# Meals App - Splash Screen and Navigation Implementation

## Features Implemented

### 1. Native Splash Screen
- Implemented using `flutter_native_splash` package
- Shows app logo while the app initializes
- Preserves splash screen until all services are initialized

### 2. Connectivity Service
- Monitors internet connectivity in real-time
- Performs periodic checks to ensure accurate connectivity status
- Provides a stream of connectivity changes for reactive UI updates
- Uses multiple DNS lookups for reliable connectivity detection

### 3. Storage Service
- Manages local storage using SharedPreferences
- Stores information about onboarding status, authentication state, and profile completion
- Provides a clean API for accessing and modifying local storage data

### 4. Splash Screen Logic
- Checks connectivity status
- Validates authentication state
- Determines the appropriate initial route based on:
  - Onboarding status (first-time user)
  - Authentication state (logged in/out)
  - Profile completion status

### 5. Conditional Navigation Flow
- **First Launch**: Shows onboarding screens
- **Unauthenticated Users**: 
  - Can access home and menu screens in read-only mode
  - Prompted to log in when trying to access protected features
  - Automatically redirected to login when accessing profile
- **Authenticated Users with Incomplete Profile**: Redirected to profile completion screen
- **Fully Authenticated Users**: Full access to all app features

### 6. Logout Functionality
- Implemented in settings screen
- Clears authentication state and user data
- Redirects to login screen after logout

## App Flow
1. **Native Splash Screen** (system level)
2. **App Initialization** (services, authentication, etc.)
3. **Route Decision**:
   - First time? → Onboarding
   - Not authenticated? → Login or limited Home view
   - Profile incomplete? → Profile completion
   - Fully authenticated? → Main app

## Technical Implementation
- Used GoRouter for navigation
- Implemented BLoC pattern for state management
- Created responsive UI with ScreenUtil
- Integrated with Supabase for authentication and user management
