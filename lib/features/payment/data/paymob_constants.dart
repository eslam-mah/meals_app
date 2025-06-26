class PaymobConstants {
  /// Paymob API Key - Used for authentication with the Paymob API
  /// This should be obtained from your Paymob dashboard
  static const String apiKey =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBMU5EYzFPQ3dpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5vVkRmSS1JejBLVHZZcDFjWjlSdng1Qzh0MWtGRFZ2aHVSNWJTTHljbGNGNWZQRDFSR3VoNkhWSHcwYzVIMDVCWGZhbGZjV2IwbGxuSWFIRDJHU25jdw==';

  /// Integration ID for card payments
  /// Note: This is not used directly in the API call for intentions
  /// The payment_methods array should contain only the payment method type (e.g., "card")
  static const int integrationId = 5148402;

  /// Secret key for API authentication
  /// Used in the Authorization header for API requests
  static const String secretKey =
      'egy_sk_test_d1f0f29687317dde688165d95764b1512ecf98ad976bfb8221d35bce03980bc4';

  /// Public key for the checkout page
  /// Used in the URL for redirecting to the payment page
  static const String publicKey =
      'egy_pk_test_S3XKYmkkJQdVtnvWzpvzXvCa6zrmo1ev';
}
