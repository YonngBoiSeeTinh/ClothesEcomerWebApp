import 'package:GOSY/Page/ProductDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';


class ItemWidget extends StatefulWidget {
   final List<dynamic> products ;
  const ItemWidget({super.key, required this.products});
  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  
   @override
  Widget build(BuildContext context) {
    return  widget.products == null || widget.products.isEmpty ?
      Container(
         padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
         height: 700,
         
            child: Text(
              "Tạm thời chưa có sản phẩm phù hợp ",
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 71, 69, 77)
              ),
            ),
          
      ): Column(
            children: [
              GridView.builder(
                shrinkWrap: true, // Tránh cuộn riêng
                physics: const NeverScrollableScrollPhysics(), // Loại bỏ cuộn
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.67,
                ),
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  return ProductCard(product: product);
                },
              ),
            ],
          );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
   
    Uint8List? bytesImage;
    if (product?['image'] != null && product?['image'].isNotEmpty) {
      bytesImage = const Base64Decoder().convert(product?['image']);
    } else {
      bytesImage = Uint8List(0); // Giá trị mặc định là một danh sách trống
    }

    return
      Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                if (product['promo'] != 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C53A5),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Text(
                      "-${product['promo']}%",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const Spacer(),
                const Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product,), 
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: bytesImage.isNotEmpty ? Image.memory(
                  bytesImage,
                  height: 120,
                  width: 120,
                ) : Container(height: 120,
                  width: 120,), 
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                product['name'] ?? "Item name",
                maxLines: 1, 
                overflow: TextOverflow.ellipsis, 
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4C53A5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          product['promo'] > 0 ?
            Row(
              children: [
              Padding(
                  padding: const EdgeInsets.only(top :2),
                  child: Text(
              '${ NumberFormat('###,###').format(product['price'])} đ',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 134, 135, 137),
                    decoration: TextDecoration.lineThrough,
                  ),
                                          ),
                ),
                const Spacer(),
                Text(
                  "${product['sold'] ?? 0} luợt mua",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 76, 78, 95),
                  ),
                ),
              ],
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [  
                Text(
                      "${product['sold'] ?? 0} luợt mua",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 76, 78, 95),
                      ),
                    ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
              
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      product['promo'] > 0  ?
                          Text(
                          '${NumberFormat('###,###').format(product['price'] -  product['promo']*0.01 * product['price'])} đ' ,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 68, 72, 109),
                            ),
                          )
                      : 
                      Text(
                        "${product['price'] ?? 0} đ",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 68, 72, 109),
                        ),
                      ),
                  const Icon(
                    Icons.shopping_cart_checkout_rounded,
                    color: Color.fromARGB(255, 68, 72, 109),
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
