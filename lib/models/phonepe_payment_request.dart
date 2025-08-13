class PhonePePaymentRequest {
  final String merchantId;
  final String merchantTransactionId;
  final String merchantUserId;
  final int amount;
  final String redirectUrl;
  final String callbackUrl;
  final String mobileNumber;
  final String email;
  final PaymentInstrument paymentInstrument;

  PhonePePaymentRequest({
    required this.merchantId,
    required this.merchantTransactionId,
    required this.merchantUserId,
    required this.amount,
    required this.redirectUrl,
    required this.callbackUrl,
    this.mobileNumber = '',
    this.email = '',
    required this.paymentInstrument,
  });

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'merchantTransactionId': merchantTransactionId,
      'merchantUserId': merchantUserId,
      'amount': amount,
      'redirectUrl': redirectUrl,
      'redirectMode': 'POST',
      'callbackUrl': callbackUrl,
      'mobileNumber': mobileNumber,
      'email': email,
      'paymentInstrument': paymentInstrument.toJson(),
    };
  }
}

class PaymentInstrument {
  final String type;

  PaymentInstrument({this.type = 'PAY_PAGE'});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
    };
  }
}

class PhonePePaymentResponse {
  final bool success;
  final String? code;
  final String? message;
  final PhonePeData? data;

  PhonePePaymentResponse({
    required this.success,
    this.code,
    this.message,
    this.data,
  });

  factory PhonePePaymentResponse.fromJson(Map<String, dynamic> json) {
    return PhonePePaymentResponse(
      success: json['success'] ?? false,
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? PhonePeData.fromJson(json['data']) : null,
    );
  }
}

class PhonePeData {
  final String merchantId;
  final String merchantTransactionId;
  final String instrumentResponse;

  PhonePeData({
    required this.merchantId,
    required this.merchantTransactionId,
    required this.instrumentResponse,
  });

  factory PhonePeData.fromJson(Map<String, dynamic> json) {
    return PhonePeData(
      merchantId: json['merchantId'] ?? '',
      merchantTransactionId: json['merchantTransactionId'] ?? '',
      instrumentResponse: json['instrumentResponse'] ?? '',
    );
  }
}

class PaymentStatusResponse {
  final bool success;
  final String? code;
  final String? message;
  final PaymentStatusData? data;

  PaymentStatusResponse({
    required this.success,
    this.code,
    this.message,
    this.data,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      success: json['success'] ?? false,
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? PaymentStatusData.fromJson(json['data']) : null,
    );
  }
}

class PaymentStatusData {
  final String merchantId;
  final String merchantTransactionId;
  final String transactionId;
  final int amount;
  final String state;
  final String responseCode;
  final String? paymentInstrument;

  PaymentStatusData({
    required this.merchantId,
    required this.merchantTransactionId,
    required this.transactionId,
    required this.amount,
    required this.state,
    required this.responseCode,
    this.paymentInstrument,
  });

  factory PaymentStatusData.fromJson(Map<String, dynamic> json) {
    return PaymentStatusData(
      merchantId: json['merchantId'] ?? '',
      merchantTransactionId: json['merchantTransactionId'] ?? '',
      transactionId: json['transactionId'] ?? '',
      amount: json['amount'] ?? 0,
      state: json['state'] ?? '',
      responseCode: json['responseCode'] ?? '',
      paymentInstrument: json['paymentInstrument'],
    );
  }
}
