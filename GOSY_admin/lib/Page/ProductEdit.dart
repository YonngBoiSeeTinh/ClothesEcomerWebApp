import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../AppConfig.dart';
import '../Widget/Alter.dart';
import 'HomePage.dart';


class ProductUpdatePage extends StatefulWidget {
  final Map<String, dynamic>? product;
  const ProductUpdatePage({super.key, required this.product});

  @override
  _ProductUpdatePageState createState() => _ProductUpdatePageState();
}

class _ProductUpdatePageState extends State<ProductUpdatePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController promoController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<dynamic> colorSizeList = [];
  List<dynamic> categories = []; 

  File? imageFile;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
   
    unitController.text = widget.product?['unit'] ?? '';
    promoController.text = widget.product?['promo']?.toString() ?? '';
    priceController.text = widget.product?['price']?.toString() ?? '';
    descriptionController.text = widget.product?['description'] ?? '';
    selectedCategoryId = widget.product?['categoryId'].toString();
    fetchCategories();
    fetchColorSizes(widget.product?['id']);
  }
  Future<void> fetchCategories() async {
    setState(() {
      isLoading = true; // Bắt đầu tải dữ liệu
    });
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/Categories'));
      if (response.statusCode == 200) {
        setState(() {
          categories = jsonDecode(response.body);
        });
      } else {
        print('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
    finally {
      setState(() {
        isLoading = false; 
      });
    }
}


  Future<void> updateProduct(File? imageFile) async {
  var uri = Uri.parse('${ApiConfig.baseUrl}/api/Products/${widget.product?['id']}');
  var request = http.MultipartRequest('PUT', uri);

  // Thêm các trường văn bản
  request.fields['name'] = nameController.text;
  request.fields['promo'] = promoController.text;
  request.fields['startRate'] =widget.product?['startRate'] ;
  request.fields['unit'] = unitController.text;
  request.fields['createdAt'] = widget.product?['createdAt'] ?? '';
  request.fields['brand'] = widget.product?['brand'] ?? '';
  request.fields['price'] = priceController.text;
  request.fields['sold'] =widget.product?['sold'] ?? '';
  request.fields['description'] = descriptionController.text;
  request.fields['categoryId'] = selectedCategoryId ?? '';

  // Thêm tệp hình ảnh nếu có
  if (imageFile != null) {
    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    );
    request.files.add(multipartFile);
  }

  // Gửi yêu cầu
  var response = await request.send();

  if (response.statusCode == 204) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Alter(message: 'Cập nhật sản phẩm thành công!');
      },
    ).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homepage(index: 1),
        ),
      );
    });
    } else {
      Alter(message: 'Cập nhật sản phẩm thất bại, vui lòng thử lại!');
      print('Failed to update product: ${response.statusCode}');
      var responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');
    }
}
  Future<void> fetchColorSizes(int id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/ColorSizes/ProductColorSize/${id}'),
      );
      print('colorSizeList ${response.statusCode} ${id}');
      if (response.statusCode == 200) {
        setState(() {
          colorSizeList = jsonDecode(response.body);
        
        });
        
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

  Future<void> addColorSize(dynamic colorSize) async {
      setState(() {
        isLoading = true;
      });
      try {
        colorSize['productId'] = widget.product?['id'];
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/api/ColorSizes'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(colorSize),
        );

        if (response.statusCode == 201) {
          print('Successfully added color size: ${response.body}');
          setState(() {
            colorSizeList.add(colorSize);
          });
        } else {
          print('Failed to add color size: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error adding color size: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }

  Future<void> updateColorSizes(dynamic colorSize) async {
    try {
    
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/ColorSizes/${colorSize["id"]}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": colorSize["id"],
          "color": colorSize["color"],
          "size": colorSize["size"],
          "quantity": colorSize["quantity"],
          "productId": widget.product?['id'], 
          "code": colorSize["code"],
          "createdAt": colorSize["createdAt"],
          "price":0
        }),
      );

      if (response.statusCode == 204) {
        print('Successfully updated color size: ${response.body}');
      } else {
        print('Failed to update color size: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error updating color size: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        title: Text("Update Product",style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF4C53A5),
        iconTheme: IconThemeData(
          color: Colors.white,
         ),
      ),
      body: isLoading
      ? const Center(child: CircularProgressIndicator())
      : ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildProductImage(),
          Text("Product info" ,style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C53A5),
            ),),
          _buildTextField("Product Name", nameController),
          _buildTextField("Price", priceController, keyboardType: TextInputType.number),
          _buildTextField("Unit", unitController),
          _buildTextField("Promo", promoController, keyboardType: TextInputType.number),
          _buildCategorySelection(),
          _buildTextField("Description", descriptionController, maxLines: 3),
          _buildColorSizeSection(),
          SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                updateProduct(imageFile);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                          Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Color(0xFF4C53A5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Update",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
              ),
            ),
          ),
    );
  }
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
  Widget _buildProductImage() {
      return  isLoading
      ? const Center(child: CircularProgressIndicator())
      :  Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                imageFile != null
                    ? Image.file(
                        imageFile!,
                        height: 200,
                      )
                    :widget.product?['image'] != null ?Image.memory(
                              base64Decode(widget.product?['image']),
                              height: 200,
                      )
                     :Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: Icon(Icons.image, color: Colors.grey),
                      ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        color: Color(0xFF4C53A5),
                        width: 2,
                      ),
                    ),
                    shadowColor: Colors.black,
                    elevation: 6,
                  ),
                  child: Text(
                    "Thêm Ảnh",
                    style: TextStyle(color: Color(0xFF4C53A5), fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        );
      }
  String? selectedCategoryId;

  Widget _buildCategorySelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Category",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C53A5),
            ),
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedCategoryId,
            items: categories.map<DropdownMenuItem<String>>((category) {
              return DropdownMenuItem<String>(
                value: category['id'].toString(),
                child: Text(category['name']),
              );
            }).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                selectedCategoryId = value;
              });
            },
            hint: Text("Select a category"),
          ),
        ],
      ),
    );
  }


  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
 
  Widget _buildColorSizeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Color & Size",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C53A5),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle, color: Color(0xFF4C53A5)),
              onPressed: _addColorSize,
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colorSizeList.map((colorSize) {
            return InkWell(
              onTap: (){
               _editColorSize(colorSize);
              },
              child: Chip(
                label: Text("${colorSize['color']} - ${colorSize['size']}"),
                onDeleted: () {
                  setState(() {
                    colorSizeList.remove(colorSize);
                  });
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  void _editColorSize(Map<String, dynamic> colorSize) {
        final TextEditingController colorController =
            TextEditingController(text: colorSize['color']);
        final TextEditingController sizeController =
            TextEditingController(text: colorSize['size']);
        final TextEditingController quantityController =
            TextEditingController(text: colorSize['quantity'].toString());
        final TextEditingController codeController =
            TextEditingController(text: colorSize['code']);
      
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Edit Color and Size"),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: colorController,
                    decoration: InputDecoration(labelText: "Color"),
                  ),
                  TextField(
                    controller: sizeController,
                    decoration: InputDecoration(labelText: "Size"),
                  ),
                  TextField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: "Quantity"),
                  ),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(labelText: "code"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async{
                  setState(() {
                    colorSize['color'] = colorController.text;
                    colorSize['size'] = sizeController.text;
                    colorSize['quantity'] = quantityController.text;
                    colorSize['code'] = codeController.text;
                  });
                  await updateColorSizes(colorSize);

                  setState(() {}); 
                  Navigator.of(context).pop();
                },
                child: Text("Save"),
              ),
            ],
          );
        },
      );
    }

  void _addColorSize() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController colorController = TextEditingController();
        final TextEditingController sizeController = TextEditingController();
        final TextEditingController quantityController = TextEditingController();
        final TextEditingController codeController = TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Add Color and Size"),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: colorController,
                  decoration: InputDecoration(labelText: "Color"),
                ),
                 TextField(
                  controller: sizeController,
                  decoration: InputDecoration(labelText: "Size"),
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: "Quantity"),
                ),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(labelText: "Code"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: ()async {
               final newColorSize = {
                  "color": colorController.text,
                  "size": sizeController.text,
                  "quantity": int.tryParse(quantityController.text) ?? 0,
                  "code": codeController.text,
                };

               
                await addColorSize(newColorSize);

                setState(() {
                  colorSizeList.add(newColorSize); 
                });
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
