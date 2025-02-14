class Products {
  int? productNo;
  String? productName;
  String? productDetails;
  String? productImageUrl;
  int? price;

  Products({
    this.productNo,
    this.productName,
    this.productDetails,
    this.productImageUrl,
    this.price
  });

  Products.fromJson(Map<String, dynamic> json) {
    productNo = int.parse(json['productNo']);
    productName = json['productNo'];
    productDetails = json['productDetails'];
    productImageUrl = json['productImageUrl'];
    price = int.parse(json['price']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['productNo'] = productNo;
    data['productName'] = productName;
    data['productDetails'] = productDetails;
    data['productImageUrl'] = productImageUrl;
    data['price'] = price;
    return data;
  }
}