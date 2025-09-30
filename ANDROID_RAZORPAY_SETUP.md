# Android Razorpay Setup Guide

## Overview
This guide explains the Android-specific configuration required for Razorpay integration.

## Configuration Applied

### 1. AndroidManifest.xml Updates

#### Permissions
Added necessary permissions for network access and Razorpay functionality:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
```

#### Application Configuration
Added application-level settings for Razorpay:

```xml
<application
    android:usesCleartextTraffic="true"
    android:allowBackup="true"
    android:fullBackupContent="true">
    
    <!-- Razorpay API Key -->
    <meta-data
        android:name="com.razorpay.ApiKey"
        android:value="rzp_live_RKf8kP58RPmwkc"/>
</application>
```

#### Activity Configuration
Enhanced MainActivity settings for better Razorpay compatibility:

```xml
<activity
    android:screenOrientation="portrait"
    android:resizeableActivity="false"
    android:hardwareAccelerated="true"
    android:windowSoftInputMode="adjustResize">
</activity>
```

#### Package Queries
Added package queries for all major payment apps:

```xml
<queries>
    <!-- Razorpay Payment Apps -->
    <package android:name="com.google.android.apps.nbu.paisa.user" />
    <package android:name="net.one97.paytm" />
    <package android:name="com.phonepe.app" />
    <package android:name="in.amazonpay" />
    <package android:name="com.freecharge.android" />
    <package android:name="com.mobikwik_new" />
    <package android:name="com.myairtelapp" />
    <package android:name="com.olacabs.customer" />
    <package android:name="com.jio.myjio" />
    <package android:name="com.dreamplug.androidapp" />
    <package android:name="com.slice" />
    <package android:name="com.lazypay" />
    <package android:name="com.razorpay" />
</queries>
```

### 2. build.gradle.kts Updates

#### Default Configuration
Updated build configuration for Razorpay compatibility:

```kotlin
defaultConfig {
    minSdk = 21
    multiDexEnabled = true
    // ... other settings
}
```

### 3. ProGuard Rules
Comprehensive ProGuard rules for Razorpay:

```proguard
# Razorpay specific rules
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
-keepclassmembers class com.razorpay.** { *; }

# Network and HTTP rules
-keepattributes *Annotation*
-keep class retrofit2.** { *; }
-keepclasseswithmembers class * {
    @retrofit2.http.* <methods>;
}

# Keep JSON classes
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
```

## Testing on Android

### Prerequisites
1. **Android Studio**: Ensure Android Studio is properly installed
2. **Android Device or Emulator**: Test on physical device or emulator
3. **Internet Connection**: Required for Razorpay API calls
4. **Google Play Services**: Required for some payment methods

### Build and Test
1. **Clean Build**:
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Android Build**:
   ```bash
   flutter build apk
   ```

3. **Run on Android**:
   ```bash
   flutter run -d android
   ```

### Common Android Issues

1. **Payment Gateway Not Opening**
   - Check if Razorpay API key is correct in AndroidManifest.xml
   - Verify internet connectivity
   - Ensure device has Google Play Services installed

2. **App Crashes on Payment**
   - Check ProGuard rules for Razorpay classes
   - Verify minSdk version (should be 21 or higher)
   - Check for missing permissions

3. **Network Security Issues**
   - Ensure `usesCleartextTraffic="true"` is set
   - Check network security configuration
   - Verify API endpoints are accessible

4. **Payment Apps Not Found**
   - Ensure package queries are properly configured
   - Check if payment apps are installed on device
   - Verify app package names are correct

## Android-Specific Features

### Supported Payment Methods
- **Cards**: Visa, MasterCard, American Express, RuPay
- **UPI**: All major UPI apps (Google Pay, PhonePe, Paytm, etc.)
- **Wallets**: Paytm, PhonePe, Amazon Pay, FreeCharge, Mobikwik
- **Net Banking**: All major Indian banks
- **EMI**: Available for eligible cards
- **Pay Later**: Available through various providers

### Device Compatibility
- **Android 5.0+ (API 21+)**: Minimum supported version
- **All Android devices**: Phones and tablets
- **Google Play Services**: Required for optimal functionality

### Performance Optimizations
- **Hardware Acceleration**: Enabled for smooth animations
- **MultiDex**: Enabled for large app support
- **ProGuard**: Optimized for release builds

## Security Considerations

1. **API Key Security**: 
   - Never expose production keys in client code
   - Use different keys for test and production
   - Consider using backend for order creation

2. **Network Security**:
   - Use HTTPS for all API calls
   - Implement certificate pinning for production
   - Validate all payment data on server side

3. **Data Protection**:
   - Don't store sensitive payment data locally
   - Implement proper session management
   - Use secure storage for tokens

## Troubleshooting

### Debug Steps
1. Check Android Studio logcat for error messages
2. Verify network connectivity
3. Test with different payment methods
4. Check Razorpay dashboard for transaction logs
5. Verify device compatibility

### Common Error Messages
- **"Payment gateway not found"**: Check API key configuration
- **"Network error"**: Verify internet connectivity and permissions
- **"App not installed"**: Check package queries configuration
- **"Payment failed"**: Check API credentials and amount format

### Performance Issues
- **Slow loading**: Check network connectivity
- **App crashes**: Verify ProGuard rules
- **Memory issues**: Enable MultiDex if needed

## Best Practices

1. **Testing**:
   - Test on multiple Android versions
   - Test on different screen sizes
   - Test with various payment methods
   - Test offline scenarios

2. **User Experience**:
   - Provide clear error messages
   - Implement proper loading states
   - Handle payment cancellations gracefully
   - Show payment confirmation

3. **Security**:
   - Validate all inputs
   - Implement proper error handling
   - Use secure communication
   - Follow Android security guidelines

## Support

For Android-specific issues:
- [Razorpay Android Documentation](https://razorpay.com/docs/payments/payment-gateway/android-integration/)
- [Flutter Android Setup](https://flutter.dev/docs/deployment/android)
- [Android Developer Documentation](https://developer.android.com/)
- [Google Play Console](https://play.google.com/console)

## Production Checklist

- [ ] Replace test API key with production key
- [ ] Test on multiple Android devices
- [ ] Verify ProGuard rules for release build
- [ ] Test all payment methods
- [ ] Implement proper error handling
- [ ] Add analytics and monitoring
- [ ] Test offline scenarios
- [ ] Verify security measures
