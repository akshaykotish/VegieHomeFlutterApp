import 'package:flutter/material.dart';
import 'package:vegiehome/ClientSide/OrderPage.dart';
import 'package:vegiehome/DataSet/Cart.dart';
import 'package:vegiehome/Parts/Fnctns.dart';

import '../Parts/StyleOfButtons.dart';
import '../Parts/StyleOfTexts.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  double TotalCost = 0;
  double TotalTax = 0;
  double TotalDiscount = 0;
  String DiscountCoupoun = "";
  double TotalPrice = 0;

  List<Widget> cartitems = <Widget>[];

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

  LoadCart(){

    List<Widget> _cartitems = <Widget>[];

    for(int i=0; i<Cart.cart.length; i++)
      {
        int a = i;
        Cart cartitem = Cart.cart[i];
        _cartitems.add(
         Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  child: Image.network(cartitem.item.Images[0]),
                ),
                Container(
                  child: Text(cartitem.item.Name),
                ),
                Container(
                  child: Text(cartitem.quantity.toString()),
                ),
                Container(
                  child: Text("₹ " + cartitem.price.toString()),
                ),
                Container(
                  child: GestureDetector(
                      onTap: ()
                      async {
                        await Cart.cart.remove(cartitem);
                        cartitems.removeAt(a);
                        await LoadTotals();
                        print("Removed");
                        setState(() {

                        });
                      },
                      child: Icon(Icons.delete)),
                )
              ],
            ),
          )
        );

        if(i == Cart.cart.length - 1)
          {
            cartitems = _cartitems;
            setState(() {

            });
          }
      }
  }

  @override
  void initState() {
    super.initState();
    LoadCart();
    LoadTotals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text("Cart"),
              ),
              Container(
                child: Column(
                  children: cartitems,
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: 100,
                            child: Text("Cost:")
                        ),
                        Container(
                            width: 100,
                            child: Text("₹ " + roundDouble(TotalCost, 2).toString()),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: 100,
                            child: Text("Discount:")
                        ),
                        Container(
                          width: 100,
                          child: Text("₹ " + roundDouble(TotalDiscount, 2).toString()),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: 100,
                            child: Text("Tax:")
                        ),
                        Container(
                          width: 100,
                          child: Text("₹ " + roundDouble(TotalTax, 2).toString()),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: 100,
                            child: Text("Total Price:")
                        ),
                        Container(
                          width: 100,
                          child: Text("₹ " + roundDouble(TotalPrice,2).toString()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                      },
                      child: Container(
                        decoration: StyleOfButtons.VerifyButton(),
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: Text("Confirm Order", style: StyleOfTexts.VerifyButton(),),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
