class GNPaymentToken {
  String token;
  String cardMask;

  GNPaymentToken({
    this.token,
    this.cardMask,
  });

  GNPaymentToken.fromJSON(Map<String, dynamic> map){
    token = map["data"]["payment_token"];
    cardMask = map["data"]["card_mask"];
  }
}
