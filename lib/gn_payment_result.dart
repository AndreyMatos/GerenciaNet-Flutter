import 'dart:convert';

enum GNPaymentError { noError, serverError, validationError, unknownError }

class GNPaymentResult {
  int code;
  String status;
  String error;
  String errorDescription;

  GNPaymentResult.__();

  bool haveError() {
    return error != null;
  }

  GNPaymentError errorType() {
    if (error == null) return GNPaymentError.noError;
    if (error == "server_error")
      return GNPaymentError.serverError;
    else if (error == "validation_error")
      return GNPaymentError.validationError;
    else
      return GNPaymentError.unknownError;
  }

  factory GNPaymentResult.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return GNPaymentResult.__()
      ..code = map["code"]
      ..status = map["data"]["status"]
      ..error = map["error"]
      ..errorDescription = map["error_description"];
  }

  String toJSON() {
    return jsonEncode({
      "code": code,
      "status": status,
      "error": error,
      "errorDescription": errorDescription,
    });
  }
}
