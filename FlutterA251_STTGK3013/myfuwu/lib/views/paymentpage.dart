import 'package:flutter/material.dart';
import 'package:myfuwu/models/user.dart';
import 'package:myfuwu/myconfig.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final User user;
  final int credits;
  const PaymentPage({super.key, required this.user, required this.credits});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController _webcontroller;
  late double screenHeight, screenWidth, resWidth;
  late String userName, userEmail, userPhone, userID;

  @override
  void initState() {
    userEmail = widget.user.userEmail.toString();
    userPhone = widget.user.userPhone.toString();
    userName = widget.user.userName.toString();

    userID = widget.user.userId.toString();
    super.initState();
    _webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          '${MyConfig.baseUrl}/myfuwu/api/payment.php?email=$userEmail&phone=$userPhone&userid=$userID&name=$userName&credits=${widget.credits}',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: const Color(0xFF1F3C88),
      ),
      body: WebViewWidget(controller: _webcontroller),
    );
  }
}
