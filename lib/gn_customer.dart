import 'package:flutter/widgets.dart';

class GNCustomer {
  String customerName;
  String cpf;
  String email;
  String customerBirth;
  String customerPhone;

  GNCustomer({
    @required this.customerName,
    @required this.cpf,
    @required this.email,
    @required this.customerBirth,
    @required this.customerPhone,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": customerName,
      "cpf": cpf.replaceAll(RegExp(r"[\.\-]"), ""),
      "email": email,
      "birth": customerBirth,
      "phone_number": customerPhone?.replaceAll(RegExp(r"[\-\(\)]"), ""),
    };
  }
}
