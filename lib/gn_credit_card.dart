import 'dart:convert';

class GNCreditCard {
  String number;
  String brand;
  String expirationMonth;
  String expirationYear;
  String cvv;
  String salt;

  GNCreditCard({
    this.number,
    this.brand,
    this.expirationMonth,
    this.expirationYear,
    this.cvv,
    this.salt,
  });

  GNCreditCard.fromMap(Map<String, dynamic> map){
    number = map["number"];
    brand = map["brand"];
    expirationMonth = map["expiration_month"];
    expirationYear = map["expiration_year"];
    cvv = map["cvv"];
    salt = map["salt"];
  }

  String toJson() {
    return jsonEncode({
      "brand": brand,
      "number": number,
      "cvv": cvv,
      "expiration_month": expirationMonth,
      "expiration_year": expirationYear,
      "salt": salt,
    });
  }
}
