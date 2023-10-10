import 'package:flutter/material.dart';
import 'package:vegiehome/Admin/AddProduct.dart';
import 'package:vegiehome/Admin/Products.dart';
import 'package:vegiehome/DataSet/Product.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white12,
          margin: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Product p = Product("", "", 0, 0, 0, 0, 0, [], "", "");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct(product: p,)));
                },
                child: Container(
                  child: Text("Add Products"),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Products()));
                },
                child: Container(
                  child: Text("View Products"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
