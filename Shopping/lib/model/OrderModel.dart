import 'dart:convert';
import 'dart:io';

import 'package:flutter_shopping_app/floor/entity/CartProduct.dart';

class OrderModel{
  late String uid,orderName,orderPhone,orderAddress,orderTransactionId;
  List<Cart> orderDetails = <Cart>[];
  late int orderStatus,orderNumber;
  late String orderDate;
  late double orderAmount;


  OrderModel({
      required this.uid,
      required this.orderName,
      required this.orderPhone,
      required this.orderAddress,
      required this.orderTransactionId,
      required this.orderDetails,
      required this.orderStatus,
      required this.orderDate,
      required this.orderNumber,
      required this.orderAmount});

  OrderModel.fromJson(Map<String,dynamic> jsonString){
    uid = jsonString['uid'];
    orderName = jsonString['orderName'];
    orderPhone = jsonString['orderPhone'];
    orderAddress = jsonString['orderAddress'];
    orderTransactionId = jsonString['orderTransactionId'];
    //Start Fix Parse
    if(jsonString['orderDetails'] != null){
      orderDetails = <Cart>[];
      jsonString['orderDetails'].forEach((v){
        orderDetails.add(Cart.fromJson(v));
      });
    }

    orderStatus = jsonString['orderStatus'];
    orderDate = jsonString['orderDate'];
    //End Fix Parse
    orderAmount = jsonString['orderAmount'];
    orderNumber = jsonString['orderNumber'];
  }

  Map<String,dynamic> toJson(){
    final  Map<String,dynamic> data = new  Map<String,dynamic>();
    data['uid'] = this.uid;
    data['orderName'] = this.orderName;
    data['orderPhone'] = this.orderPhone;
    data['orderAddress'] = this.orderAddress;
    data['orderTransactionId'] = this.orderTransactionId;
    data['orderDetails'] = this.orderDetails;
    data['orderStatus'] = this.orderStatus ;
    data['orderDate'] = this.orderDate;
    data['orderAmount'] = this.orderAmount;
    data['orderNumber'] = this.orderNumber;
    return data;

  }
}