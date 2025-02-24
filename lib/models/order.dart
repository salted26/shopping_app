class Order {
  int? orderId;
  int? productNo;
  String? orderDate;
  String? orderNo;
  int? quantity;
  double? unitPrice;
  double? totalPrice;
  String? paymentStatus;
  String? deliveryStatus;


  Order({
    this.orderId,
    this.productNo,
    this.orderDate,
    this.orderNo,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.paymentStatus,
    this.deliveryStatus
  });

  Order.fromJson(Map<String, dynamic> json) {
    orderId = int.parse(json['orderId']);
    productNo = int.parse(json['productNo']);
    orderDate = json['orderDate'];
    orderNo = json['orderNo'];
    quantity = int.parse(json['quantity']);
    unitPrice = json['unitPrice'];
    totalPrice = json['totalPrice'];
    paymentStatus = json['paymentStatus'];
    deliveryStatus = json['deliveryStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['orderId'] = productNo;
    data['productNo'] = productNo;
    data['orderDate'] = orderDate;
    data['orderNo'] = orderNo;
    data['quantity'] = quantity;
    data['totalPrice'] = totalPrice;
    data['paymentStatus'] = paymentStatus;
    data['deliveryStatus'] = deliveryStatus;
    return data;
  }


}