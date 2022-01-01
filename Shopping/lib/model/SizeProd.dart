class SizeProd {
  var sizeId;
  String sizeName = '';
  var productSizes;

  SizeProd({this.sizeId, this.sizeName = '', this.productSizes});

  SizeProd.fromJson(Map<String, dynamic> json) {
    sizeId = json['sizeId'];
    sizeName = json['sizeName'];
    // if (json['productSizes'] != null) {
    //   productSizes = new List<Null>();
    //   json['productSizes'].forEach((v) {
    //     productSizes.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sizeId'] = this.sizeId;
    data['sizeName'] = this.sizeName;
    // if (this.productSizes != null) {
    //   data['productSizes'] = this.productSizes.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}