import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:GOSY/AppConfig.dart';
import 'package:GOSY/Page/AccountPage.dart';
import 'package:GOSY/Page/CartPage.dart';
import 'package:GOSY/Page/HomePage.dart';
import 'package:GOSY/Page/PaymentResult.dart';
import 'package:GOSY/Page/welcomePage.dart';
import 'package:GOSY/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart'; 
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: MyApp(),
      ),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
   @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

   List<dynamic> products = [];
  List<dynamic> categories = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts(); 
    fetchCategories();
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
        print('product at home ${response.body}');
      } else {
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        isLoading = false; // Kết thúc tải dữ liệu
      });
    }
  }
   Future<void> fetchCategories() async {
    setState(() {
      isLoading = true; 
    });
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/Categories'));
      if (response.statusCode == 200) {
        setState(() {
          categories = jsonDecode(response.body);
        });
        print('categories ${response.body}');
      } else {
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        isLoading = false; // Kết thúc tải dữ liệu
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return isLoading
          ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 13),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.white, width: 2),
            ),
            child:  Center(child:
              CircularProgressIndicator(),
            ))
          
          : MaterialApp(
      title: 'GOSY STORE',
      color: Colors.white,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/":(context) => Homepage(products:products, categories: categories,),
        "/cartPage":(context)=>Cartpage(products:products),
        "/payment-result":(context)=>PaymentResult(),
        "/welcomPage":(context) => WelcomePage(),
        "/account" :(context) => AccountWidget(products:products),
      },
    
    );
  }
}

