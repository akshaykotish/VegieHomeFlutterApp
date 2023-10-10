import 'package:flutter/material.dart';
import 'package:vegiehome/Account/SetupAddress.dart';
import 'package:vegiehome/ClientSide/Home.dart';
import 'package:vegiehome/ClientSide/OrderStatus.dart';
import 'package:vegiehome/DataSet/Account.dart';
import 'package:vegiehome/DataSet/Cookies.dart';
import 'package:vegiehome/DataSet/Order.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../DataSet/Cart.dart';
import '../Parts/StyleOfButtons.dart';
import '../Parts/StyleOfTexts.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  late Order order;
  Account account = Account("", "", "", "", "", "", "", "", "", "", "", "", "", false, DateTime.now(), "");

  Razorpay _razorpay = Razorpay();

  double TotalCost = 0;
  double TotalTax = 0;
  double TotalDiscount = 0;
  String DiscountCoupoun = "";
  double TotalPrice = 0;

  LoadTotals(){
    TotalCost = 0;
    TotalTax = 0;
    TotalDiscount = 0;
    TotalPrice = 0;

    for(int i=0; i<Cart.cart.length; i++)
    {
      TotalCost += Cart.cart[i].cost;
      TotalTax += Cart.cart[i].tax;
      TotalDiscount += Cart.cart[i].discount;
      TotalPrice += Cart.cart[i].price;

      if(Cart.cart.length - 1 == i)
      {
        setState(() {

        });
      }
    }
  }


  LoadAddress() async {
    String? Contact = await Cookies.ReadCookie("Contact");
    account = await Account.PullFromFirebase("+91" + Contact.toString());
    print("AC " + account.Admin.toString());
    setState(() {

    });
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    order.PaymentId = response.paymentId.toString();
    order.PaymentTime = DateTime.now();
    order.OrderStatus = "Paid";
    order.PaymentDone = true;
    order.PaymentDetails = response.signature.toString() + " - " + response.orderId.toString();
    Order.UpdateOrder(order, order.OrderDocID);
    Navigator.pop(context);Navigator.pop(context);Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderStatus(isSucess: true, OrderNo: order.OrderNo)));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    order.PaymentId = response.code.toString();
    order.PaymentTime = DateTime.now();
    order.OrderStatus = "Payment Failed";
    order.PaymentDone = false;
    order.PaymentDetails = response.message.toString();
    Order.UpdateOrder(order, order.OrderDocID);
    Navigator.pop(context);Navigator.pop(context);Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderStatus(isSucess: false, OrderNo: order.OrderNo)));

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
   void initState() {
    // TODO: implement initState
    super.initState();
    LoadAddress();
    LoadTotals();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text("Delivering to"),
            ),
            Container(
              child: Text(account.FullName + ", " + account.Address1 + "," + account.Address2 + ", " + account.City + "," + account.State + ", " + account.Country + " - " + account.PinCode),
            ),
            GestureDetector(
              onTap: () async {
                var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => SetupAddress(account: account)));
                setState(() {

                });
                },
              child: Container(
                decoration: StyleOfButtons.VerifyButton(),
                padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Text("Edit Address", style: StyleOfTexts.VerifyButton(),),
              ),
            ),
            SizedBox(height: 50,),
            Container(
              child: Text("Amount To Pay"),
            ),
            Container(
              child: Text("₹ " + TotalPrice.toString()),
            ),
            GestureDetector(
              onTap: () async {
                String orderno = await Order.GenerateOrderID();
                order = Order(orderno, account.DocID, "", "", TotalPrice, "Pay Clicked", false, "Begin", "", DateTime.now(), "", "", DateTime.now(), "", DateTime.now(), DateTime.now());
                var doc = await Order.CreateBasicOrder(order);
                order.OrderDocID = doc.id;
                print(doc.id);
                var options = {
                  'key': 'rzp_live_XjDUv1yfuZx0vJ',
                  'amount': (TotalPrice *  100).toInt(),
                  'name': account.FullName,
                  'DocID': doc.id,
                  'OrderNo': orderno,
                  'AccountID': account.DocID,
                  'retry': {'enabled': true, 'max_count': 1},
                  'send_sms_hash': true,
                  'prefill': {
                    'contact': account.Contact,
                  }
                };
                _razorpay.open(options);

                //Navigator.push(context, MaterialPageRoute(builder: (context) => Home(account: account)));
              },
              child: Container(
                decoration: StyleOfButtons.VerifyButton(),
                padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Text("Proceed & Pay", style: StyleOfTexts.VerifyButton(),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
