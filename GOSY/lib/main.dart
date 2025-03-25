import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_links/app_links.dart';
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
  StreamSubscription? _sub;
  
  @override
  void initState() {
    super.initState();
    fetchProducts(); 
    fetchCategories();
    initDeepLinkListener();
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
  late AppLinks _appLinks;
  void initDeepLinkListener() async {
    _appLinks = AppLinks();
    StreamSubscription? _linkSub;
    // Xử lý deep link khi ứng dụng được mở qua link (initial link)
    try {
      final initialUri = await _appLinks.getInitialAppLink();
      print('Initial deep link: $initialUri');
      if (initialUri != null && initialUri.path == '/paymentResult') {
        final queryParams = initialUri.queryParameters;
        print('Initial deep link: $queryParams');
        Navigator.pushNamed(context, '/paymentResult', arguments: queryParams);
      }
    } catch (e) {
      print('Error getting initial deep link: $e');
    }

    // Lắng nghe deep link trong runtime
    _linkSub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.path == '/paymentResult') {
        final queryParams = uri.queryParameters;
        print('Runtime deep link: $queryParams');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/paymentResult', arguments: queryParams);
        });
      }
    }, onError: (err) {
      print('Error in deep link stream: $err');
    });
    
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
        "/paymentResult":(context)=>PaymentResult(),
        "/welcomPage":(context) => WelcomePage(),
        "/account" :(context) => AccountWidget(products:products),
      },
    
    );
  }
}

