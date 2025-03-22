import 'package:GOSY/Page/AccountPage.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

class PaymentResult extends StatefulWidget {
  @override
  _PaymentResultState createState() => _PaymentResultState();
}

class _PaymentResultState extends State<PaymentResult> {
  String? paymentStatus; // Biến để lưu trạng thái thanh toán
  late AppLinks _appLinks; 
  StreamSubscription<Uri?>? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener(); // Khởi động lắng nghe Deep Link
  }

  @override
  void dispose() {
    _sub?.cancel(); // Hủy lắng nghe khi widget bị hủy
    super.dispose();
  }

  Future<void> _initDeepLinkListener() async {
    _appLinks = AppLinks();

    // Lấy deep link khởi tạo (nếu có)
    try {
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      setState(() {
        paymentStatus = "Lỗi xảy ra khi xử lý Deep Link khởi tạo.";
      });
    }

    // Lắng nghe Deep Link
    _sub = _appLinks.uriLinkStream.listen(
      (Uri? deepLink) {
        if (deepLink != null) {
          _handleDeepLink(deepLink);
        }
      },
      onError: (err) {
        // Xử lý lỗi
        setState(() {
          paymentStatus = "Lỗi xảy ra khi xử lý Deep Link.";
        });
      },
    );
  }

  void _handleDeepLink(Uri deepLink) {
    final status = deepLink.queryParameters['status']; // Lấy giá trị 'status'
    setState(() {
      paymentStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kết quả thanh toán"),
      ),
      body: Center(
        child: paymentStatus == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    paymentStatus == "success"
                        ? Icons.check_circle
                        : Icons.error,
                    size: 100,
                    color: paymentStatus == "success" ? Colors.green : Colors.red,
                  ),
                  SizedBox(height: 20),
                  Text(
                    paymentStatus == "success"
                        ? "Thanh toán thành công!"
                        : "Thanh toán thất bại!",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                     Navigator.pushNamed(context, '/account');
                    },
                    child: Text("Xem đơn hàng của bạn"),
                  ),
                ],
              ),
      ),
    );
  }
}
