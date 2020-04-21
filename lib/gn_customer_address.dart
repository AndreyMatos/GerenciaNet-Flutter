import 'package:flutter/cupertino.dart';

class GNCustomerAddress {
  String street;
  int number;
  String neighborhood;
  String zipcode;
  String city;
  String complement;
  String state;

  GNCustomerAddress({
    @required this.street,
    @required this.number,
    @required this.neighborhood,
    @required this.zipcode,
    @required this.city,
    this.complement,
    @required this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      "street": street,
      "number": number ?? 0,
      "neighborhood": neighborhood,
      "zipcode": zipcode?.replaceAll(RegExp(r"[\-]"), ""),
      "city": city,
      "complement": complement,
      "state": state
    };
  }
}
