import 'package:flutter/material.dart';
import 'package:vegiehome/Admin/AdminPage.dart';
import 'package:vegiehome/ClientSide/ClientProducts.dart';
import 'package:vegiehome/DataSet/Account.dart';

class Home extends StatefulWidget {
  Account account;
  Home({super.key, required this.account});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isAdmin = false;

  @override
  void initState() {
    super.initState();

    if(widget.account.Admin)
      {
        setState(() {
          isAdmin = true;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: isAdmin,
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminPage()));
                  },
                  child: Container(
                    width: 100,
                    height: 60,
                    color: Colors.white12,
                    alignment: Alignment.center,
                    child: Text("Admin"),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ClientProducts()));
                },
                child: Container(
                  width: 100,
                  height: 60,
                  color: Colors.white12,
                  alignment: Alignment.center,
                  child: Text("Client Products"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
