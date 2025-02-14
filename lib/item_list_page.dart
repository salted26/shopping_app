import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/item_details_page.dart';
import 'package:shopping_app/models/product.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  // 금액 표시를 위해 3자리로 끊어서 표기
  final NumberFormat numberFormat = NumberFormat('###,###,###,###');

  List<Products> productList = [
    Products(
        productNo: 1,
        productName: "노트북(Laptop)",
        productImageUrl: "https://picsum.photos/id/1/300/300",
        price: 600000),
    Products(
        productNo: 2,
        productName: "스마트폰(Phone)",
        productImageUrl: "https://picsum.photos/id/20/300/300",
        price: 500000),
    Products(
        productNo: 3,
        productName: "머그컵(Cup)",
        productImageUrl: "https://picsum.photos/id/30/300/300",
        price: 15000),
    Products(
        productNo: 4,
        productName: "키보드(Keyboard)",
        productImageUrl: "https://picsum.photos/id/60/300/300",
        price: 50000),
    Products(
        productNo: 5,
        productName: "포도(Grape)",
        productImageUrl: "https://picsum.photos/id/75/200/300",
        price: 75000),
    Products(
        productNo: 6,
        productName: "책(book)",
        productImageUrl: "https://picsum.photos/id/24/200/300",
        price: 24000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("제품 리스트"),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: productList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount (
          childAspectRatio: 0.9,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return productContainer(
            productNo: productList[index].productNo ?? 0,
            productName: productList[index].productName ?? "",
            productImageUrl: productList[index].productImageUrl ?? "",
            price: productList[index].price ?? 0,
          );
        },
      ),
    );
  }

  Widget productContainer({
      required int productNo,
      required String productName,
      required String productImageUrl,
      required int price,
    })
  {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return ItemDetailPage(
                productNo: productNo,
                productName: productName,
                productImageUrl: productImageUrl,
                price: price,
              );
            }
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            CachedNetworkImage(
              height: 150,
              fit: BoxFit.cover,
              imageUrl:productImageUrl,
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
              padding: const EdgeInsets.all(8),
              child: Text("${numberFormat.format(price)}원"),
            )
          ],
        ),
      ),
    );
  }
}

