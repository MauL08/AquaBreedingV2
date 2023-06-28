class DetailInventarisAssetModel {
  String? status;
  Data? data;

  DetailInventarisAssetModel({this.status, this.data});

  DetailInventarisAssetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  int? idInt;
  String? assetCategory;
  String? name;
  String? description;
  int? amount;
  int? price;
  String? image;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.sId,
      this.idInt,
      this.assetCategory,
      this.name,
      this.description,
      this.amount,
      this.price,
      this.image,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    idInt = json['id_int'];
    assetCategory = json['asset_category'];
    name = json['name'];
    description = json['description'];
    amount = json['amount'];
    price = json['price'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id_int'] = this.idInt;
    data['asset_category'] = this.assetCategory;
    data['name'] = this.name;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['price'] = this.price;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
