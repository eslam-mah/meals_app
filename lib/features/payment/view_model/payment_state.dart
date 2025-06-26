import 'package:equatable/equatable.dart';

enum PaymentStatus {
  initial,
  loading,
  intentionCreated,
  redirected,
  success,
  error,
}

class PaymentState extends Equatable {
  final PaymentStatus status;
  final String? errorMessage;
  final String? paymentIntentionId;
  final String? clientSecret;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.errorMessage,
    this.paymentIntentionId,
    this.clientSecret,
  });

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        paymentIntentionId,
        clientSecret,
      ];

  PaymentState copyWith({
    PaymentStatus? status,
    String? errorMessage,
    String? paymentIntentionId,
    String? clientSecret,
  }) {
    return PaymentState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      paymentIntentionId: paymentIntentionId ?? this.paymentIntentionId,
      clientSecret: clientSecret ?? this.clientSecret,
    );
  }
} 