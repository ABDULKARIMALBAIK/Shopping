class UserModel{
  var uid,name,phone,token,address,role;
  var credit;

  UserModel(this.uid, this.name, this.phone, this.token, this.credit);


  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    phone = json['phone'];
    token = json['token'];
    credit = json['credit'];
    address = json['address'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['token'] = this.token;
    data['credit'] = this.credit;
    data['address'] = this.address;
    data['role'] = this.role;

    return data;
  }

}