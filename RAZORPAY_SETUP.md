# Razorpay Integration Setup Guide

## Overview
This guide explains how to set up and use the Razorpay payment gateway integration in your Flutter app.

## Service Structure

The Razorpay integration has been organized into separate files for better maintainability:

- **`lib/services/razorpay_service.dart`**: Main service class containing all Razorpay functionality
- **`lib/utils/razorpay_config.dart`**: Configuration file for API keys and settings
- **`lib/utils/razorpay_example.dart`**: Example usage and integration patterns
- **`lib/screen/verification/payment/family_details_confirm_page.dart`**: Updated to use the new service

### Benefits of this structure:
- **Separation of Concerns**: Configuration, business logic, and UI are separated
- **Reusability**: The service can be used across different screens
- **Maintainability**: Easy to update and modify Razorpay functionality
- **Testability**: Service can be easily unit tested
- **Security**: API keys are centralized in one configuration file

## Prerequisites
1. Razorpay account (sign up at https://razorpay.com)
2. Flutter development environment
3. Android/iOS development setup

## Setup Instructions

### 1. Get Razorpay Credentials
1. Log in to your Razorpay Dashboard
2. Go to Settings > API Keys
3. Generate a new key pair
4. Copy the Key ID and Key Secret

### 2. Update Configuration
Edit `lib/utils/razorpay_config.dart`:

```dart
// Test credentials (replace with production credentials for live app)
static const String keyId = 'rzp_test_YOUR_ACTUAL_KEY_ID';
static const String keySecret = 'YOUR_ACTUAL_KEY_SECRET';

// Production credentials (uncomment and replace when going live)
// static const String keyId = 'rzp_live_YOUR_LIVE_KEY_ID';
// static const String keySecret = 'YOUR_LIVE_KEY_SECRET';
```

### 3. Android Setup
Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<application>
    <!-- Add this inside the application tag -->
    <meta-data
        android:name="com.razorpay.ApiKey"
        android:value="YOUR_KEY_ID"/>
</application>
```

### 4. iOS Setup
Add to `ios/Runner/Info.plist`:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>googlepay</string>
    <string>phonepe</string>
    <string>paytm</string>
</array>
```

## Usage

### 1. Initialize Razorpay
The service is automatically initialized in `main.dart`.

### 2. Setup Event Handlers
```dart
RazorpayService.setupEventHandlers(
  onPaymentSuccess: (PaymentSuccessResponse response) {
    // Handle successful payment
    debugPrint('Payment successful: ${response.paymentId}');
    // Navigate to success page or show success message
  },
  onPaymentError: (PaymentFailureResponse response) {
    // Handle payment error
    debugPrint('Payment failed: ${response.message}');
    // Show error message to user
  },
  onExternalWallet: (ExternalWalletResponse response) {
    // Handle external wallet selection
    debugPrint('External wallet: ${response.walletName}');
  },
);
```

### 3. Create Payment
```dart
// Create order
final orderResponse = await RazorpayService.createOrder(
  amount: 5000, // Amount in rupees (₹50.00)
  currency: 'INR',
);

// Open payment gateway
RazorpayService.openCheckout(
  orderId: orderResponse['id'],
  amount: 5000,
  currency: 'INR',
  name: 'Your Company Name',
  description: 'Payment Description',
  prefill: {
    'contact': '+919876543210',
    'email': 'customer@email.com',
    'name': 'Customer Name',
  },
);
```

### 4. Handle Payment Callbacks
The payment callbacks are handled by the functions you provide to `setupEventHandlers`:
- `onPaymentSuccess`: Called when payment is successful
- `onPaymentError`: Called when payment fails
- `onExternalWallet`: Called when external wallet is selected

## Payment Flow

1. **User clicks "Confirm & Pay"**
2. **Create Order**: App creates a Razorpay order
3. **Open Gateway**: Razorpay payment gateway opens
4. **User Payment**: User completes payment
5. **Success/Error**: App handles the result
6. **Navigation**: User is redirected to success/failure page

## Testing

### Test Cards
Use these test cards for testing:

- **Success**: 4111 1111 1111 1111
- **Failure**: 4000 0000 0000 0002
- **CVV**: Any 3 digits
- **Expiry**: Any future date

### Test UPI
- **Success**: success@razorpay
- **Failure**: failure@razorpay

## Security Notes

1. **Never expose Key Secret** in client-side code for production
2. **Use backend API** for order creation in production
3. **Verify payment signature** on your backend
4. **Use HTTPS** for all API calls

## Production Checklist

- [ ] Replace test credentials with live credentials
- [ ] Set `isProduction = true` in config
- [ ] Implement backend order creation
- [ ] Add payment signature verification
- [ ] Test with real payment methods
- [ ] Handle edge cases and errors

## Troubleshooting

### Common Issues

1. **Payment Gateway Not Opening**
   - Check if Key ID is correct
   - Verify internet connection
   - Check Android/iOS setup

2. **Order Creation Fails**
   - Verify Key Secret
   - Check amount format (should be in paise)
   - Ensure currency is supported

3. **Payment Fails**
   - Check test card numbers
   - Verify payment method availability
   - Check Razorpay dashboard for errors

### Debug Mode
Enable debug logging by adding:
```dart
debugPrint('Payment Error: $e');
```

## Support

For more information:
- [Razorpay Flutter Documentation](https://razorpay.com/docs/payments/payment-gateway/flutter-integration/)
- [Razorpay API Documentation](https://razorpay.com/docs/api/)
- [Flutter Razorpay Plugin](https://pub.dev/packages/razorpay_flutter)
