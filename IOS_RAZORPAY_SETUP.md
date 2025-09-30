# iOS Razorpay Setup Guide

## Overview
This guide explains the iOS-specific configuration required for Razorpay integration.

## Configuration Applied

### 1. Info.plist Updates

#### URL Schemes
Added the following URL schemes to allow Razorpay to open external payment apps:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>googlepay</string>
    <string>phonepe</string>
    <string>paytm</string>
    <string>gpay</string>
    <string>amazonpay</string>
    <string>freecharge</string>
    <string>mobikwik</string>
    <string>airtel</string>
    <string>olamoney</string>
    <string>jio</string>
    <string>cred</string>
    <string>slice</string>
    <string>lazypay</string>
    <string>razorpay</string>
    <string>razorpaypayments</string>
</array>
```

#### Custom URL Schemes
Added custom URL schemes for Razorpay callbacks:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>razorpay</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>razorpay</string>
            <string>razorpaypayments</string>
        </array>
    </dict>
</array>
```

#### Network Security
Added network security settings to allow Razorpay API calls:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>api.razorpay.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.0</string>
            <key>NSExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
    </dict>
</dict>
```

### 2. AppDelegate.swift Updates

Added URL handling method to properly handle Razorpay callbacks:

```swift
override func application(
  _ app: UIApplication,
  open url: URL,
  options: [UIApplication.OpenURLOptionsKey : Any] = [:]
) -> Bool {
  return super.application(app, open: url, options: options)
}
```

## Testing on iOS

### Prerequisites
1. **Xcode Installation**: Ensure Xcode is properly installed
2. **iOS Simulator or Device**: Test on iOS simulator or physical device
3. **Internet Connection**: Required for Razorpay API calls

### Build and Test
1. **Clean Build**:
   ```bash
   flutter clean
   flutter pub get
   ```

2. **iOS Build**:
   ```bash
   flutter build ios
   ```

3. **Run on iOS**:
   ```bash
   flutter run -d ios
   ```

### Common iOS Issues

1. **URL Scheme Not Working**
   - Ensure Info.plist has correct URL schemes
   - Check that CFBundleURLTypes is properly configured

2. **Network Security Issues**
   - Verify NSAppTransportSecurity settings
   - Check if API calls are being blocked

3. **Payment Gateway Not Opening**
   - Test on physical device (simulator may have limitations)
   - Check internet connectivity
   - Verify Razorpay API key is correct

4. **Build Errors**
   - Ensure iOS deployment target is set correctly
   - Check for missing dependencies

## iOS-Specific Features

### Supported Payment Methods
- **Cards**: Visa, MasterCard, American Express
- **UPI**: All major UPI apps
- **Wallets**: Paytm, PhonePe, Amazon Pay, etc.
- **Net Banking**: Major Indian banks
- **EMI**: Available for eligible cards

### Device Compatibility
- **iOS 12.0+**: Minimum supported version
- **iPhone**: All models running iOS 12.0+
- **iPad**: All models running iOS 12.0+

## Security Considerations

1. **API Key Security**: Never expose production keys in client code
2. **Network Security**: Use HTTPS for all API calls
3. **Data Validation**: Validate all payment data on server side
4. **Signature Verification**: Always verify payment signatures

## Troubleshooting

### Debug Steps
1. Check Xcode console for error messages
2. Verify network connectivity
3. Test with different payment methods
4. Check Razorpay dashboard for transaction logs

### Common Error Messages
- **"URL scheme not found"**: Check Info.plist configuration
- **"Network error"**: Verify NSAppTransportSecurity settings
- **"Payment failed"**: Check API credentials and amount format

## Support

For iOS-specific issues:
- [Razorpay iOS Documentation](https://razorpay.com/docs/payments/payment-gateway/ios-integration/)
- [Flutter iOS Setup](https://flutter.dev/docs/deployment/ios)
- [Xcode Documentation](https://developer.apple.com/xcode/)
