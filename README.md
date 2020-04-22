# Gerencianet Flutter

Gerencianet credit card payment sdk implementation in dart

# 1) Getting Started - Getting a Payment Token

To pay with credit cards, first we're going to need a **Payment Token**.<br>
The first step is to create an instance of GNConfig with your account code.<br>
When testing we should set isSandbox to true.
```dart
final config = GNConfig(accountCode: "your_account_code", isSandbox: true);
```
All right!
Now we're going to use the config to obtain an instance of the api, like so:
```dart
final api = GNApi(config: config);
```

Create an instance of GNCreditCard with the credit card data:
```dart
//this is a false credit card number generated online
//this is going to work in sandbox mode
final cc = GNCreditCard(
      number: "4342558146566662",
      brand: "visa",
      expirationMonth: "04",
      expirationYear: "2021",
      cvv: "832",
    );
```

Finally, you can  retrieve the token:
```dart
GNPaymentToken gnToken = await api.retrievePaymentToken(cc);
```

# 2) Using the token to make payments

With the payment token in hands we can now make real payments!<br>
The payment data api requires a lot of data, so bear with me...<br>
### 2.1 Provide the customer data:
```dart
  //Fake data generated online
  GNCustomer customer = GNCustomer(
      customerName: "John Doe",
      cpf: "630.719.530-46",
      customerBirth: "1990-03-19",
      email: "johndoe@johndoe.com",
      customerPhone: "31987655679",
    );
```
### 2.2 Provide the customer address:
```dart
    //Fake data generated online
    GNCustomerAddress address = GNCustomerAddress(
        number: 100,
        city: "Seattle",
        neighborhood: "Some Seattle Neighborhood",
        zipcode: "09380-135",
        state: "AC",
        street: "Some Street in Seattle");
```

### 2.3 Put it all together:
```dart
GNPaymentData paymentData = GNPaymentData(customer, address, gnToken);
```
### 2.4 Creating your custom payment code:
Since the code to complete the payment should be in your backend, you should create a simple class to make your life easier.<br>
Here's an example:

```dart
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
```
### 2.5 Making the payment:
Using the class written before, this is all you should have to do to complete the payment:
```dart
    MyEndpoint myEndpoint = MyEndpoint();
    GNCharge charge = await myEndpoint.createCharge();
    GNPaymentResult paymentResult = await myEndpoint.pay(charge, paymentData);
```
If you want to see the complete code, check out the test folder.

# 3) Backend code
We're almost there!<br>
I'm going to use nodeJS here to demonstrate how the backend should look like (at least the bare minimum), but you can use many other languages https://dev.gerencianet.com.br/docs/instalacao-da-api.<br>
Bear in mind that this is just for demonstration purposes, in a production environment you should be more careful.<br><br>

Let's begin by installing nodeJS if you don't have it installed yet: https://nodejs.org/<br>
Create a folder in your computer, open a terminal or windows command prompt, navigate to the folder and let's install express (a minimalist web framework for Node.js), type:
```
npm install express --save
```
after a while express should be installed and ready to use.

Also, install body-parser, that's gonna make our lives easier when parsing requests/responses.<br> 
Type in the same terminal:
```
npm install body-parser
```
Good!

Now for the most important package, the Gerencianet node sdk.
Just like the others just type in the terminal:
```
npm install gn-api-sdk-node
```

Our little local server is going to have only two routes:<br>
GET /sample-charge: which will create a simple 20 bucks charge and return it as a json<br>
POST /pay: which will pay a generated charge, given the charge id (and a lot of other information needed)<br>

So, here's the code for the server:

```javascript
const express = require('express')
const Gerencianet = require('gn-api-sdk-node');
const app = express()
var bodyParser = require('body-parser')
const port = 3000

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
    extended: false
}))

var options = {
    client_id: 'your_client_id'
    client_secret: 'your_client_secret',
    sandbox: true
}

var gn = Gerencianet(options)

app.get('/sample-charge', async (req, res) => {
    var chargeInput = {
        items: [{
            name: 'Product A',
            value: 1000,
            amount: 2
        }]
    }
    let charge = await gn.createCharge({}, chargeInput)
    res.send(charge)
})

app.post('/pay', async (req, res) => {
    let charge = JSON.parse(req.body.charge_data);
    let params = {
        id: charge.charge_id
    }
    let body = JSON.parse(req.body.payment_data)
    try {
        let paymentRes = await gn.payCharge(params, body)
        res.send(paymentRes)
    } catch (e) {
        console.log(e)
        res.send(e)
    }
})

app.listen(port, () => console.log(`Example app listening at http://localhost:${port}`))
```

if you installed everything correctly, save this code in a .js file (you can call it anything you like, per convention it's usually named index.js).<br>
**Don't forget to fill in the client_id and client_secret obtained from your Gerencianet account panel. You should use your dev keys**<br>
Assuming you named the file index.js, type in your terminal:
```
node index.js
```

This will start the server, and if you filled the information in the server code correctly, you can open a browser and navigate to http://localhost:3000/sample-charge.<br>
This will generate a charge that can be used in our library.

