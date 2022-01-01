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

class OrderHistoryScreen extends ConsumerWidget {


  @override
  Widget build(BuildContext context, ScopedReader watch) {

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return DefaultTabController(
      length: 3,
      child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: Center(child: Text('Order History'),),
                backgroundColor: Color(0xFF0C1B37),
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back , color: Colors.white,),
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(child: Text('Placed'),),
                    Tab(child: Text('Delivery'),),
                    Tab(child: Text('Cancelled'),),
                  ],
                ),
              ),
              key: _scaffoldKey,
              resizeToAvoidBottomInset: true,
              backgroundColor: Color(0xFF0C1B37),
              body: TabBarView(
                children: [
                  _orderPlaceWidget(context,0),
                  _orderPlaceWidget(context,1),
                  _orderPlaceWidget(context,2),
                ],
              )
          )
      ),
    );
  }

  _orderPlaceWidget(BuildContext context, int status) {

    return FutureBuilder(
        future: fetchOrderByStatus(
            context.read(userToken).state,
            FirebaseAuth.instance.currentUser!.uid,
            status),

        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else {

            var orders = snapshot.data as List<OrderModel>;
            if(orders == null || orders.length == 0)
              return Center(child: Text('You have 0 order',style: GoogleFonts.montserrat(color: Colors.white,fontSize: 16),
              ),);

            else {
              return ListView.builder(
                  itemCount: orders.length, 
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: (){
                        //When user click to order -> order detail
                        context.read(selectedOrder).state = orders[index];
                        Navigator.of(context).pushNamed('orderDetail');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Card(
                          child: Padding(padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${orders[index].orderName}', style: GoogleFonts.montserrat(fontSize: 20),),
                              SizedBox(height: 8,),
                              Text('Order Time: ${orders[index].orderDate.toString().substring(0,orders[index].orderDate.toString().lastIndexOf(':'))}', style: GoogleFonts.montserrat(),),
                              Divider(thickness: 2,),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Order Id', style: GoogleFonts.montserrat(color: Colors.grey),),
                                        SizedBox(height: 8,),
                                        Text('#${orders[index].orderNumber.toString().padLeft(6,'0')}', style: GoogleFonts.montserrat(color: Colors.black),),
                                      ],
                                    ),
                                    VerticalDivider(thickness: 1,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Order Amount', style: GoogleFonts.montserrat(color: Colors.grey),),
                                        SizedBox(height: 8,),
                                        Text('\$${orders[index].orderAmount}', style: GoogleFonts.montserrat(color: Colors.black),),
                                      ],
                                    ),
                                    VerticalDivider(thickness: 1,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Payment', style: GoogleFonts.montserrat(color: Colors.grey),),
                                        SizedBox(height: 8,),
                                        Text('Credit Card/Paypal', style: GoogleFonts.montserrat(color: Colors.black , fontSize: 12),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(thickness: 2,),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,color: Color(0xFF0C1B37),),
                                  SizedBox(width: 10,),
                                  Text('${orders[index].orderAddress}', style: GoogleFonts.montserrat(fontSize: 14),),

                                ],
                              )
                            ],
                          ),),
                        ),
                      ),
                    );
                  });
            }
          }
        });

  }
}



