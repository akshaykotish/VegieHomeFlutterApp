

import 'package:cloud_firestore/cloud_firestore.dart';

class Product{
  String FirebaseProductID = "";
  String Name = "";
  String Details = "";
  double Cost = 0;
  double MarginPer = 0;
  double DiscountPer = 0;
  double TaxPer = 0;
  double Price = 0;
  List<String> Images = <String>[];
  String Unit;
  String Category;

  Product(this.Name, this.Details, this.Cost, this.MarginPer, this.DiscountPer, this.TaxPer, this.Price, this.Images, this.Unit, this.Category);

  static PushToFirebase(Product product) async
  {
    var db = await FirebaseFirestore.instance;
    var doc = await db.collection("Products").add({
      "Name": product.Name,
      "Details": product.Details,
      "Cost": product.Cost,
      "MarginPer": product.MarginPer,
      "DiscountPer": product.DiscountPer,
      "TaxPer": product.TaxPer,
      "Price": product.Price,
      "Images": product.Images,
      "Unit": product.Unit,
      "Category": product.Category
    });
    return product;
  }


  static PushToFirebaseOnProductID(Product product, FBProductID) async
  {
    var db = await FirebaseFirestore.instance;
    var res = await db.collection("Products").doc(FBProductID).set({
      "Name": product.Name,
      "Details": product.Details,
      "Cost": product.Cost,
      "MarginPer": product.MarginPer,
      "DiscountPer": product.DiscountPer,
      "TaxPer": product.TaxPer,
      "Price": product.Price,
      "Images": product.Images,
      "Unit": product.Unit,
      "Category": product.Category
    });
    return product;
  }

  static PullAllProductsFromFirebase()
  async {
    var db = await FirebaseFirestore.instance;
    var docs = await db.collection("Products").get();
    return docs;
  }
}