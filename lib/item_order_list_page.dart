import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants.dart';
import 'package:shopping_app/enum/delivery_status.dart';
import 'package:shopping_app/enum/payment_status.dart';
import 'package:shopping_app/item_basket_page.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/models/productOrder.dart';

class MyOrderListPage extends StatefulWidget {
  const MyOrderListPage({super.key});

  @override
  State<MyOrderListPage> createState() => _MyOrderListPageState();
}

class _MyOrderListPageState extends State<MyOrderListPage> {
  // 먼저 주문 데이터를 가져옵니다.
  final orderListRef = FirebaseFirestore.instance
      .collection("orders")
      .withConverter(
        fromFirestore: (snapshot, _) => ProductOrder.fromJson(snapshot.data()!),
        toFirestore: (products, _) => products.toJson(),
      );

  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("나의 주문목록"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
            ),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const MyOrderListPage();
                  }
              ));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const ItemBasketPage();
                  }
              ));
            },
          )
        ],
      ),
      body: StreamBuilder(
        //! 주문 번호를 기준으로 내림차순 정렬
        stream: orderListRef.orderBy("orderNo", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.docs.map((document) {
                //! 제품 상세 정보를 가져오기 위해 제품 번호를 기준으로 쿼리해서 가져옵니다.
                final productDetailsRef = FirebaseFirestore.instance
                    .collection("products")
                    .withConverter(
                    fromFirestore: (snapshot, _) =>
                        Products.fromJson(snapshot.data()!),
                    toFirestore: (product, _) => product.toJson())
                    .where("productNo", isEqualTo: document.data().productNo);
                return StreamBuilder(
                  stream: productDetailsRef.snapshots(),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.hasData) {
                      //! 제품 상세 정보를 가져온 후, orderContainer에 데이터를 전달합니다.
                      Products product = productSnapshot.data!.docs.first.data();
                      return orderContainer(
                        productNo: document.data().productNo ?? 0,
                        productName: product.productName ?? "",
                        productImageUrl: product.productImageUrl ?? "",
                        price: document.data().unitPrice ?? 0,
                        quantity: document.data().quantity ?? 0,
                        orderDate: document.data().orderDate ?? "",
                        orderNo: document.data().orderNo ?? "",
                        paymentStatus: document.data().paymentStatus ?? "",
                        deliveryStatus: document.data().deliveryStatus ?? "",
                      );
                    } else if (productSnapshot.hasError) {
                      return const Center(
                        child: Text("오류가 발생 했습니다."),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("오류가 발생 했습니다."),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("홈으로"),
        ),
      ),
    );
  }

  Widget orderContainer({
    required int productNo,
    required String productName,
    required String productImageUrl,
    required double price,
    required int quantity,
    required String orderDate,
    required String orderNo,
    required String paymentStatus,
    required String deliveryStatus
  }){
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              "주문날짜: $orderDate",
              style: const TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: productImageUrl,
                width: MediaQuery.of(context).size.width * 0.3,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return const Center(
                    child: Text("오류 발생"),
                  );
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("${numberFormat.format(price)}원"),
                    Text("수량 : $quantity"),
                    Text("합계 : ${numberFormat.format(price * quantity)}원"),
                    Text(
                      "${PaymentStatus.getStatusName(paymentStatus).statusName} / ${DeliveryStatus.getStateName(deliveryStatus).statusName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FilledButton(
                onPressed: (){}, 
                child: const Text("주문취소")
              ),
              const SizedBox(width: 10),
              FilledButton(
                  onPressed: (){},
                  child: const Text("배송조회")
              )
            ],
          )
        ],
      ),
    );
  }
}