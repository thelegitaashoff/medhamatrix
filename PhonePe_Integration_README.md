# PhonePe Payment Gateway Integration

This project includes a complete PhonePe payment gateway integration for Flutter applications using the official PhonePe Payment Gateway APIs.

## Features

- ✅ Complete PhonePe API integration
- ✅ WebView-based payment flow
- ✅ Payment status checking
- ✅ Transaction management
- ✅ Test environment support
- ✅ Error handling and user feedback
- ✅ Responsive UI design

## Files Overview

### Core Integration Files

1. **`lib/services/phonepe_service.dart`** - PhonePe API service
2. **`lib/models/phonepe_payment_request.dart`** - Data models for API requests/responses
3. **`lib/phonepe_payment_page.dart`** - Main payment initiation page
4. **`lib/phonepe_webview_page.dart`** - WebView for payment processing
5. **`lib/example_phonepe_usage.dart`** - Demo/example usage page

### Dependencies Added

```yaml
dependencies:
  http: ^0.13.4              # For API calls
  crypto: ^3.0.3             # For checksum generation
  webview_flutter: ^4.4.4    # For payment WebView
```

## Test Credentials

The integration is configured with PhonePe UAT (test) credentials:

```
MID: M110NES2UDXSUAT
SALT KEY: 5afb2d8c-5572-47cf-a5a0-93bb79647ffa
SALT INDEX: 1
Base URL: https://api-preprod.phonepe.com/apis/hermes
```

## Usage

### Basic Implementation

```dart
import 'package:flutter/material.dart';
import 'phonepe_payment_page.dart';

// Navigate to payment page
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PhonePePaymentPage(
      amount: 100.0,                    // Amount in rupees
      userId: 'USER_123',              // Unique user identifier
      callbackUrl: 'https://your-callback-url.com',
      mobileNumber: '9999999999',      // Optional
      email: 'user@example.com',       // Optional
    ),
  ),
);
```

### Advanced Usage with Result Handling

```dart
final result = await Navigator.push<Map<String, dynamic>>(
  context,
  MaterialPageRoute(
    builder: (context) => PhonePePaymentPage(
      amount: amount,
      userId: userId,
      callbackUrl: callbackUrl,
    ),
  ),
);

if (result != null && result['success'] == true) {
  // Payment successful
  print('Payment successful: ${result['data']}');
} else {
  // Payment failed
  print('Payment failed: ${result['error']}');
}
```

## API Flow

### 1. Payment Initiation (`/pg/v1/pay`)

The integration follows PhonePe's standard API flow:

```dart
// Generate transaction ID
final merchantTransactionId = PhonePeService.generateTransactionId();

// Create payment request
final response = await PhonePeService.initiatePayment(
  merchantTransactionId: merchantTransactionId,
  amount: amount,
  userId: userId,
  callbackUrl: callbackUrl,
);

if (response['success']) {
  // Open WebView with payment URL
  final paymentUrl = response['redirectUrl'];
}
```

### 2. Payment Processing (WebView)

- User is redirected to PhonePe payment page
- Payment is processed through PhonePe interface
- WebView monitors URL changes for payment completion

### 3. Status Verification (`/pg/v1/status`)

```dart
final statusResponse = await PhonePeService.checkPaymentStatus(
  merchantTransactionId
);

switch (statusResponse['status']) {
  case 'COMPLETED':
    // Payment successful
    break;
  case 'FAILED':
    // Payment failed
    break;
  case 'PENDING':
    // Payment pending
    break;
}
```

## Testing

### Using UAT Simulator

PhonePe provides a UAT simulator for testing different payment scenarios:

1. Visit: https://developer.phonepe.com/v1/docs/uat-simulator
2. Use the test credentials provided
3. Test various payment outcomes (Success/Failure/Pending)

### Test Cases

The integration handles these scenarios:

- ✅ Successful payment
- ✅ Failed payment
- ✅ Pending payment
- ✅ User cancellation
- ✅ Network errors
- ✅ Invalid parameters
- ✅ Timeout scenarios

## Security Features

### Checksum Generation

All API requests include secure checksums:

```dart
static String generateChecksum(String payload) {
  final checksumString = payload + '/pg/v1/pay' + saltKey;
  final bytes = utf8.encode(checksumString);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
```

### Data Protection

- Sensitive data is not logged in production
- API responses are validated
- User data is handled securely
- HTTPS communication only

## Going Live

### Production Checklist

1. **Update Credentials**: Replace test credentials with live ones
2. **Change Environment**: Set `isTestMode = false` in `PhonePeService`
3. **Update Base URL**: Switch to production URL
4. **Configure Webhooks**: Set up server-to-server callbacks
5. **Test Thoroughly**: Complete end-to-end testing

### Production Configuration

```dart
// Update these values for production
static const String merchantId = 'YOUR_LIVE_MERCHANT_ID';
static const String saltKey = 'YOUR_LIVE_SALT_KEY';
static const String saltIndex = 'YOUR_LIVE_SALT_INDEX';
static bool isTestMode = false; // Set to false for production
```

## Error Handling

The integration includes comprehensive error handling:

### API Errors
- Network connectivity issues
- Invalid parameters
- Authentication errors
- Server errors

### User Experience
- Loading indicators
- Error messages
- Retry mechanisms
- Graceful fallbacks

### Example Error Handling

```dart
try {
  final response = await PhonePeService.initiatePayment(...);
  if (response['success']) {
    // Handle success
  } else {
    // Handle API error
    showErrorDialog(response['error']);
  }
} catch (e) {
  // Handle network/system errors
  showErrorDialog('Network error: $e');
}
```

## Customization

### UI Customization

The payment pages can be customized:

- Colors and themes
- Button styles
- Loading indicators
- Error messages
- Success/failure dialogs

### Business Logic

Customize the integration for your needs:

- Add additional validations
- Implement custom logging
- Add analytics tracking
- Integrate with your backend

## Callback URL Handling

For production, implement proper callback handling:

### Server-to-Server Callback

```dart
// Your server endpoint to receive PhonePe callbacks
// POST /phonepe/callback
{
  "merchantId": "M110NES2UDXSUAT",
  "merchantTransactionId": "TXN_123456789",
  "transactionId": "T2110281230568875",
  "amount": 10000,
  "state": "COMPLETED",
  "responseCode": "SUCCESS",
  "checksum": "checksum_value"
}
```

### Webhook Verification

Always verify the checksum in callbacks:

```dart
bool verifyChecksum(Map<String, dynamic> response, String receivedChecksum) {
  // Implement checksum verification
  final expectedChecksum = generateCallbackChecksum(response);
  return expectedChecksum == receivedChecksum;
}
```

## Support and Documentation

### Official Resources

- [PhonePe Developer Documentation](https://developer.phonepe.com)
- [API Reference](https://developer.phonepe.com/reference/api-objects)
- [UAT Simulator](https://developer.phonepe.com/v1/docs/uat-simulator)

### Common Issues

1. **Invalid Checksum**: Ensure proper checksum generation
2. **Network Issues**: Check internet connectivity
3. **Invalid Credentials**: Verify merchant ID and salt key
4. **Callback Issues**: Ensure callback URL is accessible

## Contributing

To improve this integration:

1. Test thoroughly with different scenarios
2. Add more error handling cases
3. Improve UI/UX
4. Add more configuration options
5. Update documentation

## License

This integration is provided as-is for educational and development purposes. Please ensure compliance with PhonePe's terms of service and your local regulations.

---

**Note**: This is a test environment integration. Always use proper security practices and test thoroughly before going live with real payments.
