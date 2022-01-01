import 'SubCategories.dart';

class CategoryShop {
  var categoryId;
  var categoryName;
  var categoryImg;
  var subCategories;  //List<SubCategories>

  CategoryShop(
      {this.categoryId,
        this.categoryName,
        this.categoryImg,
        this.subCategories});

  CategoryShop.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    categoryImg = json['categoryImg'];
    if (json['subCategories'] != null) {
      subCategories = <SubCategories>[];
      json['subCategories'].forEach((v) {
        subCategories.add(new SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['categoryImg'] = this.categoryImg;
    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}