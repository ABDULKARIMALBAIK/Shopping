import 'package:flutter_shopping_app/model/SizeProd.dart';

class ProductSizes {
  var sizeId;
  var productId;
  var number;
  SizeProd size = SizeProd();

  ProductSizes({this.sizeId, this.productId, this.number, required this.size});

  ProductSizes.fromJson(Map<String, dynamic> json) {
    sizeId = json['sizeId'];
    productId = json['productId'];
    number = json['number'];
    size = (json['size'] != null ? new SizeProd.fromJson(json['size']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sizeId'] = this.sizeId;
    data['productId'] = this.productId;
    data['number'] = this.number;
    if (this.size != null) {
      data['size'] = this.size.toJson();
    }
    return data;
  }
}