import 'dart:convert';
import 'dart:typed_data';
import 'package:clippy_flutter/arc.dart';
import 'package:GOSY/AppConfig.dart';
import 'package:GOSY/Widget/ItemAppBarWidget.dart';
import 'package:GOSY/Widget/ItemBottomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetailPage extends StatefulWidget {
  Map<String, dynamic>? product;
  ProductDetailPage({super.key, required this.product});
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  bool isLoading = false;
  Map<String, dynamic>? colorSizes;
  String? selectedColor; 
  List<dynamic> availableSizes = []; 
  int? selectedSizeId;
  int stock = 1;
  
  @override
  void initState() {
  
  super.initState();
    fetchColorSizes(); 
  }

  Future<void> fetchColorSizes() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/ColorSizes/ProductColorSize/${widget.product?['id']}'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        groupSizesByColor(data);
      } else {
        print('Failed to load color sizes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching color sizes: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void changeQuantity(String action) {
    setState(() {
      if (action == "add" && quantity < stock) {
        quantity++;
      } else if (action == "minus" && quantity > 1) {
        quantity--;
      }
    });
  }
  void groupSizesByColor(List<dynamic> colorSizeData) {
    Map<String, Map<String, dynamic>> groupedData = {};

    for (var item in colorSizeData) {
      String color = item['color'];
      String size = item['size'];
      String code = item['code'];
      int id = item['id'];
      int quantity = item['quantity'];
      // Nếu màu đã tồn tại trong Map, thêm size
      if (groupedData.containsKey(color)) {
        groupedData[color]!['sizes'].add({'id': id, 'size': size, 'quantity':quantity});
      } else {
        // Nếu màu chưa tồn tại, khởi tạo entry mới
        groupedData[color] = {
          'code': code,
          'sizes': [
            {'id': id, 'size': size, 'quantity':quantity}
          ],
        };
      }
  }

    setState(() {
      colorSizes = groupedData;
    });
  }

  void updateSizesForColor(String color) {
  setState(() {
    selectedColor = color;
    final sizes = (colorSizes?[color]?['sizes'])
        ?.map((e) => {
              'id': e['id'],
              'size': e['size'].toString(),
              'quantity':e['quantity']
            })
        .toList();

    availableSizes = sizes ?? [] ;
    print('availableSizes ${availableSizes}');
    selectedSizeId = null; 
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDECF2),
      body: ListView(
        children: [
          Itemappbarwidget(),
          _buildProductImage(widget.product),
          _buildProductDetails(),
        ],
      ),
      bottomNavigationBar: ItemBottomNavBar(
        product: widget.product,
        quantity: quantity,
        coloSizeId: selectedSizeId,
      ),
    );
  }
  Widget _buildProductImage(dynamic product) {
  
  Uint8List? bytesImage;
  if (product != null && product['image'] != null && product['image'].isNotEmpty) {
    bytesImage = const Base64Decoder().convert(product['image']);
  } else {
    bytesImage = Uint8List(0); // Hình ảnh trống
  }

  return Arc(
    height: 30,
    edge: Edge.BOTTOM,
    child: Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: bytesImage.isNotEmpty
            ? Image.memory(
                bytesImage,
                height: 350,
              )
            : Container(
                height: 350,
                alignment: Alignment.center,
              ),
      ),
    ),
  );
}

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.product?['name'],
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C53A5),
                ),
              ),
              Spacer(),
              Text(
                stock > 1 ? 
                '${stock.toString()} sản phẩm' : "",
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 108, 179, 108),
                ),
              ),
            ],
          ),
        ),
        _buildRatingAndQuantity(),
        SizedBox(height: 8),
        _buildColorSizeOptions(),
        _buildDescription(),
      ],
    );
  }

  Widget _buildRatingAndQuantity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.favorite,
                  color: Color(0xFF4C53A5),
                  size: 30,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                _buildQuantityButton(CupertinoIcons.minus, "minus"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    quantity.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ),
                _buildQuantityButton(CupertinoIcons.plus, "add"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, String action) {
    return InkWell(
      onTap: () {
        changeQuantity(action);
      },
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildColorSizeOptions() {
  return Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Color:",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C53A5),
              ),
            ),
            SizedBox(width: 10),
            Wrap(
              spacing: 6,
              children: (colorSizes ?? {}).keys.map<Widget>((color) {
                final colorData = colorSizes![color]!;
                return GestureDetector(
                  onTap: () => updateSizesForColor(color),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(int.parse(colorData['code'].replaceFirst('#', '0xff'))),
                      border: Border.all(
                        color: selectedColor == color
                            ? const Color.fromARGB(255, 75, 106, 163)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              "Size:",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C53A5),
              ),
            ),
            SizedBox(width: 10),
            Wrap(
            spacing: 6,
            children: availableSizes.isNotEmpty
                ? availableSizes.map<Widget>((sizeData) {
                    int sizeId = sizeData['id'];
                    int sizeStock = sizeData['quantity'];
                    bool isSelected = selectedSizeId == sizeId;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedSizeId = sizeId;
                          stock = sizeStock;
                          print('stock $sizeStock');
                        });
                      },
                      child:
                       Container(
                        constraints: BoxConstraints(minHeight: 35, minWidth: 38),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color.fromARGB(255, 134, 139, 193)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color(0xFF4C53A5),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            sizeData['size'],
                            style: TextStyle(
                              color: Color(0xFF4C53A5),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList()
                : [Row(children: [
                   Container(
                        constraints: BoxConstraints(minHeight: 35, minWidth: 38),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color(0xFF4C53A5),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "M",
                            style: TextStyle(
                              color: Color(0xFF4C53A5),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),SizedBox(width: 6,),
                   Container(
                        constraints: BoxConstraints(minHeight: 35, minWidth: 38),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color(0xFF4C53A5),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "L",
                            style: TextStyle(
                              color: Color(0xFF4C53A5),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                ],)],
          )
        ],
        ),
      ],
    ),
  );
}

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Description: ",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C53A5),
              ),
            ),
            TextSpan(
              text: widget.product?['description'],
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 54, 54, 54),
              ),
            ),
          ],
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
