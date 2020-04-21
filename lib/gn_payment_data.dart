import 'dart:convert';

import 'package:gerencianetflutter/gn_customer.dart';
import 'package:gerencianetflutter/gn_customer_address.dart';
import 'package:gerencianetflutter/gn_payment_token.dart';

class GNPaymentData {
  GNCustomer _customer;
  GNCustomerAddress _address;
  GNPaymentToken _paymentToken;
  int installments;

  GNPaymentData(
    this._customer,
    this._address,
    this._paymentToken, {
    this.installments,
  });

  String toJSON() {
    return jsonEncode({
      "payment": {
        "credit_card": {
          "customer": {
            "name": _customer.customerName,
            "cpf": _customer.cpf.replaceAll(RegExp(r"[\.\-]"), ""),
            "email": _customer.email,
            "birth": _customer.customerBirth,
            "phone_number": _customer.customerPhone
          },
          "installments": installments ?? 1,
          "payment_token": _paymentToken.token,
          "billing_address": {
            "street": _address.street,
            "number": _address.number ?? 0,
            "neighborhood": _address.neighborhood,
            "zipcode": _address.zipcode.replaceAll(RegExp(r"[\-]"), ""),
            "city": _address.city,
            "complement": _address.complement,
            "state": _address.state
          }
        }
      }
    });
  }

  Map<String, dynamic> toMap() {
    return {
      "payment": {
        "credit_card": {
          "customer": {
            "name": _customer.customerName,
            "cpf": _customer.cpf,
            "email": _customer.email,
            "birth": _customer.customerBirth,
            "phone_number": _customer.customerPhone
          },
          "installments": installments ?? 1,
          "payment_token": _paymentToken.token,
          "billing_address": {
            "street": _address.street,
            "number": _address.number ?? 0,
            "neighborhood": _address.neighborhood,
            "zipcode": _address.zipcode.replaceAll(RegExp(r"[\-]"), ""),
            "city": _address.city,
            "complement": _address.complement,
            "state": _address.state
          }
        }
      }
    };
  }
}
