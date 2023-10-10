import 'package:flutter/material.dart';
import 'package:vegiehome/ClientSide/Home.dart';
import 'package:vegiehome/DataSet/Account.dart';
import 'package:vegiehome/DataSet/Cookies.dart';
import 'package:vegiehome/Parts/StyleOfButtons.dart';
import 'package:vegiehome/Parts/StyleOfTexts.dart';


class SetupAddress extends StatefulWidget {
  Account account;
  SetupAddress({super.key, required this.account});

  @override
  State<SetupAddress> createState() => _SetupAddressState();
}

class _SetupAddressState extends State<SetupAddress> {


  TextEditingController Address1 = new TextEditingController();
  TextEditingController Address2 = new TextEditingController();
  TextEditingController City = new TextEditingController();
  TextEditingController State = new TextEditingController();
  TextEditingController Country = new TextEditingController();
  TextEditingController PinCode = new TextEditingController();

  @override
  void initState() {

    super.initState();

    setState(() {
      Address1.text = widget.account.Address1;
      Address2.text = widget.account.Address2;
      City.text = widget.account.City;
      State.text = widget.account.State;
      Country.text = widget.account.Country;
      PinCode.text = widget.account.PinCode;
    });
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
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    controller: Address1,
                    decoration: InputDecoration(
                        labelText: 'Address 1',
                        hintText: 'House No/Street No'
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    controller: Address2,
                    decoration: InputDecoration(
                        labelText: 'Address 2',
                        hintText: 'Colony/Society/Building/Area'
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    controller: City,
                    decoration: InputDecoration(
                        labelText: 'City',
                        hintText: 'City'
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    controller: State,
                    decoration: InputDecoration(
                        labelText: 'State',
                        hintText: 'State'
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    controller: Country,
                    decoration: InputDecoration(
                      labelText: 'Country',
                      hintText: 'Country',
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField (
                    maxLength: 6,
                    controller: PinCode,
                    decoration: InputDecoration(
                      labelText: 'Pin Code',
                      hintText: 'Pin Code',
                    ),
                  )
              ),
              GestureDetector(
                onTap: (){
                  widget.account.Address1 = Address1.text;
                  widget.account.Address2= Address2.text;
                  widget.account.City = City.text;
                  widget.account.State = State.text;
                  widget.account.Country = Country.text;
                  widget.account.PinCode = PinCode.text;

                  print("widget.account.DocID" + widget.account.DocID);

                  Account.PushToFirebaseOnID(widget.account, widget.account.DocID);

                  Cookies.SetCookie("ToOpen", "Home");

                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home(account: widget.account,)));

                },
                child: Container(
                  decoration: StyleOfButtons.NormalButton(),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Text("Save", style: StyleOfTexts.NormalText(),),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
