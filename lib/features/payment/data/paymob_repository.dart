import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meals_app/features/payment/data/paymob_constants.dart';
import 'package:logging/logging.dart';

class PaymobPaymentRepository {
  final Logger _log = Logger('PaymobPaymentRepository');

  /// Create Payment Intention (v1/intention/) with all request fields included
  Future<Map<String, dynamic>?> createIntention({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String state,
    required String apartment,
    required String building,
    required String street,
    required String country,
    required String floor,
    required String amount,
  }) async {
    final url = Uri.parse('https://accept.paymob.com/v1/intention/');
    try {
      // Ensure amount is an integer value as required by Paymob
      // It should already be converted to piasters in the cubit
      final int amountValue = int.parse(amount);

      _log.info(
        'Creating payment intention with amount: $amountValue piasters',
      );
      _log.info('Using integration ID: ${PaymobConstants.integrationId}');

      // Create request body
      final Map<String, dynamic> requestBody = {
        "amount": amountValue,
        "currency": "EGP",
        "payment_methods": [PaymobConstants.integrationId],
        "items": [],
        "billing_data": {
          "apartment": apartment,
          "first_name": firstName,
          "last_name": '-',
          "street": street,
          "building": building,
          "phone_number": phoneNumber,
          "country": country,
          "email": email,
          "floor": floor,
          "state": state,
        },
        "customer": {},
        "extras": {},
      };

      _log.info('Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Token ${PaymobConstants.secretKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _log.info('Payment intention created successfully');
        return jsonDecode(response.body);
      } else {
        _log.severe('Intention creation failed: ${response.body}');
        return null;
      }
    } catch (e) {
      _log.severe('Intention creation failed: $e');
      return null;
    }
  }
}
