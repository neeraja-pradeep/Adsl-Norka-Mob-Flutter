import 'dart:convert';

class RazorpayConfig {
  // Test credentials (replace with production credentials for live app)
  static const String keyId = 'rzp_live_RKf8kP58RPmwkc';
  // static const String keyId = 'rzp_live_RKf8kP58RPmwkc';
  static const String keySecret = '6zngTSsaFCDxq5V8IahzA6fL';

  // Production credentials (uncomment and replace when going live)
  // static const String keyId = 'YOUR_LIVE_KEY_ID';
  // static const String keySecret = 'YOUR_LIVE_KEY_SECRET';

  // API endpoints
  static const String baseUrl = 'https://api.razorpay.com/v1';
  static const String ordersEndpoint = '$baseUrl/orders';

  // Backend API endpoints
  static const String backendBaseUrl = 'https://norka-care-backend-e2fag2g7fafrhghw.centralindia-01.azurewebsites.net/api';
  static const String backendOrdersEndpoint =
      '$backendBaseUrl/razorpay/orders/';

  // Default payment settings
  static const String defaultCurrency = 'INR';
  static const String defaultCompanyName = 'Norka Care Insurance';
  static const String defaultDescription = 'Enrollment Fee Payment';

  // Theme colors
  static const String primaryColor = '#004EA1';
  static const String backdropColor = '#FFFFFF';

  // Default prefill data
  static const Map<String, String> defaultPrefill = {
    'contact': '+918590316700',
    'email': 'customer@gmail.com',
    'name': 'Customer',
  };

  // Get authorization header
  static String get authorizationHeader {
    final credentials = '$keyId:$keySecret';
    final bytes = utf8.encode(credentials);
    final base64Credentials = base64.encode(bytes);
    return 'Basic $base64Credentials';
  }

  // Get default theme
  static Map<String, String> get defaultTheme => {
    'color': primaryColor,
    'backdrop_color': backdropColor,
  };
}
