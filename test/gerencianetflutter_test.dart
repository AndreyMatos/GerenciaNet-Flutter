import 'package:flutter_test/flutter_test.dart';
import 'package:gerencianetflutter/gerencianetflutter.dart';
import 'package:gerencianetflutter/gn_charge.dart';
import 'package:gerencianetflutter/gn_config.dart';
import 'package:gerencianetflutter/gn_credit_card.dart';
import 'package:gerencianetflutter/gn_customer.dart';
import 'package:gerencianetflutter/gn_customer_address.dart';
import 'package:gerencianetflutter/gn_payment_data.dart';
import 'package:gerencianetflutter/gn_payment_result.dart';
import 'package:gerencianetflutter/gn_payment_token.dart';

import 'my_endpoint.dart';

void main() {
  test('test token retrieval in production', () async {
    final config = GNConfig(accountCode: "your_account_code", isSandbox: false);
    final api = GNApi(config: config);
    //this is a false credit card number generated online
    final cc = GNCreditCard(
      number: "4342558146566662",
      brand: "visa",
      expirationMonth: "04",
      expirationYear: "2021",
      cvv: "832",
    );
    GNPaymentToken gnToken = await api.retrievePaymentToken(cc);
    expect(gnToken.cardMask, equals("XXXXXXXXXXXX6662"));
    expect(gnToken.token, isNotEmpty);
  });

  test('test payment', () async {
    final config = GNConfig(accountCode: "your_account_code", isSandbox: true);
    final api = GNApi(config: config);
    //this is a false credit card number generated online
    final cc = GNCreditCard(
      number: "4342558146566662",
      brand: "visa",
      expirationMonth: "04",
      expirationYear: "2021",
      cvv: "832",
    );
    GNPaymentToken gnToken = await api.retrievePaymentToken(cc);
    expect(gnToken.cardMask, equals("XXXXXXXXXXXX6662"));
    expect(gnToken.token, isNotEmpty);

    //Fake data generated online
    GNCustomer customer = GNCustomer(
      customerName: "John Doe",
      cpf: "630.719.530-46",
      customerBirth: "1990-03-19",
      email: "johndoe@johndoe.com",
      customerPhone: "31987655679",
    );

    //Fake data generated online
    GNCustomerAddress address = GNCustomerAddress(
        number: 100,
        city: "Seattle",
        neighborhood: "Some Seattle Neighborhood",
        zipcode: "09380-135",
        state: "AC",
        street: "Some Street in Seattle");

    GNPaymentData paymentData = GNPaymentData(customer, address, gnToken);

    MyEndpoint myEndpoint = MyEndpoint();

    GNCharge charge = await myEndpoint.createCharge();
    expect(charge.code, equals(200));

    GNPaymentResult paymentResult = await myEndpoint.pay(charge, paymentData);
    expect(paymentResult.code, equals(200));
  });
}
