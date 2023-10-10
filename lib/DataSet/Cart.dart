

import 'package:vegiehome/DataSet/Product.dart';

class Cart{
  late Product item;
  late int quantity;
  late double cost;
  late double discount;
  late String discountcoupoun;
  late double tax;
  late double price;
  late String note;

  static List<Cart> cart = <Cart>[];

  Cart(this.item, this.quantity, this.cost, this.discount, this.discountcoupoun, this.tax, this.price, this.note);

  static AddToCart(Cart cartItem)
  {
    cart.add(cartItem);
  }

  static RemoveFromCart(Cart cartItem)
  {
    cart.remove(cartItem);
  }

  static PushToFirebase(){

  }
}

