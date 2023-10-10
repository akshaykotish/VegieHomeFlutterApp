import "package:flutter/material.dart";

class OrderStatus extends StatefulWidget {
  bool isSucess;
  String OrderNo = "";

  OrderStatus({super.key, required this.isSucess, required this.OrderNo});

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Order Status "  + (widget.isSucess == true ? "Succes" : "Failed, try again")),
            Text("Order ID: " + widget.OrderNo)
          ],
        ),
      )
    );
  }
}
