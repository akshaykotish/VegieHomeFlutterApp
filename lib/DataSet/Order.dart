

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegiehome/DataSet/Cart.dart';

class Order{
  String OrderNo = "";
  String AccountDocID = "";
  String OrderDocID = "";
  String PaymentId = "";
  double Amount =  0;
  String PaymentDetails = "";
  bool PaymentDone  = false;
  String OrderStatus = "";
  String OrderPacked = "";
  DateTime OrderPackTime = DateTime.now();
  String OrderPackBy = "";
  String OrderDelivered = "";
  DateTime OrderDeliveryTime = DateTime.now();
  String DeliveryBy = "";
  DateTime PaymentTime= DateTime.now();
  DateTime TimeStamp= DateTime.now();


  Order(this.OrderNo, this.AccountDocID, this.OrderDocID, this.PaymentId, this.Amount, this.PaymentDetails, this.PaymentDone, this.OrderStatus, this.OrderPacked, this.OrderPackTime, this.OrderPackBy, this.OrderDelivered, this.OrderDeliveryTime, this.DeliveryBy, this.PaymentTime, this.TimeStamp);

  static Future<String> GenerateOrderID() async {
    String orderID = await DateTime.now().toString().replaceAll("-", "").replaceAll(" ", "").replaceAll(":", "").replaceAll(".", "");
    return orderID;
  }

  static CreateBasicOrder(Order order)
  async {
    var db = await FirebaseFirestore.instance;
    var doc = await db.collection("Orders").add({
      "OrderNo": order.OrderNo,
      "AccountDocID": order.AccountDocID,
      "PaymentId": order.PaymentId,
      "Amount": order.Amount,
      "PaymentDetails": order.PaymentDetails,
      "PaymentDone": order.PaymentDone,
      "OrderStatus": order.OrderStatus,
      "OrderPacked": order.OrderPacked,
      "OrderPackTime": order.OrderPackTime,
      "OrderPackBy": order.OrderPackBy,
      "OrderDelivered": order.OrderDelivered,
      "OrderDeliveryTime": order.OrderDeliveryTime,
      "DeliveryBy": order.DeliveryBy,
      "PaymentTime": order.PaymentTime,
      "TimeStamp": order.TimeStamp
    });

    order.OrderDocID = doc.id;

    for(int i=0; i<Cart.cart.length; i++) {
      var docCart = await db.collection("Orders").doc(doc.id)
          .collection("Cart")
          .add({
        "product": Cart.cart[i].item.FirebaseProductID,
        "quantity": Cart.cart[i].quantity,
        "cost": Cart.cart[i].cost,
        "discount":Cart.cart[i].discount,
        "discountcoupoun":Cart.cart[i].discountcoupoun,
        "tax":Cart.cart[i].tax,
        "price": Cart.cart[i].price,
        "note": Cart.cart[i].note
      });
      Cart.cart.removeAt(i);
    }

    var docCart = await db.collection("Account").doc(order.AccountDocID).collection("Orders").add({
      "OrderID": doc.id,
      "OrderPath": doc.path,
      "OrderNo": order.OrderNo,
      "OrderTime": DateTime.now(),
    });


    return doc;
  }
  static UpdateOrder(Order order, String DocID)
  async {
    var db = await FirebaseFirestore.instance;
    var doc = await db.collection("Orders").doc(DocID).set({
      "OrderNo": order.OrderNo,
      "AccountDocID": order.AccountDocID,
      "OrderDocID": order.OrderDocID,
      "PaymentId": order.PaymentId,
      "Amount": order.Amount,
      "PaymentDetails": order.PaymentDetails,
      "PaymentDone": order.PaymentDone,
      "OrderStatus": order.OrderStatus,
      "OrderPacked": order.OrderPacked,
      "OrderPackTime": order.OrderPackTime,
      "OrderPackBy": order.OrderPackBy,
      "OrderDelivered": order.OrderDelivered,
      "OrderDeliveryTime": order.OrderDeliveryTime,
      "DeliveryBy": order.DeliveryBy,
      "PaymentTime": order.PaymentTime,
      "TimeStamp": order.TimeStamp
    });

    return doc;
  }

}