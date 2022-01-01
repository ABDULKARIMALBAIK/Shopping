

import 'package:floor/floor.dart';

@Entity(primaryKeys: ['productId','uid','size'])
class Cart{

  @primaryKey
  late int productId;
  late String uid,name,imgUrl,size,code;
  late double price;
  late int quantity;

  Cart(this.productId, this.uid, this.name, this.imgUrl, this.size, this.code,
      this.price, this.quantity);

  Cart.fromJson(Map<String,dynamic> jsonString){
    productId = jsonString['productId'];
    uid = jsonString['uid'];
    name = jsonString['name'];
    imgUrl = jsonString['imgUrl'];
    size = jsonString['size'];
    code = jsonString['code'];
    price = jsonString['price'];
    quantity = jsonString['quantity'];
  }


  Map<String,dynamic> toJson(){
    final  Map<String,dynamic> data = new  Map<String,dynamic>();
    data['productId'] = this.productId;
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['imgUrl'] = this.imgUrl;
    data['size'] = this.size;
    data['code'] = this.code;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    return data;
  }

}