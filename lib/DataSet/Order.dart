

import 'package:vegiehome/DataSet/Cart.dart';

class Order{
  String OrderNo = "";
  List<Cart> cart = <Cart>[];
  String PaymentId = "";
  double amount =  0;
  String PaymentDetails = "";
  bool PaymentDone  = false;
  DateTime PaymentTime= DateTime.now();
  DateTime TimeStamp= DateTime.now();
}