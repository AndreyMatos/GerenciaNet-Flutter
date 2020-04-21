import 'dart:convert';
import 'package:gerencianetflutter/gn_charge.dart';
import 'package:gerencianetflutter/gn_payment_data.dart';
import 'package:gerencianetflutter/gn_payment_result.dart';
import 'package:http/http.dart' as http;

class MyEndpoint {
  final String baseURL = "http://localhost:3000";
  final String createChargeRoute = "/sample-charge";
  final String payChargeRoute = "/pay";

  Future<GNCharge> createCharge() async {
    final url = baseURL + createChargeRoute;
    http.Response response = await http.get(url);
    assert(response != null && response.body.isNotEmpty);
    Map<String, dynamic> chargeMap = jsonDecode(response.body);
    return GNCharge.fromMap(chargeMap);
  }

  Future<GNPaymentResult> pay(
    GNCharge charge,
    GNPaymentData paymentData,
  ) async {
    final url = baseURL + payChargeRoute;
    http.Response response = await http.post(
      url,
      body: {
        "payment_data": paymentData.toJSON(),
        "charge_data": charge.toJSON(),
      },
    );
    assert(response != null && response.body.isNotEmpty);
    Map<String, dynamic> paymentResultMap = jsonDecode(response.body);
    return GNPaymentResult.fromMap(paymentResultMap);
  }
}
