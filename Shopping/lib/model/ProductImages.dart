class ProductImages {
  var imgId;
  var imgUrl;
  var productId;

  ProductImages({this.imgId, this.imgUrl, this.productId});

  ProductImages.fromJson(Map<String, dynamic> json) {
    imgId = json['imgId'];
    imgUrl = json['imgUrl'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgId'] = this.imgId;
    data['imgUrl'] = this.imgUrl;
    data['productId'] = this.productId;
    return data;
  }
}