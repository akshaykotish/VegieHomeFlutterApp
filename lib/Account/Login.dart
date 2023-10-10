import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vegiehome/Account/SetupAddress.dart';
import 'package:vegiehome/DataSet/Account.dart';
import 'package:vegiehome/DataSet/Cookies.dart';
import 'package:vegiehome/Parts/StyleOfButtons.dart';
import 'package:vegiehome/Parts/StyleOfTexts.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isRequestOTP = true;
  bool isOTP = false;
  bool isVerify = false;
  bool isReqestOTPAgain = false;

  String ErrorMessage = "";

  TextEditingController fullName = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController OTP = TextEditingController();

  int requestOTPTime = 60;

  var receivedID;

  Future RequestOTP() async{
    _auth.verifyPhoneNumber(
        phoneNumber: "+91" + contact.text,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then(
                (value) => print('Logged In Successfully'),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          ErrorMessage = "Please enter correct OTP.";
          setState(() {

          });
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          receivedID = verificationId;
          isOTP = true;
          isVerify = true;
          isRequestOTP = false;

          setState(() {});

          Timer(Duration(seconds: 60), (){
            isReqestOTPAgain = true;
            setState(() {

            });
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('TimeOut');
          isReqestOTPAgain = true;
          setState(() {

          });
        }
    );
  }

  Future<void> verifyOTPCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: receivedID,
      smsCode: OTP.text,
    );
    await _auth
        .signInWithCredential(credential)
        .then((value) async {
          print('User Login In Successful');

          Account userData = Account("", "", fullName.text, "+91"+contact.text, "", "", "", "", "", "", "", "", "", false, DateTime.now(), "");
          var account = await Account.PullFromFirebase("+91" + contact.text) as Account;
          if(account != null && account.DocID != "")
            {
              account.FullName = fullName.text;
              userData = await Account.PushToFirebaseOnID(account, account.DocID);
            }
          else{
              userData = await Account.PushToFirebase(userData);
          }
          print("DoC ID is " + userData.DocID + " and " + userData.Address1 + " or " + account.Address1);

            ErrorMessage = "Login Suceed.";
            setState(() {

            });


          Cookies.SetCookie("Contact", contact.text);
          Cookies.SetCookie("ToOpen", "SetupAddress");

            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => SetupAddress(account: userData)));

        });
        // .onError((error, stackTrace){
        //       ErrorMessage = "Please enter correct OTP.";
        //       setState(() {
        //
        //       });
        //   });
  }

  @override
  void dispose() {
    _auth = FirebaseAuth.instance;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white12,
          margin: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextField (
                  controller: fullName,
                  decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Full Name'
                  ),
                )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    controller: contact,
                    decoration: InputDecoration(
                        prefix: Text("+91"),
                        labelText: 'Contact',
                        hintText: '1234567890'
                    ),
                    maxLength: 10,
                  )
              ),
              Visibility(
                visible: isRequestOTP,
                child: GestureDetector(
                  onTap: (){
                    isReqestOTPAgain = false;
                    RequestOTP();
                  },
                  child: Container(
                    decoration: StyleOfButtons.VerifyButton(),
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: Text("Request OTP", style: StyleOfTexts.VerifyButton(),),
                  ),
                ),
              ),
              Visibility(
                visible: isOTP,
                child: Container(
                  width: MediaQuery.of(context).size.width/2 + MediaQuery.of(context).size.width/3,
                  height: 80,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        height: 80,
                        child:  TextField (
                          maxLength: 6,
                          controller: OTP,
                          decoration: InputDecoration(
                              labelText: 'OTP',
                              hintText: 'OTP'
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                          height: 80,
                        child: Visibility(
                          visible: isReqestOTPAgain,
                          child: GestureDetector(
                            onTap: (){
                              RequestOTP();
                              ErrorMessage = "OTP resent.";
                              setState(() {

                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: StyleOfButtons.VerifyButton(),
                              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                              child: Text("Request OTP", style: StyleOfTexts.VerifyButton(),),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isVerify,
                child: GestureDetector(
                  onTap: (){
                    verifyOTPCode();
                  },
                  child: Container(
                    decoration: StyleOfButtons.VerifyButton(),
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: Text("Verify", style: StyleOfTexts.VerifyButton(),),
                  ),
                ),
              ),
              Container(
                decoration: StyleOfButtons.VerifyButton(),
                padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Text(ErrorMessage, style: StyleOfTexts.ErrorMessage(),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
