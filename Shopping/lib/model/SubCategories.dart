class SubCategories {
  var subCategoryId;
  String subCategoryName = '';
  var categoryId;

  SubCategories({this.subCategoryId, this.subCategoryName = '', this.categoryId});

  SubCategories.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['subCategoryId'];
    subCategoryName = json['subCategoryName'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subCategoryId'] = this.subCategoryId;
    data['subCategoryName'] = this.subCategoryName;
    data['categoryId'] = this.categoryId;
    return data;
  }
}