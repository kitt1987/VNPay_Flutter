import 'package:flutter/material.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  String responseCode = '';

  Future<void> onPayment() async {
    final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
      url:
          'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html', //vnpay url, default is https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
      version: '2.1.0',
      tmnCode: 'DBGEVTES', //vnpay tmn code, get from vnpay
      txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
      orderInfo: 'Pay 30.000 VND', //order info, default is Pay Order
      amount: 30000,
      returnUrl:
          'https://www.dbgev.com', //https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop/#code-returnurl
      ipAdress: '160.16.213.178',
      vnpayHashKey:
          '1ST1L8O2EB9TPZVMSNWNVECV2YO94OEX', //vnpay hash key, get from vnpay
      vnPayHashType: VNPayHashType
          .HMACSHA512, //hash type. Default is HMACSHA512, you can chang it in: https://sandbox.vnpayment.vn/merchantv2,
      vnpayExpireDate: DateTime.now().add(const Duration(hours: 1)),
      vnpayOrderType: 'topup',
    );
    await VNPAYFlutter.instance.show(
      paymentUrl: paymentUrl,
      onPaymentSuccess: (params) {
        setState(() {
          responseCode = params['vnp_ResponseCode'];
        });
      },
      onPaymentError: (params) {
        setState(() {
          responseCode = 'Error';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Response Code: $responseCode'),
            TextButton(
              onPressed: onPayment,
              child: const Text('30.000VND'),
            ),
          ],
        ),
      ),
    );
  }
}
