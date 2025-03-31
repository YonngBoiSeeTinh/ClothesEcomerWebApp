import 'dart:typed_data';
import 'package:GOSY/AppConfig.dart';
import 'package:GOSY/Page/ProductDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Promowidget extends StatefulWidget {
   Map<String, dynamic>? product;
   Promowidget({super.key, required this.product});
  @override
  _PromowidgetState createState() => _PromowidgetState();
}

class _PromowidgetState extends State<Promowidget> {
 
  @override
  void initState() {
    super.initState();
    
  }

    @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Color.fromARGB(255, 106, 107, 122),
          ),
        ],
      ),
      child: widget.product == null
              ?  Container(
                  width: 380,
                  height: 250,
                    padding: const EdgeInsets.only(left: 120),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                )
              : buildPromoContent(context),
    );
  }

  Widget buildPromoContent(BuildContext context) {
      Uint8List? bytesImage;
      if ( widget.product != null &&  widget.product?['image'] != null &&  widget.product?['image'].isNotEmpty) {
        bytesImage = const Base64Decoder().convert( widget.product?['image']);
      } else {
        bytesImage = Uint8List(0); // Hình ảnh trống
      }
   

    return Stack(
      children: [
        // Ảnh nền
        Container(
          width: 380,
          height: 250,
          padding: const EdgeInsets.only(left: 120),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child:widget.product == null ?Container(
                height: 250,
                alignment: Alignment.center,
              ):
              bytesImage.isNotEmpty
              ? Image.memory(
                bytesImage,
                height: 250,
              )
              : Container(
                  height: 250,
                  alignment: Alignment.center,
                ),
             
        ),
        // Chữ nổi
        Positioned(
          top: 50,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Giảm 25%',
                style: TextStyle(
                  color: Color.fromARGB(255, 138, 143, 213),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 3),
                      blurRadius: 3,
                      color: Color.fromARGB(255, 28, 34, 99),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '8/3 - 30/4',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 1,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        product:  widget.product,
                      ), 
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                      color: Color(0xFF4C53A5), // Màu viền
                      width: 2, // Độ dày viền
                    ),
                  ),
                ),
                child: const Text(
                  'Mua ngay',
                  style: TextStyle(
                    color: Color(0xFF4C53A5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
