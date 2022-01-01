import 'ProductImages.dart';
import 'ProductSizes.dart';

class Product {
  int productId = 0;
  var productName;
  var productShortDescription;
  var productDescription;
  var productOldPrice;
  var productNewPrice;
  var productIsSale;
  var productSaleText;
  var productSubText;
  var productOrderNumber;
  var productCreateDate;
  var productCode;
  var subCategoryId;
  // var productColours;
  // var productFabrics;
  List<ProductImages> productImages = [];
  // var productJacketModels;
  // var productPatterns;
  List<ProductSizes> productSizes = [];

  Product(
      { required this.productId,
        this.productName,
        this.productShortDescription,
        this.productDescription,
        this.productOldPrice,
        this.productNewPrice,
        this.productIsSale,
        this.productSaleText,
        this.productSubText,
        this.productOrderNumber,
        this.productCreateDate,
        this.productCode,
        this.subCategoryId,
        // this.productColours,
        // this.productFabrics,
        required this.productImages,
        // this.productJacketModels,
        // this.productPatterns,
        required this.productSizes
      });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'] as int;
    productName = json['productName'];
    productShortDescription = json['productShortDescription'];
    productDescription = json['productDescription'];
    productOldPrice = json['productOldPrice'] as double;
    productNewPrice = json['productNewPrice'] as double;
    productIsSale = json['productIsSale'];
    productSaleText = json['productSaleText'];
    productSubText = json['productSubText'];
    productOrderNumber = json['productOrderNumber'] as int;
    productCreateDate = json['productCreateDate'];
    productCode = json['productCode'];
    subCategoryId = json['subCategoryId'] as int;
    // if (json['productColours'] != null) {
    //   productColours = <Null>[];
    //   json['productColours'].forEach((v) {
    //     //productColours.add(new Null.fromJson(v));/////////////////////////////////////////////
    //   });
    // }
    // if (json['productFabrics'] != null) {
    //   productFabrics =  <Null>[];
    //   json['productFabrics'].forEach((v) {
    //     // productFabrics.add(new Null.fromJson(v));/////////////////////////////////////////////
    //   });
    // }
    if (json['productImages'] != null) {
      productImages =  <ProductImages>[];
      json['productImages'].forEach((v) {
        productImages.add(new ProductImages.fromJson(v));
      });
    }
    // if (json['productJacketModels'] != null) {
    //   productJacketModels =  <Null>[];
    //   json['productJacketModels'].forEach((v) {
    //     // productJacketModels.add(new Null.fromJson(v));/////////////////////////////////////////////
    //   });
    // }
    // if (json['productPatterns'] != null) {
    //   productPatterns =  <Null>[];
    //   json['productPatterns'].forEach((v) {
    //     //productPatterns.add(new Null.fromJson(v));/////////////////////////////////////////////
    //   });
    // }
    if (json['productSizes'] != null) {
      productSizes =  <ProductSizes>[];
      json['productSizes'].forEach((v) {
        productSizes.add(new ProductSizes.fromJson(v));/////////////////////////////////////////////
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productShortDescription'] = this.productShortDescription;
    data['productDescription'] = this.productDescription;
    data['productOldPrice'] = this.productOldPrice;
    data['productNewPrice'] = this.productNewPrice;
    data['productIsSale'] = this.productIsSale;
    data['productSaleText'] = this.productSaleText;
    data['productSubText'] = this.productSubText;
    data['productOrderNumber'] = this.productOrderNumber;
    data['productCreateDate'] = this.productCreateDate;
    data['productCode'] = this.productCode;
    data['subCategoryId'] = this.subCategoryId;
    // if (this.productColours != null) {
    //   data['productColours'] =
    //       this.productColours.map((v) => v.toJson()).toList();
    // }
    // if (this.productFabrics != null) {
    //   data['productFabrics'] =
    //       this.productFabrics.map((v) => v.toJson()).toList();
    // }
    if (this.productImages != null) {
      data['productImages'] =
          this.productImages.map((v) => v.toJson()).toList();
    }
    // if (this.productJacketModels != null) {
    //   data['productJacketModels'] =
    //       this.productJacketModels.map((v) => v.toJson()).toList();
    // }
    // if (this.productPatterns != null) {
    //   data['productPatterns'] =
    //       this.productPatterns.map((v) => v.toJson()).toList();
    // }
    if (this.productSizes != null) {
      data['productSizes'] = this.productSizes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}