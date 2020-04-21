library gerencianetflutter;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gerencianetflutter/gn_credit_card.dart';
import 'package:gerencianetflutter/gn_payment_token.dart';
import 'package:gerencianetflutter/rsa.dart';
import 'package:http/http.dart' as http;

import 'gn_config.dart';
import 'gn_constants.dart';

class GNApi {
  GNConfig config;
  String baseUrl;
  String tokenizerUrl;
  Map<String, String> headers;

  GNApi({@required this.config}) {
    baseUrl = config.isSandbox ? GNConstants.baseUrlSandbox : GNConstants.baseUrlProduction;
    tokenizerUrl = config.isSandbox ? GNConstants.baseUrlSandbox : GNConstants.tokenizerUrl;
    headers = {'account-code': config.accountCode};
  }

  Future<GNPaymentToken> retrievePaymentToken(GNCreditCard cc) async {
    final salt = await _salt;
    final pubKey = await _publicKey;
    cc.salt = salt;
    final encryptedCard = RSA.encrypt(cc.toJson(), pubKey);
    http.Response tokenResp = await http.post(
      "$tokenizerUrl/card",
      headers: {"account-code": config.accountCode, 'Content-Type': 'application/x-www-form-urlencoded'},
      body: {"data": encryptedCard},
    );
    if (tokenResp.body.isEmpty) return null;
    return GNPaymentToken.fromJSON(jsonDecode(tokenResp.body));
  }

  Future<String> get _salt async {
    if (config.isSandbox) return "";
    http.Response saltResp = await http.get("$tokenizerUrl/salt", headers: headers);
    if (saltResp.body.isEmpty) return "";
    return jsonDecode(saltResp.body)["data"];
  }

  Future<String> get _publicKey async {
    http.Response pubKeyResponse = await http.get(baseUrl + GNConstants.routePublicKey, headers: headers);
    if (pubKeyResponse.body.isEmpty) return "";
    return jsonDecode(pubKeyResponse.body)["data"];
  }
}
