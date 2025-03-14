import 'dart:io';

import 'package:GOSY/Page/CartPage.dart';
import 'package:GOSY/Page/HomePage.dart';
import 'package:GOSY/Page/welcomePage.dart';
import 'package:GOSY/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart'; 
import 'package:provider/provider.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
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
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GOSY STORE',
      color: Colors.white,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/":(context) => Homepage(),
        "/cartPage":(context)=>Cartpage(),
         "welcomPage":(context) => WelcomePage()
      },
    
    );
  }
}

