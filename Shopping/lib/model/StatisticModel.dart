class StatisticModel {

  late double total;
  late List<Detail> detail;

  StatisticModel(this.total, this.detail);



  StatisticModel.fromJson(Map<String, dynamic> json) {

    total = double.parse(json['total'].toString());
    if (json['detail'] != null) {
      detail =  <Detail>[];
      json['detail'].forEach((v) {
        detail.add(new Detail.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.detail != null) {
      data['detail'] =
          this.detail.map((v) => v.toJson()).toList();
    }
    return data;
  }

}


class Detail {

  late String date;
  late int num;

  Detail(this.date, this.num);


  Detail.fromJson(Map<String, dynamic> json) {

    date = json['date'];
    num = json['num'];
  }


  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['num'] = this.num;

    return data;
  }

}