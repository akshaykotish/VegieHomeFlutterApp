import 'package:flutter/material.dart';
import 'package:vegiehome/ClientSide/CartPage.dart';
import 'package:vegiehome/DataSet/Cart.dart';
import 'package:vegiehome/Parts/Fnctns.dart';

import '../Admin/AddProduct.dart';
import '../DataSet/Product.dart';


class ClientProducts extends StatefulWidget {
  const ClientProducts({super.key});

  @override
  State<ClientProducts> createState() => _ClientProductsState();
}

class _ClientProductsState extends State<ClientProducts> {

  TextEditingController searchProduct = TextEditingController();

  bool isProductLoaded = false;

  List<Widget> products = <Widget>[];
  List<int> quantities = <int>[];

  List <Product> Products = <Product>[];

  Future<void> LoadProducts() async {
    var docs = await Product.PullAllProductsFromFirebase();
    for(int i=0; i<docs.docs.length; i++)
    {
      var data = docs.docs[i].data();
      Product product = Product(data["Name"], data["Details"], data["Cost"], data["MarginPer"], data["DiscountPer"], data["TaxPer"], data["Price"], data["Images"].cast<String>(), data["Unit"], data["Category"]);
      product.FirebaseProductID = docs.docs[i].id;
      bool isConsist =  product.Name.toLowerCase().contains(searchProduct.text.toLowerCase());
      if((searchProduct.text == "") || (searchProduct.text != "" && isConsist == true)) {
        Products.add(product);
        setState(() {

        });
      }
    }
  }


  void UpdateCart(int index){
      bool isAvailable = false;
      for(int i=0; i<Cart.cart.length; i++)
        {
          Cart ci = Cart.cart[i];
          if(ci.item.Name == Products[index].Name)
            {
              ci.quantity = quantities[index];
              ci.cost = (Products[index].Cost + ((Products[index].MarginPer/100) * Products[index].Cost)) * quantities[index];
              ci.discount = (Products[index].DiscountPer/100) * ci.cost;
              ci.tax = ((Products[index].TaxPer/100) * (ci.cost - ci.discount));
              ci.price = roundDouble((ci.cost - ci.discount) + ci.tax,2);
              print("Updated" + ci.price.toString());
              isAvailable = true;
            }

          if(Cart.cart.length - 1 == i && isAvailable == false)
            {
              double cost = ((Products[index].Cost + ((Products[index].MarginPer/100) * Products[index].Cost)) * quantities[index]);
              double discount = (Products[index].DiscountPer/100) * cost;
              double tax =  ((Products[index].TaxPer/100) * (cost - discount));
              Cart cartitem = Cart(Products[index], quantities[index], cost, discount, "", tax, roundDouble(cost - discount + tax,2), "");
              Cart.AddToCart(cartitem);
              print("ADded");
            }
        }
      if(Cart.cart.length  == 0 && isAvailable == false)
      {
        double cost = ((Products[index].Cost + ((Products[index].MarginPer/100) * Products[index].Cost)) * quantities[index]);
        double discount = (Products[index].DiscountPer/100) * cost;
        double tax =  ((Products[index].TaxPer/100) * (cost - discount));
        Cart cartitem = Cart(Products[index], quantities[index], cost, discount, "", tax, roundDouble(cost - discount + tax,2), "");
        Cart.AddToCart(cartitem);
        print("ADded");
      }

  }

  @override
  void initState() {
    super.initState();
    LoadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child:  Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextField (
                        controller: searchProduct,
                        decoration: InputDecoration(
                            labelText: 'Search Product',
                            hintText: 'Search Product',
                            suffix: Container(
                              child: GestureDetector(
                                  onTap: (){
                                    LoadProducts();
                                  },
                                  child: Icon(Icons.search)),
                            )
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var res  = await Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                        setState(() {

                        });
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: 60,
                        height: 60,
                        child: Stack(children: <Widget>[
                          Icon(Icons.shopping_cart),
                          Positioned(
                              child: Text(Cart.cart.length.toString(), style: TextStyle(color: Colors.green, fontSize: 20,), textAlign: TextAlign.right,))
                        ]),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 100,
                      childAspectRatio: 1/2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20
                    ),
                    itemCount: Products.length,
                    itemBuilder: (_, index){
                      quantities.add(0);
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 80,
                              child: Image.network(Products[index].Images[0]),
                            ),
                            Container(
                              child: Text(Products[index].Name),
                            ),
                            Container(
                              child: Text(Products[index].Price.toString()),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                      onTap: (){
                                        if(quantities[index] > 0) {
                                          quantities[index]--;
                                          UpdateCart(index);
                                          setState(() {

                                          });
                                        }
                                      },
                                      child: Icon(Icons.remove)),
                                  Text(Cart.cart.length > index ? Cart.cart[index].quantity.toString() + " " + Products[index].Unit : "0" + " " + Products[index].Unit),
                                  GestureDetector(
                                      onTap: (){
                                        quantities[index]++;
                                        UpdateCart(index);
                                        setState(() {

                                        });
                                      },
                                      child: Icon(Icons.add)),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    })
              ),
            ],
          ),
        ),
      ),
    );
  }
}
