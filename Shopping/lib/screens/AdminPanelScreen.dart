import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_shopping_app/const/ScreenConst.dart';
import 'package:flutter_shopping_app/model/OrderModel.dart';
import 'package:flutter_shopping_app/model/StatisticModel.dart';
import 'package:flutter_shopping_app/network/api_request.dart';
import 'package:flutter_shopping_app/state/StateManagement.dart';
import 'package:flutter_shopping_app/widgets/MonthlyChart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class AdminPanelScreen extends ConsumerWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final currentMenu = watch(adminNavigationMenu).state;

    return DefaultTabController(
      length: currentMenu == AdminScreen.HOME ? 2 : 3,
      child: SafeArea(
          child: Scaffold(
              drawer: _drawerWidget(context),
              appBar: AppBar(
                  actions: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.navigate_next, color: Colors.white,),
                    ),
                  ],
                  title: Center(child: Text('Admin page'),),
                  backgroundColor: Color(0xFF0C1B37),
                  bottom: currentMenu == AdminScreen.HOME
                      ? homeTabs(context)
                      : orderManagementTabs()
              ),
              key: _scaffoldKey,
              resizeToAvoidBottomInset: true,
              backgroundColor: Color(0xFF0C1B37),
              body: currentMenu == AdminScreen.HOME
                  ? homeScreen(context)
                  : orderManagementScreen(context)
          )
      ),
    );
  }

  _orderPlaceWidget(BuildContext context, int status) {
    return Consumer(builder: (context, watch, _) {
      var watchOrder = watch(orderChange).state; //Watch to refresh when change
      return FutureBuilder(
          future: fetchAdminOrderByStatus(
              context
                  .read(userToken)
                  .state,
              FirebaseAuth.instance.currentUser!.uid,
              status),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator(),);
            else {
              var orders = snapshot.data as List<OrderModel>;
              if (orders == null || orders.length == 0)
                return Center(child: Text('You have 0 order',
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontSize: 16),
                ),);

              else {
                return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          //When user click to order -> order detail
                          context
                              .read(selectedOrder)
                              .state = orders[index];
                          Navigator.of(context).pushNamed('orderDetail');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Card(
                            child: Padding(padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${orders[index].orderName}',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 20),),

                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          var thisOrderStatus = orders[index]
                                              .orderStatus;
                                          Alert(
                                              context: context,
                                              type: AlertType.info,
                                              title: 'UPDATE ORDER',
                                              content: Column(
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () =>
                                                      thisOrderStatus == 0
                                                          ? null
                                                          : () =>
                                                          updateOrderByAdmin(
                                                              context,
                                                              orders[index], 0),
                                                      //this disable button if order status already is placed
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                          primary: Colors
                                                              .indigo,
                                                          onPrimary: Colors
                                                              .white),
                                                      child: Text('Placed')),
                                                  ElevatedButton(
                                                      onPressed: () =>
                                                      thisOrderStatus == 0
                                                          ? null
                                                          : () =>
                                                          updateOrderByAdmin(
                                                              context,
                                                              orders[index], 1),
                                                      //this disable button if order status already is shipped
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                          primary: Colors.green,
                                                          onPrimary: Colors
                                                              .white),
                                                      child: Text('Shopped')),
                                                  ElevatedButton(
                                                      onPressed: () =>
                                                      thisOrderStatus == 0
                                                          ? null
                                                          : () =>
                                                          updateOrderByAdmin(
                                                              context,
                                                              orders[index], 2),
                                                      //this disable button if order status already is cancelled
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                          primary: Colors.red,
                                                          onPrimary: Colors
                                                              .white),
                                                      child: Text('Cancelled')),
                                                ],
                                              ),
                                              buttons: [
                                                DialogButton(child: Text(
                                                  'CLOSE', style: TextStyle(
                                                    color: Colors.red),),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    })
                                              ]
                                          ).show();
                                        },
                                        child: Icon(Icons.more_vert,),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Text('Order Time: ${orders[index].orderDate
                                      .toString().substring(0,
                                      orders[index].orderDate.toString()
                                          .lastIndexOf(':'))}',
                                    style: GoogleFonts.montserrat(),),
                                  Divider(thickness: 2,),
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            Text('Order Id',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.grey),),
                                            SizedBox(height: 8,),
                                            Text('#${orders[index].orderNumber
                                                .toString().padLeft(6, '0')}',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black),),
                                          ],
                                        ),
                                        VerticalDivider(thickness: 1,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            Text('Order Amount',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.grey),),
                                            SizedBox(height: 8,),
                                            Text(
                                              '\$${orders[index].orderAmount}',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black),),
                                          ],
                                        ),
                                        VerticalDivider(thickness: 1,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            Text('Payment',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.grey),),
                                            SizedBox(height: 8,),
                                            Text('Credit Card/Paypal',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontSize: 12),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(thickness: 2,),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                        color: Color(0xFF0C1B37),),
                                      SizedBox(width: 10,),
                                      Text('${orders[index].orderAddress}',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14),),

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
    });
  }


  _drawerWidget(BuildContext context) {
    return ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      //When user click to menu, change screen
                      if (index == 0) { //Home
                        context
                            .read(adminNavigationMenu)
                            .state = AdminScreen.HOME;
                        Navigator.pop(context);
                      }
                      else {
                        context
                            .read(adminNavigationMenu)
                            .state = AdminScreen.ORDER_MANAGEMENT;
                        Navigator.pop(context);
                      }
                    },
                    child: ListTile(
                      leading: Icon(index == 0 ? Icons.home : Icons.list_alt,
                        color: Colors.black54,),
                      title: Text(index == 0 ? 'Home' : 'Orders'),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  updateOrderByAdmin(BuildContext context, OrderModel orderModel,
      int status) async {
    var result = await changeOrderByAdmin(
        context
            .read(userToken)
            .state,
        context
            .read(userLoggedInfo)
            .state
            .uid,
        orderModel.orderNumber,
        status);
    if (result == '204') {
      orderModel.orderStatus = status;
      context
          .read(orderChange)
          .state = orderModel;
    }
    Navigator.pop(context);
  }

  orderManagementTabs() {
    return TabBar(
      tabs: [
        Tab(child: Text('Placed'),),
        Tab(child: Text('Delivery'),),
        Tab(child: Text('Cancelled'),),
      ],
    );
  }

  homeTabs(BuildContext context) {
    return TabBar(
      tabs: [
        Tab(child: Text('Delivery'),),
        Tab(child: Text('Cancelled'),),
      ],
    );
  }

  orderManagementScreen(BuildContext context) {
    return TabBarView(
      children: [
        _orderPlaceWidget(context, 0),
        _orderPlaceWidget(context, 1),
        _orderPlaceWidget(context, 2),
      ],
    );
  }

  homeScreen(BuildContext context) {
    return TabBarView(
      children: [
        displayChart(context, 1),
        displayChart(context, 2),
      ],
    );
  }

  displayChart(BuildContext context, int status) {
    return Consumer(builder: (context, watch, _) {
      var dataWatch = watch(dataLoadState).state;
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.read(dataLoadState).state = 1,
                  child: Chip(
                    label: Text('Today'),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.read(dataLoadState).state = 7,
                  child: Chip(
                    label: Text('7 Days'),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.read(dataLoadState).state = 30,
                  child: Chip(
                    label: Text('30 Days'),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.read(dataLoadState).state = 45,
                  child: Chip(
                    label: Text('45 Days'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder(
                future: fetchOrderStatistic(
                  context.read(userToken).state,
                  context.read(userLoggedInfo).state.uid,
                  dataWatch,
                  status
                ),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(),);
                  else {
                    var statisticData = snapshot.data as StatisticModel;
                    return Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8 , horizontal: 16),
                            child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Total',style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 14),),

                                  ],
                                ),
                                Text(status == 1 ? '\$${statisticData.total}' : '-\$${statisticData.total}',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 38,
                                      color: status == 1 ? Colors.green : Colors.red),),

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                              margin: EdgeInsets.all(4),
                              padding: EdgeInsets.all(12),
                              color: Colors.white,
                              child: Center(
                                child: MonthlyChart(
                                  statisticData.detail,
                                  true,
                                  status == 1 ? charts.MaterialPalette.blue.shadeDefault : charts.MaterialPalette.red.shadeDefault
                                ),
                              ),
                            )
                        )
                      ],
                    );
                  }
                },
              )
          )
        ],
      );
    });
  }

}