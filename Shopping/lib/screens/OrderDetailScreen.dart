import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shopping_app/const/Utils.dart';
import 'package:flutter_shopping_app/model/OrderModel.dart';
import 'package:flutter_shopping_app/model/UserModel.dart';
import 'package:flutter_shopping_app/network/api_request.dart';
import 'package:flutter_shopping_app/state/StateManagement.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kenburns/kenburns.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:flutter_riverpod/all.dart';

class OrderDetailScreen extends ConsumerWidget {


  @override
  Widget build(BuildContext context, ScopedReader watch) {

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: Center(child: Text('Order #${context.read(selectedOrder).state.toString().padLeft(6,'0')}'),),
                backgroundColor: Color(0xFF0C1B37),
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back , color: Colors.white,),
                ),),
              key: _scaffoldKey,
              resizeToAvoidBottomInset: true,
              backgroundColor: Color(0xFF0C1B37),
              body: FutureBuilder(
                future: fetchOrderDetail(
                  context.read(userToken).state,
                  FirebaseAuth.instance.currentUser!.uid,
                  context.read(selectedOrder).state.orderNumber
                ),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(),);
                  else {

                    var order = snapshot.data as OrderModel;
                    if(order == null)
                      return Center(child: Text('Can not get order detail',style: GoogleFonts.montserrat(color: Colors.white,fontSize: 16),
                      ),);

                    else {
                      return ListView.builder(
                          itemCount: order.orderDetails.length,
                          itemBuilder: (context,index){
                            return Padding(
                              padding: EdgeInsets.all(8),
                              child: Card(
                                child: Padding(padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${order.orderDetails[index].name}',style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
                                          Text('${order.orderDetails[index].price}')
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(order.orderDetails[index].imgUrl),
                                          ),
                                          SizedBox(width: 8,),
                                          Text('${order.orderDetails[index].size} x${order.orderDetails[index].quantity}',style: GoogleFonts.montserrat(),),

                                        ],
                                      ),
                                    ],
                                  ),),
                              ),
                            );
                          });
                    }
                  }
                },
              )
          )
      ),
    );
  }
}



