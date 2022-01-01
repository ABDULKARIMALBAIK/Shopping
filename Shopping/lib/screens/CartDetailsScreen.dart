import 'dart:convert';

import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:flutter_shopping_app/const/ConstApp.dart';
import 'package:flutter_shopping_app/const/Utils.dart';
import 'package:flutter_shopping_app/floor/dao/CartDao.dart';
import 'package:flutter_shopping_app/floor/entity/CartProduct.dart';
import 'package:flutter_shopping_app/model/OrderModel.dart';
import 'package:flutter_shopping_app/network/api_request.dart';
import 'package:flutter_shopping_app/state/StateManagement.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:rflutter_alert/rflutter_alert.dart';

class CartDetailsScreen extends StatefulWidget {
  final CartDao dao;

  CartDetailsScreen(this.dao) : super();

  @override
  State<StatefulWidget> createState() => _CartDetailsScreenState();
}

class _CartDetailsScreenState extends State<CartDetailsScreen> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cart Details"),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
              onPressed: () async{
                await widget.dao.clearCartByUid(FirebaseAuth.FirebaseAuth.instance.currentUser == null ? NOT_SIGN_IN : FirebaseAuth.FirebaseAuth.instance.currentUser!.uid);
                setState(() {});
              },
              icon: Icon(Icons.remove_shopping_cart))
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: widget.dao.getAllItemInCartByUid(context.read(userLogged).state != null ? context.read(userLogged).state!.uid : NOT_SIGN_IN),
          builder: (context, snapshot) {
            var items = snapshot.data as List<Cart>;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: items == null ? 0 : items.length,
                      itemBuilder: (context, index) {
                        return _cartItem(items[index]);
                      }),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
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
                        ///////////////// * Checkout button *///////////////
                        //if user is not login => hide the button
                        Container(
                          width: double.infinity,
                          child: context.read(userLogged).state != null ? RaisedButton(
                            color: Colors.black,
                            onPressed: (){
                              Navigator.of(context).pushNamed('/checkOut');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("CHECK OUT" , style: TextStyle(color: Colors.white),),
                            ),
                          ) : Container(),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _cartItem(Cart item) {
    return Slidable(
      child: Card(
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
                child: ElegantNumberButton(
                  initialValue: item.quantity,
                  minValue: 1,
                  maxValue: 100,
                  buttonSizeHeight: 20,
                  buttonSizeWidth: 25,
                  color: Colors.white38,
                  decimalPlaces: 0,
                  onChanged: (value) async {
                    item.quantity = value as int;
                    await widget.dao.updateCart(item);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          icon: Icons.delete,
          color: Colors.red,
          onTap: () async {
            await widget.dao.deleteCart(item);
          },
        )
      ],
    );
  }
}
