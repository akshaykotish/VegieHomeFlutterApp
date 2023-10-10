import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vegiehome/DataSet/Product.dart';
import 'package:vegiehome/Parts/Fnctns.dart';
import 'package:vegiehome/Parts/StyleOfButtons.dart';
import 'package:vegiehome/Parts/StyleOfTexts.dart';

class AddProduct extends StatefulWidget {
  Product product;
  AddProduct({super.key, required this.product});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {


  ImagePicker _picker = ImagePicker();

  List<String> ImageURLs = <String>[];
  List<Widget> Images = <Widget>[];

  TextEditingController ProductName = TextEditingController();
  TextEditingController ProductCategory = TextEditingController();
  TextEditingController ProductDetails = TextEditingController();
  TextEditingController ProductCost = TextEditingController();
  TextEditingController ProductDiscountPer = TextEditingController();
  TextEditingController ProductMarginPer = TextEditingController();
  TextEditingController ProductAfterMargin = TextEditingController();
  TextEditingController ProductTaxPer = TextEditingController();
  TextEditingController ProductPrice = TextEditingController();
  TextEditingController ProductUnit = TextEditingController();

  @override
  void initState() {
    super.initState();

    print(widget.product.FirebaseProductID);
    if(widget.product.Name == "") {
      ProductCost.text = "0";
      ProductDiscountPer.text = "0";
      ProductMarginPer.text = "25";
      ProductAfterMargin.text = "0";
      ProductTaxPer.text = "5";
      ProductPrice.text = "0";
    }
    else{
      ProductCost.text = widget.product.Cost.toString();
      ProductDiscountPer.text = widget.product.DiscountPer.toString();
      ProductCostCalculator();
      ProductTaxPer.text = widget.product.TaxPer.toString();
      ProductPrice.text = widget.product.Price.toString();

      ProductName.text = widget.product.Name.toString();
      ProductCategory.text = widget.product.Category.toString();
      ProductDetails.text = widget.product.Details.toString();
      ImageURLs = widget.product.Images;
      ProductUnit.text =  widget.product.Unit;
      DisplayImages();
    }
  }

  void DisplayImages(){
    Images = <Widget>[];
    for(String url in ImageURLs)
    {
      String zx = url;
      Images.add(
          Container(
            width: 100,
            height: 180,
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                //Image.file(new File(url), fit: BoxFit.fill, width: 70, height: 70,),
                Image.network(url, fit: BoxFit.fill, width: 100, height: 100),
                Container(
                  child: GestureDetector(
                      onTap: (){
                        print("Count ${zx}");
                        //ImageURLs.removeAt(zx);
                        ImageURLs.remove(zx);
                        print(ImageURLs);
                        DisplayImages();
                      },
                      child: Text("Delete")),
                )
              ],
            ),
          )
      );
      setState(() {

      });
    }
    setState(() {

    });
  }

  Future<void> PickImages() async {

    List<XFile>? images = await _picker.pickMultiImage();

    int i = 0;
    for(XFile image in images) {
      String zx = image.path.toString();

      final storage = FirebaseStorage.instance;

      File file = new File(image.path);
      var result = await FirebaseStorage.instance.ref().child("files/" + image.name).putFile(file);
      String url = await result.ref.getDownloadURL();
      print(url);

      ImageURLs .add(url);
      i++;
      if(i == images.length)
        {
          DisplayImages();
        }
    }
  }


  void ProductCostCalculator(){
    double pcost = double.parse(ProductCost.text);
    double marginper  = double.parse(ProductMarginPer.text);
    double discountper = double.parse(ProductDiscountPer.text);
    double taxper = double.parse(ProductTaxPer.text);

    double Margin = ((marginper/100) * pcost);

    double PriceAfterMargin = roundDouble(pcost + Margin, 2);

    double Discount = roundDouble(((discountper/100) * PriceAfterMargin), 2);

    double PriceAfterDiscount = roundDouble(PriceAfterMargin - Discount, 2);

    double Tax  = roundDouble(((taxper/100) * PriceAfterDiscount), 2);

    double Price = roundDouble(PriceAfterDiscount + Tax, 2);

    print(PriceAfterMargin.toString() + " " + pcost.toString());
    ProductPrice.text = Price.toString();
    ProductAfterMargin.text = (PriceAfterMargin).toString();

    setState(() {

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white12,
          margin: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  PickImages();
                },
                child: Container(
                  child: Text("Add Images"),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: Images,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    controller: ProductName,
                    decoration: InputDecoration(
                        labelText: 'Product Name',
                        hintText: 'Product Name'
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    controller: ProductCategory,
                    decoration: InputDecoration(
                        labelText: 'Product Category',
                        hintText: 'Product Category'
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    controller: ProductDetails,
                    decoration: InputDecoration(
                        labelText: 'Product Details',
                        hintText: 'Product Details'
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    controller: ProductUnit,
                    decoration: InputDecoration(
                        labelText: 'Product Unit',
                        hintText: 'Product Unit'
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    keyboardType: TextInputType.number,
                    controller: ProductCost,
                    onChanged: (e){
                      ProductCostCalculator();
                    },
                    decoration: InputDecoration(
                        labelText: 'Product Cost',
                        hintText: 'Product Cost'
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    keyboardType: TextInputType.number,
                    controller: ProductMarginPer,
                    onChanged: (e){
                      ProductCostCalculator();
                    },
                    decoration: InputDecoration(
                        labelText: 'Product Margin (%)',
                        hintText: 'Product Margin (%)'
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    keyboardType: TextInputType.number,
                    controller: ProductAfterMargin,
                    onChanged: (e){
                      ProductCostCalculator();
                    },
                    decoration: InputDecoration(
                        labelText: 'Product Cost After 25% Margin',
                        hintText: 'Product Cost After 25% Margin'
                    ),
                  )
              ),

              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    keyboardType: TextInputType.number,
                    controller: ProductDiscountPer,
                    onChanged: (e){
                      ProductCostCalculator();
                    },
                    decoration: InputDecoration(
                        labelText: 'Product Discount (%)',
                        hintText: 'Product Discount (%)'
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    keyboardType: TextInputType.number,
                    onChanged: (e){
                      ProductCostCalculator();
                    },
                    controller: ProductTaxPer,
                    decoration: InputDecoration(
                        labelText: 'Product Tax (%)',
                        hintText: 'Product Tax (%)'
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    keyboardType: TextInputType.number,
                    onChanged: (e){
                      ProductCostCalculator();
                    },
                    controller: ProductPrice,
                    decoration: InputDecoration(
                        labelText: 'Product Price',
                        hintText: 'Product Price'
                    ),
                  )
              ),
              GestureDetector(
                onTap: (){
                  Product product = Product(ProductName.text, ProductDetails.text, double.parse(ProductCost.text), double.parse(ProductMarginPer.text), double.parse(ProductDiscountPer.text), double.parse(ProductTaxPer.text),  double.parse(ProductPrice.text), ImageURLs, ProductUnit.text, ProductCategory.text);

                  if(widget.product.FirebaseProductID == "") {
                    Product.PushToFirebase(product);
                  }
                  else{
                    Product.PushToFirebaseOnProductID(product, widget.product.FirebaseProductID);
                  }

                  Navigator.pop(context);
                },
                child: Container(
                  decoration: StyleOfButtons.VerifyButton(),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Text("Save", style: StyleOfTexts.VerifyButton(),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
