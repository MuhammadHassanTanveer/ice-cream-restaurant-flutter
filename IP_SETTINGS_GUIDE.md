# IP Settings Configuration - Implementation Guide

## Overview
A hidden IP/Base URL settings feature has been added to your Flutter restaurant app. Users can now change the API endpoint from a hidden settings screen accessible via the login screen.

## How to Use

### Accessing the Settings Screen
1. **On the Login Screen**, tap the **logo image 5 times rapidly** (within 3 seconds)
2. The **API Settings Screen** will open
3. Here you can modify:
   - **Base URL (API)**: The main API endpoint (e.g., `http://192.168.92.174:8000/api`)
   - **Image URL**: The base URL for image assets (e.g., `http://192.168.92.174:8000/`)

### Features
- ✅ **Save Settings**: Click "Save" to persist the new URLs
- ✅ **Reset to Defaults**: Click "Reset" to revert to hardcoded default URLs
- ✅ **URL Validation**: Basic validation to ensure URLs are properly formatted
- ✅ **Persistent Storage**: URLs are saved to SharedPreferences and persist across app restarts
- ✅ **Hidden Access**: 5-tap gesture on login logo keeps it hidden from casual users

## Implementation Details

### Files Created

1. **`lib/util/api_config_service.dart`**
   - Manages API URL storage and retrieval
   - Handles SharedPreferences for persistent storage
   - Methods:
     - `getBaseUrl()` - Returns current base URL
     - `getImageUrl()` - Returns current image URL
     - `setBaseUrl(url)` - Saves new base URL
     - `setImageUrl(url)` - Saves new image URL
     - `resetToDefaults()` - Resets to default URLs
     - `isCustomUrlSet()` - Checks if custom URL is configured

2. **`lib/screens/api_settings_screen.dart`**
   - UI for configuring API endpoints
   - Displays current URLs in text fields
   - Includes Save, Reset buttons
   - Info box with usage instructions
   - URL validation before saving

### Files Modified

1. **`lib/screens/login_screen.dart`**
   - Added 5-tap gesture detection on logo
   - Navigates to API Settings Screen when triggered
   - Hidden from normal user interactions

2. **`lib/providers/auth_provider.dart`**
   - Updated `loginUser()` to use dynamic base URL from `ApiConfigService`
   - Replaced hardcoded `AppConstants.baseUrl` with `await ApiConfigService.getBaseUrl()`

3. **`lib/providers/take_order_provider.dart`**
   - Updated all API calls to use dynamic URLs:
     - `getFoods()` - Menu endpoint
     - `getRestaurantTables()` - Tables endpoint
     - `getTax()` - Tax endpoint
     - `submitOrder()` - Order submission endpoint
     - `getPendingOrders()` - Pending orders endpoint
     - `getCompleteOrders()` - Complete orders endpoint

4. **`lib/providers/dashboard_provider.dart`**
   - Updated `fetchDashboardStats()` to use dynamic base URL

5. **`lib/util/app_constants.dart`**
   - Kept default URLs as fallback values
   - Added helper methods `getDynamicBaseUrl()` and `getDynamicImageUrl()`
   - Static defaults still available if needed

## Benefits

1. **Easy Debugging**: Testers can quickly switch between dev/prod servers
2. **Emulator Testing**: Easy to change from emulator-specific IPs to production
3. **No Recompile**: URL changes don't require app recompilation
4. **Secure**: Hidden gesture keeps the feature from casual discovery
5. **Reversible**: Easy reset to defaults if something goes wrong

## Default Values

The app uses these default values if no custom URLs are set:
- **Base URL**: `http://192.168.92.174:8000/api`
- **Image URL**: `http://192.168.92.174:8000/`

These can be changed in `lib/util/api_config_service.dart` constants:
```dart
static const String defaultBaseUrl = 'http://192.168.92.174:8000/api';
static const String defaultImageUrl = 'http://192.168.92.174:8000/';
```

## Testing Steps

1. Open the app and go to login screen
2. Tap the logo 5 times quickly (within 3 seconds)
3. Verify API Settings Screen opens
4. Enter new API URLs (test with your local server IP)
5. Click "Save"
6. Return to login and attempt login - should use new URL
7. Check debug console for API call URLs to verify

## Troubleshooting

If the settings screen doesn't open:
- Ensure you're tapping the logo (not the surrounding area)
- Tap 5 times within 3 seconds
- Check debug logs for tap count: `debugPrint('Logo taps: $logoTapCount')`

If API calls still use old URL:
- Clear app cache: `flutter clean` then `flutter run`
- Check if SharedPreferences is properly saving values
- Verify the BaseUrl format matches your server endpoint

## Future Enhancements

Consider adding:
- Quick-select buttons for predefined servers (dev, staging, prod)
- Connection test button to verify endpoint accessibility
- Toggle to enable/disable custom URLs
- Server selection based on build flavor
- Environment-based default URLs

