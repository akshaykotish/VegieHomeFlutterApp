import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vegiehome/Account/Login.dart';
import 'package:vegiehome/Account/SetupAddress.dart';
import 'package:vegiehome/ClientSide/Home.dart';
import 'package:vegiehome/DataSet/Cookies.dart';

import '../DataSet/Account.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Setup() async {
    String? ToOpen = await Cookies.ReadCookie("ToOpen");

    if(ToOpen != null) {
      if(ToOpen == "Home")
      {
        Timer(Duration(seconds: 5), () async {
          String? Contact = await Cookies.ReadCookie("Contact");
          Account account = await Account.PullFromFirebase("+91" + Contact.toString());
          print("AC " + account.Admin.toString());
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home(account: account)));
        });
      }
      else if(ToOpen == "SetupAddress")
      {
        Timer(Duration(seconds: 5), () async {
          String? Contact =await Cookies.ReadCookie("Contact");
          Account account = await Account.PullFromFirebase("+91" + Contact.toString());
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => SetupAddress(account: account)));
        });
      }
      else{
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      }

    }
    else{
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  void initState() {
    Cookies.init();
    super.initState();
    Setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("VegieHome"),
        ),
      ),
    );
  }
}
