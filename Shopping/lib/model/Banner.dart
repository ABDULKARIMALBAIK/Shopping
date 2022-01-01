class Banner {
  var bannerImgId;
  var bannerImgUrl;
  var categoryId;
  var bannerText;

  Banner(
      {this.bannerImgId, this.bannerImgUrl, this.categoryId, this.bannerText});

  Banner.fromJson(Map<String, dynamic> json) {
    bannerImgId = json['bannerImgId'];
    bannerImgUrl = json['bannerImgUrl'];
    categoryId = json['categoryId'];
    bannerText = json['bannerText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bannerImgId'] = this.bannerImgId;
    data['bannerImgUrl'] = this.bannerImgUrl;
    data['categoryId'] = this.categoryId;
    data['bannerText'] = this.bannerText;
    return data;
  }
}
