# Payment Feature

This feature handles payment processing for the Meals App using Paymob as the payment gateway.

## Integration Details

### Paymob Callbacks

The following callback URLs are configured in the Paymob dashboard:

- Transaction processed callback: `https://accept.paymobsolutions.com/api/acceptance/post_pay`
- Transaction response callback: `https://accept.paymobsolutions.com/api/acceptance/post_pay`

### Payment Flow

1. When a user selects "Credit Card" payment method in the checkout screen, the app initiates the payment process.
2. The app creates a payment intention through the Paymob API.
3. The user is redirected to a WebView showing the Paymob payment form.
4. After completing the payment, Paymob redirects to one of the callback URLs with success/failure parameters.
5. The app detects these callbacks in the WebView and handles the payment result accordingly.
6. On successful payment, the app creates the order in the database and navigates to the success screen.
7. On failed payment, the app shows an error message and allows the user to try again.

### Implementation Components

- **PaymentCubit**: Manages payment state and communicates with the Paymob API
- **PaymobPaymentRepository**: Handles API calls to Paymob
- **PaymentWebView**: Displays the payment form and handles callbacks
- **PaymentHandler**: Coordinates the payment flow

### Error Handling

The payment integration includes comprehensive error handling:
- Network errors during API calls
- User cancellation of payment
- Payment processing errors from Paymob
- Callback detection failures

### Security Considerations

- Payment processing is done through Paymob's secure interface
- Sensitive card information is never stored in the app
- All API calls use HTTPS
- API keys are stored securely in constants (not committed to version control)

## Usage

To process a payment:

```dart
final paymentHandler = PaymentHandler(
  context: context,
  user: currentUser,
  address: selectedAddress,
  amount: totalAmount.toString(),
  onPaymentSuccess: () {
    // Handle successful payment
  },
  onPaymentError: (error) {
    // Handle payment error
  },
);

await paymentHandler.processCardPayment();
```

## Testing

For testing purposes, Paymob provides test card numbers:
- Successful payment: 4987654321098769, any CVV, any future expiry date
- Failed payment: 5123456789012346, any CVV, any future expiry date

## Overview

The payment feature allows users to pay for their orders using credit/debit cards through the Paymob payment gateway. It creates a payment intention and displays the Paymob checkout page in a WebView, verifying the payment status before completing the order.

## Components

### 1. Data Layer

- **PaymobConstants**: Contains API keys and configuration for the Paymob payment gateway.
- **PaymobPaymentRepository**: Handles API calls to the Paymob payment gateway.

### 2. View Model Layer

- **PaymentCubit**: Manages the payment state and business logic.
- **PaymentState**: Represents the current state of the payment process.

### 3. View Layer

- **PaymentHandler**: A utility class that coordinates the payment process in the checkout flow.
- **PaymentWebView**: A WebView component that displays the Paymob checkout page and monitors payment status.

## How It Works

1. When a user selects "card" as the payment method in checkout and places an order:
   - The checkout flow calls the `PaymentHandler.processCardPayment()` method.
   - The handler creates a payment intention through the `PaymentCubit`.
   - The `PaymentCubit` calls the `PaymobPaymentRepository` to create an intention.

2. After creating the payment intention:
   - The payment page is displayed in a WebView within the app.
   - The WebView monitors the payment process for success or failure indicators.

3. Payment verification:
   - The WebView checks for success or failure indicators in the URL and page content.
   - When payment is complete, the WebView updates the PaymentCubit state.
   - The PaymentHandler checks the final payment status before proceeding.

4. After payment verification:
   - If payment is successful, the order is created with payment_status set to 'paid'.
   - If payment fails, the user is shown an error message and can retry.
   - If payment is cancelled, the checkout process is aborted.

## Important Notes

### Amount Format
Paymob requires the amount to be in the smallest currency unit (piasters for EGP):
- 100 piasters = 1 EGP
- For example, to charge 150.75 EGP, you need to pass 15075 as the amount

The payment cubit automatically converts decimal amounts to piasters format when creating the payment intention.

### Payment Methods Format
When creating a payment intention, the `payment_methods` array should contain only the payment method type (e.g., "card"), not the integration ID:

```json
{
  "payment_methods": ["card"]
}
```

The integration ID is not used directly in the API call for intentions. It's only needed for specific API operations.

### WebView vs URL Launcher
This implementation uses WebView instead of URL launcher to:
- Keep the user within the app during the payment process
- Allow for better payment status monitoring
- Provide a more seamless user experience
- Enable verification of payment before creating the order

## Integration

To integrate the payment feature:

1. Ensure the `PaymentCubit` is registered in the checkout router.
2. Use the `PaymentHandler` in the checkout flow to process card payments.
3. Handle success and error callbacks appropriately.

## Configuration

Update the `PaymobConstants` class with your Paymob API keys:

```dart
class PaymobConstants {
  static const String apiKey = 'YOUR_API_KEY';
  static const String integrationId = 'YOUR_INTEGRATION_ID'; // For reference only
  static const String secretKey = 'YOUR_SECRET_KEY';
  static const String publicKey = 'YOUR_PUBLIC_KEY';
}
``` 