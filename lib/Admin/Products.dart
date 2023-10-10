import 'package:flutter/material.dart';
import 'package:vegiehome/Admin/AddProduct.dart';
import 'package:vegiehome/DataSet/Product.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  bool isProductLoaded = false;

  TextEditingController searchText =  TextEditingController();

  List<Widget> products = <Widget>[];
  Future<void> LoadProducts() async {
    List<Widget> _products = <Widget>[];
    var docs = await Product.PullAllProductsFromFirebase();
    for(int i=0; i<docs.docs.length; i++)
      {
        var data = docs.docs[i].data();
        Product product = Product(data["Name"], data["Details"], data["Cost"], data["MarginPer"], data["DiscountPer"], data["TaxPer"], data["Price"], data["Images"].cast<String>(), data["Unit"], data["Category"]);

        product.FirebaseProductID = docs.docs[i].id;


        bool isConsist =  product.Name.toLowerCase().contains(searchText.text.toLowerCase());
        print("ABC = " + searchText.text + " - " + isConsist.toString());


        if((searchText.text == "") || (searchText.text != "" && isConsist == true)) {

          _products.add(
            Container(
              padding: EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () async {
                  var res = await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AddProduct(product: product)));
                  LoadProducts();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      child: Image.network(product.Images[0]),
                    ),
                    Container(
                      child: Text(product.Name),
                    ),
                    Container(
                      child: Text(product.Price.toString()),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if(i == docs.docs.length - 1)
          {
            setState(() {
              products = _products;
              isProductLoaded = true;
            });
          }
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
        margin: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            Container(
              child:  TextField (
                controller: searchText,
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
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: products,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
