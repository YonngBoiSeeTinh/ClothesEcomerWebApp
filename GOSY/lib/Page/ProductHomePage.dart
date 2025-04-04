import 'package:flutter/material.dart';
import 'package:GOSY/Widget/CategoryWidget.dart';
import 'package:GOSY/Widget/HomeAppBar.dart';
import 'package:GOSY/Widget/ItemWidget.dart';
import 'package:GOSY/Widget/PromoWidget.dart';

class ProductHomepage extends StatefulWidget {
  final List<dynamic> products;
  final List<dynamic> categories;
  const ProductHomepage({super.key, required this.products, required this.categories});

  @override
  _ProductHomepageState createState() => _ProductHomepageState();
}

class _ProductHomepageState extends State<ProductHomepage> {
  String? searchFilter;
  int? cateid;
  List<dynamic>? productFilter;

  @override
  void initState() {
    super.initState();
    productFilter = List.from(widget.products); // Khởi tạo danh sách sản phẩm
  }

  /// Lọc sản phẩm theo `name` và `category`
  void applyFilters() {
    setState(() {
      productFilter = widget.products.where((item) {
        final name = item['name']?.toString().toLowerCase() ?? '';
        final matchesName = (searchFilter == null 
                            || searchFilter!.isEmpty 
                            || name.contains(searchFilter!.toLowerCase())
        );
        final matchesCategory = (cateid == null 
                                || item['categoryId'] == cateid
        );
        return matchesName && matchesCategory;
      }).toList();
    });
  }

  /// Cập nhật categoryId và lọc lại danh sách sản phẩm
  void setCateId(int id) {
    cateid = id;
    applyFilters();
  }

  /// Cập nhật searchFilter và lọc lại danh sách sản phẩm
  void setProductSearch(String query) {
    searchFilter = query;
    applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    dynamic productPromo = widget.products.firstWhere(
      (pro) => pro['id'] == 5,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeAppBar(),
            Container(
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Ô tìm kiếm sản phẩm
                  Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Tìm kiếm",
                              icon: Icon(Icons.search),
                            ),
                            onFieldSubmitted: (value) {
                              setProductSearch(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Widget promo nếu không tìm kiếm
                  Promowidget(product: productPromo),

               

                  // Danh mục sản phẩm
                  SizedBox(
                    height: 50,
                    child: Categorywidget(
                      categories: widget.categories,
                      setCateId: setCateId,
                    ),
                  ),

                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          "Bán chạy",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              productFilter = List.from(widget.products);
                              searchFilter = null;
                              cateid = null;
                            });
                          },
                          icon: Icon(Icons.refresh,color:Color(0xFF4C53A5) , size: 25,),
                        ),
                      ],
                    ),
                  ),

                  // Hiển thị danh sách sản phẩm
                  ItemWidget(products: productFilter ?? []),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
