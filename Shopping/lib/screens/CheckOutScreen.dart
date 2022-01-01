import 'dart:convert';

import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:flutter_shopping_app/const/ConstApp.dart';
import 'package:flutter_shopping_app/const/Utils.dart';
import 'package:flutter_shopping_app/floor/dao/CartDao.dart';
import 'package:flutter_shopping_app/floor/entity/CartProduct.dart';
import 'package:flutter_shopping_app/model/OrderModel.dart';
import 'package:flutter_shopping_app/model/UserModel.dart';
import 'package:flutter_shopping_app/network/api_request.dart';
import 'package:flutter_shopping_app/state/StateManagement.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:rflutter_alert/rflutter_alert.dart';

class CheckOutScreen extends StatefulWidget {
  final CartDao dao;

  CheckOutScreen(this.dao);

  @override
  State<StatefulWidget> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Future loadUserInfo = findUser(FirebaseAuth.FirebaseAuth.instance.currentUser!.uid, context.read(userToken).state);
    bool isLoadFromServer = false;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text("Check Out"),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: widget.dao.getAllItemInCartByUid(context.read(userLogged).state != null ? context.read(userLogged).state!.uid : NOT_SIGN_IN),
          builder: (context, snapshot) {
            var items = snapshot.data as List<Cart>;
            return Column(
              children: [
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10 , vertical: 6),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Divider(thickness: 1,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(
                              future: loadUserInfo,
                              builder: (context,snapshot){
                                if(snapshot.connectionState == ConnectionState.waiting)
                                  return Center(child: CircularProgressIndicator(),);
                                else {
                                  var user = UserModel.fromJson(jsonDecode(snapshot.data.toString()));
                                  if(!isLoadFromServer){
                                    _nameController.text = user.name;
                                    _addressController.text = user.address;
                                    _phoneController.text = user.phone;

                                    isLoadFromServer = true;
                                  }

                                  return Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.account_circle),
                                                  SizedBox(width: 8,),
                                                  Text('${_nameController.text}')
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  showModalBottomSheet(
                                                      context: context, 
                                                      builder: (BuildContext context){
                                                        return SingleChildScrollView(
                                                          child: Padding(
                                                            padding: EdgeInsets.all(8),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('Name',style: TextStyle(fontStyle: FontStyle.italic , color: Colors.grey)),
                                                                TextField(
                                                                  keyboardType: TextInputType.text,
                                                                  controller: _nameController,
                                                                  decoration: InputDecoration(
                                                                    hintText: 'Name'
                                                                  ),
                                                                ),

                                                                Text('Address',style: TextStyle(fontStyle: FontStyle.italic , color: Colors.grey)),
                                                                TextField(
                                                                  keyboardType: TextInputType.streetAddress,
                                                                  controller: _addressController,
                                                                  decoration: InputDecoration(
                                                                      hintText: 'Address'
                                                                  ),
                                                                ),

                                                                Text('Phone',style: TextStyle(fontStyle: FontStyle.italic , color: Colors.grey)),
                                                                TextField(
                                                                  keyboardType: TextInputType.phone,
                                                                  controller: _phoneController,
                                                                  decoration: InputDecoration(
                                                                      hintText: 'Phone'
                                                                  ),
                                                                ),

                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          primary: Colors.red
                                                                        ),
                                                                        onPressed: () => Navigator.of(context).pop(),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Text('CANCEL' , style: TextStyle(color: Colors.white),),
                                                                        )),
                                                                    SizedBox(width: 16,),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            primary: Colors.black
                                                                        ),
                                                                        onPressed: (){
                                                                          setState(() {
                                                                            Navigator.of(context).pop();
                                                                          });
                                                                        },
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Text('SAVE' , style: TextStyle(color: Colors.white),),
                                                                        )),
                                                                  ],
                                                                )

                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Icon(Icons.edit),)
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on_outlined),
                                                  SizedBox(width: 8,),
                                                  Text('${_addressController.text}')
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.phone),
                                                  SizedBox(width: 8,),
                                                  Text('${_phoneController.text}')
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                        Divider(thickness: 1,),
                        //Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total' , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold),),
                            Text('\$${items != null && items.length > 0 ?
                            items.map<double>((m) => m.price * m.quantity).reduce((value, element) => value + element).toStringAsFixed(2)
                                : 0}')
                          ],
                        ),
                        Divider(thickness: 1,),
                        //Deliver Charge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery Charge' , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold),),
                            Text('\$${items != null && items.length > 0 ?
                            (items.map<double>((m) => m.price * m.quantity).reduce((value, element) => value + element)* 0.1).toStringAsFixed(2)
                                : 0}')
                          ],
                        ),
                        Divider(thickness: 1,),
                        //Sub Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sub Total' , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold),),
                            Text('\$${items != null && items.length > 0 ?
                            ((items.map<double>((m) => m.price * m.quantity).reduce((value, element) => value + element)) + items.map<double>((m) => m.price * m.quantity).reduce((value, element) => value + element)* 0.1).toStringAsFixed(2)
                                : 0}',
                                style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold)
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          child: context.read(userLogged).state != null ? ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.black),
                            onPressed: (){
                              proceedOrder(widget.dao,items);
                            },
                            child: Text(
                              "PROCEED CHECK OUT" ,
                              style: TextStyle(color: Colors.white),),
                          ) : Container(),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: items == null ? 0 : items.length,
                      itemBuilder: (context, index) {
                        return _cartItem(items[index]);
                      }),
                ),

              ],
            );
          },
        ),
      ),
    );
  }

  Widget _cartItem(Cart item) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: Image(
                  image: NetworkImage(item.imgUrl),
                  fit: BoxFit.fill,
                ),
              ),
              flex: 2,
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: EdgeInsets.only(bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ////////////// * Product Name * ///////////////////
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        item.name,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ////////////// * Product Price * ///////////////////
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Colors.grey,
                            size: 16,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(
                              '${item.price}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    ////////////// * Product Size * ///////////////////
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(
                              'Size ${item.size}',
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ////////////// * NumberPick * ///////////////////
            Center(
              child: Text('x${item.quantity}',
                style: TextStyle(fontSize: 24),),
            )
          ],
        ),
      ),
    );
  }

  void proceedOrder(CartDao dao , List<Cart> items) {
    //paste here code

    //If user not login , ask login
    var user = FirebaseAuth.FirebaseAuth.instance.currentUser;
    if(user == null){  //He doesn't have account before => create account
      FirebaseAuthUi.instance().launchAuth([
        AuthProvider.phone()
      ]).then((firebaseUser){
        //Refresh State
        context.read(userLogged).state = FirebaseAuth.FirebaseAuth.instance.currentUser;

      })
          .catchError((e){
        if(e is PlatformException){
          if(e.code == FirebaseAuthUi.kUserCancelledError)
            showOnlySnackBar(_scaffoldKey, context, 'User cancelled login');
          else
            showOnlySnackBar(_scaffoldKey, context, '${e.message.toString() ?? 'Unknown error'}');
        }
      });
    }
    else {
      //Already login
      var totalPayment = double.parse(items.length > 0 ? ((items.map<double>((m) => m.price * m.quantity).reduce((value, element) => value + element)) + items.map<double>((m) => m.price * m.quantity).reduce((value, element) => value + element)* 0.1).toStringAsFixed(2) : 0.toString());
      FirebaseAuth.FirebaseAuth.instance.currentUser!
          .getIdToken()
          .then((firebaseToken) async{

        String clientToken = await getBraintreeClientToken(firebaseToken);
        print('braintree client token: $clientToken');


        // var braintreePayment = new BraintreePayment();
        // var data = await braintreePayment.showDropIn(
        //     nonce: clientToken,
        //     amount: totalPayment.toString(),
        //     enableGooglePay: true,
        //     nameRequired: false
        // );


        final request = BraintreeDropInRequest(
          maskCardNumber: true,
          vaultManagerEnabled: true,
          requestThreeDSecureVerification: true,
          maskSecurityCode: true,
          venmoEnabled: true,
          cardEnabled: true,
          collectDeviceData: true,
          tokenizationKey: '.........................................',  //clientToken
          amount: totalPayment.toString(),
          clientToken: clientToken,  //clientToken
          googlePaymentRequest: BraintreeGooglePaymentRequest(
            totalPrice: totalPayment.toString(),
            currencyCode: 'USD',
            billingAddressRequired: false,
          ),
          paypalRequest: BraintreePayPalRequest(
            amount: totalPayment.toString(),
            displayName: 'Shopping',
          ),
        );


        BraintreeDropInResult? resultPayment = await BraintreeDropIn.start(request);

        print('check nonce: ${resultPayment!.paymentMethodNonce.nonce}');
        print('check totalPayment: ${totalPayment}');


        var result = await checkout(
            firebaseToken,
            totalPayment,
            resultPayment!.paymentMethodNonce.nonce);  //data['paymentNonce']

        if(result){
          //Payment success

          //Print json code to view model
          OrderModel orderModel = OrderModel(
            uid: context.read(userLogged).state!.uid,
            orderName: _nameController.text,
            orderPhone: _phoneController.text,
            orderAddress: _addressController.text,
            orderTransactionId: 'Transaction Id -Implement late',
            orderStatus: 0,
            orderNumber: 0,
            orderAmount: totalPayment,
            orderDate:  DateTime.now().toString(),
            orderDetails: items
          );

          print('Order Model : ${jsonEncode(orderModel)}');

          //Call submit order
          var result = await submitOrderApi(context.read(userToken).state,orderModel);

          print('print result: ${result}');


          if(result == 'Created'){

            var resultDelete = await dao.clearCartByUid(FirebaseAuth.FirebaseAuth.instance.currentUser!.uid);

            setState(() {
              Alert(
                  context: context,
                  type: AlertType.success,
                  title: 'ORDER SUCCESS',
                  desc: 'Thanks you for purchase',
                  buttons: [
                    DialogButton(child: Text('Go Back'), onPressed: (){
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/productList');
                    })
                  ]
              ).show();
            });
          }
          else {
            showOnlySnackBar(_scaffoldKey, context, result);
          }


        }
        else{
          //Failed
          Alert(
              context: context,
              type: AlertType.error,
              title: 'PAYMENT FAILED',
              desc: 'Error happened',
              buttons: [
                DialogButton(child: Text('OK'), onPressed: (){
                  Navigator.pop(context);
                })
              ]
          ).show();
        }
      });
    }
  }
}
