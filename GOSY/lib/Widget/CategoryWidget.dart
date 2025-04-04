import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Categorywidget extends StatefulWidget {
 final List<dynamic> categories ;
 final Function(int) setCateId; 
  const Categorywidget({super.key, required this.categories, required this.setCateId});
  @override
  _CategorywidgettState createState() => _CategorywidgettState();
}

class _CategorywidgettState extends State<Categorywidget> {
  @override
  Widget build(BuildContext context) {
   
    return  ListView.builder(
            itemCount: widget.categories.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(), // Cuộn mượt hơn
            itemBuilder: (context, index) {
              final category = widget.categories[index];
              final imageBase64 = category['image'];
              Uint8List? imageBytes;
              if (imageBase64 != null && imageBase64 is String) {
                try {
                  imageBytes = Base64Decoder().convert(imageBase64);
                } catch (e) {
                  print("Invalid image data at index $index: $e");
                }
              }

              return InkWell(
                onTap: (){
                  widget.setCateId(category['id']);
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      imageBytes != null
                          ? Image.memory(
                              imageBytes,
                              width: 40,
                              height: 40,
                            )
                          : Container(
                              width: 40,
                              height: 40,
                              color: Colors.blueGrey,
                            ),
                      const SizedBox(width: 8), // Khoảng cách giữa ảnh và văn bản
                      Text(
                        category['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4C53A5),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
