import 'dart:convert';

import 'package:GOSY/AppConfig.dart';
import 'package:GOSY/Page/EditProfile.dart';
import 'package:GOSY/Page/welcomePage.dart';
import 'package:GOSY/UserProvider.dart';
import 'package:GOSY/Widget/CancelOrderWiget.dart';
import 'package:GOSY/Widget/OrderDetailWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key});

  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserStatus();
      fetchOrderDetails(); 
      fetchProducts();
    });
  }
  Map<String, dynamic>? account;
  Map<String, dynamic>? selectedOrder;
  List<dynamic> orders = [];
  bool isLoading = false;
  dynamic user;
  List<dynamic> orderDetails = []; 
  List<dynamic> products = []; 


  Future<void> fetchUserAccount(int id) async {
    try {
      final url = '${ApiConfig.baseUrl}/api/Accounts/';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
           account = jsonDecode(response.body).firstWhere((ac)=>ac['userId'] == id);
        });
        print('response.body ${response.body}');
      } else {
        throw Exception("Failed to fetch user: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching user: $error");
    }
  }
  Future<void> fetchOrderDetails() async {
    setState(() {
      isLoading = true;
    });
      try {
        final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/OrderDetails'));
        
        if (response.statusCode == 200) {
          setState(() {
            orderDetails = jsonDecode(response.body);
          });
           print('order detail at respone :${orderDetails} ');
        } else {
          print('Failed to load categories: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching categories: $e');
      }finally {
      setState(() {
        isLoading = false; 
      });
    }
    }
  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/Products'));
      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
        });
      } else {
        print('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }finally{
    setState(() {
      isLoading = false;
    });
    }
  }
  
  
  void _showOrderDetails(Map<String, dynamic> order) {
     print('order detail :${orderDetails} ');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, 
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Chi tiết đơn hàng",
                      style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 120, 127, 199),
              ),
              ),
              order['cancellationReason'] !=null &&  order['cancellationReason'].isNotEmpty ?
                Text("Đã hủy",
                      style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 7, 7),
              ),
              ):Text("")
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: OrderDetail(orderDetails: orderDetails, orders: orders, products: products, orderId:  order?['id']),
            actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            ),
          ],
        );
      },
    );
  }
  
  void _showCancleOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, 
          title: Text("Huỷ đơn hàng",
                  style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 120, 127, 199),
                  ),),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content:CancleOrder(order: order),
            actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            ),
          ],
        );
      },
    );
  }
  
  void _checkUserStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await  userProvider.loadSavedLogin();

    if (userProvider.user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    }else{
      fetchUserAccount(userProvider.user?['id']);
      setState(() {
        user = userProvider.user;
      });
      fetchOrders(userProvider.user?['id']);
    }
  }
   
  Future<void> fetchOrders(int id) async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/Orders/User/${id}'));
      if (response.statusCode == 200) {
        setState(() {
          orders = jsonDecode(response.body);
        });
       
      } else {
        print('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }
  

  Widget builtProfileAppBar(){
     return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 90,
        child: Row(
          children: [
             InkWell(
              onTap: () {
              Navigator.pushNamed(context, '/');
              },
              child: Icon(
                Icons.arrow_back, 
                size: 30,
                color: Color(0xFF4C53A5)),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                          text: 'Profile',
                          style: GoogleFonts.portLligatSans(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                    ),
                   
                  ],
                ),
              ),
              Spacer(),
               Icon(
                Icons.shopping_cart, 
                size: 30,
                color: Color(0xFF4C53A5)),
          ]
         ),
    );
 
  }
  
  Widget builtProfileAvatar(dynamic user, UserProvider userProvider){
     return Container(
        height: 185,
        padding: EdgeInsets.symmetric( horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
              margin: EdgeInsets.only(top: 8),
              width: 175,
              height: 175,
              decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(1000),
              ),
               child: ClipOval(
                child: user != null && user?['image'] != null  
                    ? Image.memory(
                        base64Decode(user?['image']),
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.account_circle, size: 180),
              ),
                
              ),
           
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                Text(user != null ? user['name'] ?? 'loading' : 'loading', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:Color(0xFF4C53A5)),),
                account != null ?
                Text(account?['email'],style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color:Color.fromARGB(255, 73, 73, 73)),)
                : Text('email',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color:Color.fromARGB(255, 73, 73, 73)),),
                 SizedBox(height: 6,),
                Text(user?['phone'],style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color:Color.fromARGB(255, 73, 73, 73)),),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                      child: Container(
                        width: 90,
                        padding:  EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFF4C53A5)),
                          color: Color.fromARGB(255, 108, 114, 188)
                        ),
                        child:  Center(child: Text('Chỉnh sửa', style: TextStyle(fontSize: 15, color:Color.fromARGB(255, 255, 255, 255)),)),
                      ),
                    ),
                    SizedBox(width: 15,),
                    SizedBox(
                      width: 90, 
                      child: InkWell(
                      onTap: (){
                        userProvider.logout();
                         Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => WelcomePage()),
                        );
                      },
                      child: Container(
                        width: 90,
                        padding:  EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFF4C53A5)),
                          color: Color.fromARGB(255, 255, 255, 255)
                        ),
                        child:  Center(child: Text('Đăng xuất', style: TextStyle(fontSize: 15, color:Color(0xFF4C53A5)),)),
                      ),
                    ),
                    )

                  ],
                )
              ],
              ),
            )
             
             
          ]
         ),
    );
 
  }
  String formatDate(String dateString) {
      final DateTime parsedDate = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(parsedDate);
    }
  Widget buildOrderItems() {
    
    return isLoading
      ? const Center(child: CircularProgressIndicator())
      : ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
          final order = orders[index];
          return 
          InkWell(
            onTap: (){
              _showOrderDetails(order);
            },
            child: Container(
              margin:EdgeInsets.only(left: 15,right: 15, bottom: 10) ,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ngày đặt: ${formatDate(order['createdAt'])} ', 
                             style:TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 51, 51, 51)  ,
                              )
                          ),
                            SizedBox(height: 8,),
                          Text(
                            'Tổng giá: ${NumberFormat('###,###').format(order['totalPrice'])} VNĐ',
                            style:TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 51, 51, 51),
                              )
                          ),
                        ],
                      ),
                      Column(
                     
                        children: [
                          Text(' ${order['status']} ',
                              style:TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:order['status'] == 'Đã giao hàng' ? 
                                const Color.fromARGB(255, 32, 112, 187) :
                                order['status'] == 'Đã xác nhận' ? 
                                const Color.fromARGB(255, 70, 183, 74) :  
                                order['status'] == 'Đã hủy' ? 
                                 const Color.fromARGB(255, 198, 30, 30) :  
                                 const Color.fromARGB(255, 224, 165, 63)
                                ,
                              )
                          ),
                          SizedBox(height: 8,),
                          InkWell(
                            onTap: (){
                              if(order['status']  == "Đã xác nhận"){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Đơn hàng đã xác nhận, không thể hủy !')),
                                    );
                              }
                              else if(order['status']  == "Đã hủy"){
                                  SnackBar(content: Text('Đơn hàng đã xác nhận, không thể hủy !'));
                              }
                              else{
                                _showCancleOrder(order);
                              } 
                              
                            },
                            child: Container(
                              width: 100,
                              padding:  EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color.fromARGB(255, 187, 128, 128)),
                                color: Color.fromARGB(255, 232, 45, 64)
                              ),
                              child:  Center(child: Text('Hủy', style: TextStyle(fontSize: 15, color:Color.fromARGB(255, 255, 255, 255)),)),
                            ),
                          ),
                        ],
                      ),
                     
                ],
              ),
            ),
          );
        }
      );   
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: user != null
          ? Column(
                children:[  
                builtProfileAppBar(),
                Expanded(
                  child: Container(
                     decoration:BoxDecoration (
                            color: Color(0xFFEDECF2),
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(30) , topRight: Radius.circular(30) ),
                          ),
                    child: Column(
                      //
                      children: [
                        builtProfileAvatar(user,userProvider),
                        
                        Container(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                                height: 70,
                                child: 
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Đơn hàng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:Color(0xFF4C53A5)),),
                                        Spacer(),
                                        Text('Đã mua: ${user?['totalBuy']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 70, 70, 72)),),     
                                      ]
                          ), ),
                        Expanded(child: buildOrderItems()),
                      ],
                    ),
                  ),
                ),
                         
                ],
              )
          : Center(
              child: CircularProgressIndicator(),
          ),
    );
  }
}
