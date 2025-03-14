import 'dart:convert';

import 'package:GOSY/Page/ProductDetail.dart';
import 'package:flutter/material.dart';

class OrderDetail extends StatefulWidget {
  final List<dynamic> orders; 
  final List<dynamic> orderDetails; 
  final List<dynamic> products;
  final int orderId;
  const OrderDetail({super.key, 
    required this.orderDetails,
    required this.orders,
    required this.products,
    required this.orderId,
  }) ;

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  
  List<dynamic> getOrderDetailsByOrderId(int orderId) {
   
    print('order detail:${widget.orderDetails.where((detail) => detail['orderId'] == orderId).toList()} ');
    return widget.orderDetails.where((detail) => detail['orderId'] == orderId).toList();
    
  }

  dynamic getProduct(int productId) {
    final product = widget.products.firstWhere(
      (product) => product['id'].toString() == productId.toString(),
      orElse: () => null,
    );
    return product;
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.orders.firstWhere((o) => o['id'] == widget.orderId, orElse: () => null);
    final selectedOrderDetails = getOrderDetailsByOrderId(widget.orderId);

        if (order == null) {
          return Center(
            child: Text(
              "Order not found",
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        }

        return 
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Người nhận: ${order['name'] ?? 'N/A'}",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Địa chỉ: ${order['address'] ?? 'N/A'}",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Số điện thoại: ${order['phone'] ?? 'N/A'}",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Danh sách sản phẩm:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: selectedOrderDetails.map((od) {
                      dynamic product = getProduct(od?['productId']);
                      String formattedPrice = "${od['price']}".replaceAllMapped(
                        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                        (match) => "${match[1]},",
                      );
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ProductDetailPage(product: product,), 
                          ),);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          decoration: BoxDecoration(
                            border:Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 111, 111, 111), // Set the color of the border
                                width: 1.0, // Set the thickness of the border
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 55,
                                    child: 
                                      product == null  ? Icon(Icons.image_not_supported, size: 50, color: Colors.grey)
                                      : product['image'] != null && product['image'].isNotEmpty
                                      ? Image.memory(base64Decode(product['image']), height: 50)
                                      : Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                    
                                  ),
                                  Text(
                                      product?['name'],
                                      style: TextStyle(fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Số lượng: ${od['quantity']}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Spacer(),
                                    Text(
                                      "x    $formattedPrice VND",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                 
                  Column(
                    children: [
                      order['cancellationReason']!= null &&  order['cancellationReason'].isNotEmpty ?
                       Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey)
                        ),
                        child: 
                        order['cancellationReason']!= null ?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lý do hủy:",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
                            ),
                            Text(
                              "${order['cancellationReason'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ):Text(""),
                      )
                      :Text("")
                    ],
                  ),
                 
                  Divider(color: Color.fromARGB(255, 75, 83, 174)),
                  Text(
                      "Tổng tiền: ${order['totalPrice'] ?? '0'} VND",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                 
                ],
              ),
            ),
          );
  }
}
