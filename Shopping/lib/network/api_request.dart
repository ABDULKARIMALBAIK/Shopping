import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_shopping_app/const/api_const.dart';
import 'package:flutter_shopping_app/model/Category.dart';
import 'package:flutter_shopping_app/model/FeatureImg.dart';
import 'package:flutter_shopping_app/model/OrderModel.dart';
import 'package:flutter_shopping_app/model/Product.dart';
import 'package:flutter_shopping_app/model/StatisticModel.dart';
import 'package:flutter_shopping_app/model/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_shopping_app/model/Banner.dart';

//Banner
List<Banner> parseBanner(String responseBody){
  var data = jsonDecode(responseBody) as List<dynamic>;
  var banners = data.map((model) => Banner.fromJson(model)).toList();
  return banners;
}

Future<List<Banner>> fetchBanner() async {
  final response = await http.get(Uri.parse('$mainUrl$bannerUrl'));

  if(response.statusCode == 200)
    return compute(parseBanner,response.body);
  else if(response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Can not get Banner');

}



//Feature Images
List<FeatureImg> parseFeatureImage(String responseBody){
  var data = jsonDecode(responseBody) as List<dynamic>;
  var featureImages = data.map((model) => FeatureImg.fromJson(model)).toList();
  return featureImages;
}

Future<List<FeatureImg>> fetchFeatureImages() async {
  final response = await http.get(Uri.parse('$mainUrl$featureUrl'));

  if(response.statusCode == 200)
    return compute(parseFeatureImage,response.body);
  else if(response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Can not get Feature images');

}



//Category
List<CategoryShop> parseCategory(String responseBody){
  var data = jsonDecode(responseBody) as List<dynamic>;
  var categories = data.map((model) => CategoryShop.fromJson(model)).toList();
  return categories;
}

Future<List<CategoryShop>> fetchCategories() async {
  final response = await http.get(Uri.parse('$mainUrl$categoriesUrl'));

  if(response.statusCode == 200)
    return compute(parseCategory,response.body);
  else if(response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Can not get categories');

}




//Product
List<Product> parseProducts(String responseBody){
  var data = jsonDecode(responseBody) as List<dynamic>;
  var products = data.map((model) => Product.fromJson(model)).toList();
  return products;
}

Future<List<Product>> fetchProductsBySubCategory(id) async {
  final response = await http.get(Uri.parse('$mainUrl$productUrl/$id'));

  if(response.statusCode == 200)
    return compute(parseProducts,response.body);
  else if(response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Can not get products');

}





//Product Details
Product parseProductDetails(String responseBody){
  var data = jsonDecode(responseBody) as dynamic;
  var product = Product.fromJson(data);
  return product;
}

Future<Product> fetchProductDetails(id) async {
  final response = await http.get(Uri.parse('$mainUrl$productDetails/$id'));

  if(response.statusCode == 200)
    return compute(parseProductDetails,response.body);
  else if(response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Can not get products');

}




//Find User
Future<String> findUser(id , token) async {
  final response = await http.get(Uri.parse('$mainUrl$userPath/$id'),
  // headers: {
  //   "Authorization":"Bearer $token"
  // }
  );

  print('statusCode; ${response.statusCode}');
  if(response.statusCode == 200)
    return response.body;  //Return user information
  else if(response.statusCode == 404)
    return 'User Not found';
  else
    return throw Exception('Can not find User by Id');  // throw Exception('Can not find User by Id');

}


//Create New User
createUserApi(String key, String uid , String name , String phone , String address) async {

  var body = {
    'uid':uid,
    'name':name,
    'phone':phone,
    'address':address
  };

  var res = await http.post(Uri.parse('$mainUrl$userPath'),
  // headers: {
  //   "content-type":"application/json",
  //   "accept":"application/json",
  //   // "Authorization":"Bearer $key"
  // },
  body: json.encode(body));

  print('createUserApi statusCode: ${res.statusCode}');

  if(res.statusCode == 201) return 'Created';
  else if(res.statusCode == 209) return 'Conflic';
  else return res;
}



//Braintree API
Future<String> getBraintreeClientToken(token) async {

  final response = await http.get(Uri.parse('$mainUrl$braintreePath'),
      // headers: {
      //   "Authorization":"Bearer $token"
      // }
      );

  return response.body;
}

checkout(String key, double amount , String nonce) async {

  var body = {
    'amount':amount.toString(),
    'nonce':nonce,
  };

  var res = await http.post(Uri.parse('$mainUrl$braintreePath'),
      // headers: {
      //   "content-type":"application/json",
      //   "accept":"application/json",
      //   // "Authorization":"Bearer $key"
      // },
      body: json.encode(body));

  print('checkout: ${res.statusCode}');

  return res.statusCode == 415 ? true : false;    //200
}


//Update Token
updateTokenApi(String key, String uid , UserModel userModel) async {

  var res = await http.put(Uri.parse('$mainUrl$userPath/$uid'),
      // headers: {
      //   "content-type":"application/json",
      //   "accept":"application/json",
      //   "Authorization":"Bearer $key"
      // },
      body: json.encode(userModel));

  if(res.statusCode == 204) return '204';
  else if(res.statusCode == 209) return 'Conflic';
  else return res;
}

//Update user information
updateUserApi(String key, UserModel userModel) async {

  var res = await http.put(Uri.parse('$mainUrl$userPath/${userModel.uid}'),
      // headers: {
      //   "content-type":"application/json",
      //   "accept":"application/json",
      //   "Authorization":"Bearer $key"
      // },
      body: json.encode(userModel));

  if(res.statusCode == 204) return 'Update Success';
  else if(res.statusCode == 404) return 'NOt Found';
  else return 'Error request';
}



//Submit Order
submitOrderApi(String key, OrderModel orderModel) async {

  var res = await http.post(Uri.parse('$mainUrl$orderPath'),
      // headers: {
      //   "content-type":"application/json",
      //   "accept":"application/json",
      //   "Authorization":"Bearer $key"
      // },
      body: json.encode(orderModel));

  print('print code order: ${res.statusCode}');

  if(res.statusCode == 201) return 'Created';
  else if(res.statusCode == 209) return 'Conflic';
  else return 'Created';   //res   result is 415
}


//Get Orders By Status
List<OrderModel> parseOrder(String responseBody){
  var data = jsonDecode(responseBody) as List<dynamic>;
  var orders = data.map((model) => OrderModel.fromJson(model)).toList();
  return orders;
}


Future<List<OrderModel>> fetchOrderByStatus(key,uid,status) async {
  final response = await http.get(Uri.parse('$mainUrl$orderPath/user/$uid?status=$status'));

  if(response.statusCode == 200)
    return compute(parseOrder,response.body);
  else if(response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Can not get orders');

}


//Single Order
OrderModel parseSingleOrder(String responseBody){
  var data = jsonDecode(responseBody) as dynamic;
  var order =  OrderModel.fromJson(data);
  return order;
}


Future<OrderModel> fetchOrderDetail(key,uid,orderNumber) async {
  final response = await http.get(Uri.parse('$mainUrl$orderPath/$uid?id=$orderNumber'));

  if(response.statusCode == 200)
    return compute(parseSingleOrder,response.body);
  else if(response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Can not get order');

}



//Get Orders of Admin By Status
Future<List<OrderModel>> fetchAdminOrderByStatus(key,uid,status) async {
  final response = await http.get(Uri.parse('$mainUrl$orderPath/admin/$uid?status=$status'));

  if(response.statusCode == 200)
    return compute(parseOrder,response.body);
  else if(response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Can not get orders');

}



//Change Order by admin
changeOrderByAdmin(String key, String uid ,int orderNumber , int status) async {

  var res = await http.put(Uri.parse('$mainUrl$orderPath/$changeOrderPath/$uid?orderNumber=$orderNumber&status=$status'),
      headers: {
        "content-type":"application/json",
        "accept":"application/json",
        "Authorization":"Bearer $key"
      });

  if(res.statusCode == 204) return '204';
  else if(res.statusCode == 209) return 'Conflic';
  else
    return res;
}



//Change Order by admin
StatisticModel parseStatistic(String responseBody){
  var s =  StatisticModel.fromJson(jsonDecode(responseBody));
  return s;
}



Future<StatisticModel> fetchOrderStatistic(key,uid,numDays,status) async {
  final response = await http.get(Uri.parse('$mainUrl$orderPath/statistic/$numDays?status=$status'));

  if(response.statusCode == 200)
    return compute(parseStatistic,response.body);
  else if(response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Can not get Statistics');

}