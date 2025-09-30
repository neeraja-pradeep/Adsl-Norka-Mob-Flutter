# Razorpay Embedded Checkout Implementation

This document describes the implementation of Razorpay's hosted checkout using the embedded checkout API instead of the Flutter SDK.

## Overview

The implementation replaces the Razorpay Flutter SDK with a web-based hosted checkout solution that:

1. Creates a Razorpay order via API
2. Generates checkout form data
3. Submits the form to Razorpay's embedded checkout endpoint
4. Displays the hosted checkout page in a WebView
5. Handles payment callbacks for success/failure/cancel scenarios

## Files Created/Modified

### New Files

1. **`lib/services/razorpay_embedded_service.dart`**
   - Handles Razorpay order creation
   - Generates checkout form data
   - Submits form to embedded checkout API
   - Main service for processing embedded payments

2. **`lib/screen/verification/payment/razorpay_checkout_page.dart`**
   - WebView page to display hosted checkout
   - Handles navigation callbacks
   - Manages loading states and error handling
   - Processes payment success/failure/cancel scenarios

3. **`lib/services/payment_callback_service.dart`**
   - Parses callback URLs
   - Extracts payment details
   - Handles signature verification (demo mode)
   - Logs payment details for debugging

### Modified Files

1. **`lib/screen/verification/payment/family_details_confirm_page.dart`**
   - Updated to use embedded checkout service
   - Removed Razorpay Flutter SDK dependencies
   - Integrated with new checkout flow

## Implementation Flow

### 1. Order Creation
```dart
final orderResponse = await RazorpayEmbeddedService.createOrder(
  amount: premiumAmount,
  currency: 'INR',
  receipt: 'receipt_${DateTime.now().millisecondsSinceEpoch}',
);
```

### 2. Checkout Form Generation
```dart
final formData = RazorpayEmbeddedService.generateCheckoutFormData(
  orderId: orderId,
  amount: amount,
  currency: currency,
  name: name,
  description: description,
  prefill: prefill,
  notes: notes,
  callbackUrl: callbackUrl,
  cancelUrl: cancelUrl,
);
```

### 3. Embedded Checkout Submission
```dart
final checkoutResponse = await RazorpayEmbeddedService.submitCheckoutForm(
  formData: formData,
);
```

### 4. WebView Display
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => RazorpayCheckoutPage(
      checkoutUrl: checkoutResponse,
      orderId: orderId,
      amount: amount,
      currency: currency,
    ),
  ),
);
```

## Configuration

### Razorpay Config (`lib/utils/razorpay_config.dart`)
- Key ID and Secret for API authentication
- Base URL and endpoints
- Default theme and prefill data

### Callback URLs
Currently using example URLs:
- Success: `https://example.com/payment-callback`
- Cancel: `https://example.com/payment-cancel`

**Note**: In production, these should be replaced with your actual server endpoints.

## Payment Flow

1. **User clicks "Confirm & Pay"**
   - Validates checkboxes
   - Sets loading state
   - Extracts user details from providers

2. **Order Creation**
   - Calls Razorpay Orders API
   - Creates order with amount, currency, receipt

3. **Checkout Form Generation**
   - Generates form data with all required fields
   - Includes prefill data, notes, callback URLs

4. **Embedded Checkout Submission**
   - Submits form to Razorpay embedded checkout API
   - Receives checkout URL/HTML response

5. **WebView Display**
   - Opens checkout page in WebView
   - Handles navigation callbacks
   - Manages loading and error states

6. **Payment Processing**
   - User completes payment on hosted page
   - Razorpay processes payment
   - Redirects to callback URLs

7. **Callback Handling**
   - Parses callback URL parameters
   - Extracts payment details
   - Verifies signature (demo mode)
   - Navigates to success page or shows error

## Security Considerations

1. **Signature Verification**: Currently in demo mode. In production, implement server-side verification.

2. **API Keys**: Keep Razorpay credentials secure and use environment variables.

3. **Callback URLs**: Use HTTPS URLs in production and implement proper validation.

4. **Error Handling**: Implement comprehensive error handling and logging.

## Testing

### Test Scenarios
1. **Successful Payment**: Complete payment flow with valid card
2. **Payment Cancellation**: Cancel payment and verify callback handling
3. **Payment Failure**: Test with invalid card or insufficient funds
4. **Network Errors**: Test with poor connectivity
5. **WebView Errors**: Test WebView loading failures

### Debug Information
The implementation includes comprehensive debug logging:
- Order creation details
- Form data generation
- API requests and responses
- Callback URL parsing
- Payment verification steps
- HTML content detection and loading

### Known Issues and Fixes

#### Issue: WebView URI Error
**Problem**: `Invalid argument(s): Missing scheme in uri` when loading HTML content
**Solution**: The RazorpayEmbeddedService now detects HTML content vs URLs and uses `loadHtmlString()` for HTML content and `loadRequest()` for URLs.

#### Issue: Order ID Extraction
**Problem**: Need to extract the actual order ID from the HTML response
**Solution**: Added regex pattern matching to extract order ID from the HTML response for proper callback handling.

#### Issue: WebView ORB Errors
**Problem**: Cross-Origin Resource Blocking (ORB) errors when loading embedded HTML content
**Solution**: 
- Added proper base URL (`https://checkout.razorpay.com`) for external resources
- Set appropriate User-Agent for better compatibility
- Added JavaScript injection to handle ORB errors gracefully
- Disabled zoom and set background color for better UX
- Enhanced error handling to ignore non-fatal ORB errors

## Dependencies

Required packages (already in pubspec.yaml):
- `webview_flutter: ^4.4.2`
- `dio: ^5.9.0`
- `provider: ^6.1.1`
- `fluttertoast: ^8.2.12`

## Migration from Flutter SDK

### Removed Dependencies
- `razorpay_flutter: ^1.4.0` (can be removed if not used elsewhere)

### Changes Made
1. Replaced `RazorpayService.processPayment()` with `RazorpayEmbeddedService.processEmbeddedPayment()`
2. Removed Razorpay SDK event handlers
3. Added WebView-based checkout page
4. Implemented callback URL handling
5. Added payment verification service

## Production Deployment

### Required Changes
1. Replace test credentials with production credentials
2. Update callback URLs to your server endpoints
3. Implement server-side signature verification
4. Add proper error monitoring and logging
5. Test thoroughly with production Razorpay account

### Server-Side Requirements
1. Implement callback URL endpoints
2. Add signature verification logic
3. Store payment details securely
4. Handle webhook notifications
5. Implement proper error handling and logging

## Support

For issues or questions:
1. Check debug logs for detailed information
2. Verify Razorpay credentials and configuration
3. Test with Razorpay test cards
4. Review callback URL handling
5. Check network connectivity and API responses
