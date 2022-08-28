import 'package:dartsol/pages/wallet_balance_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DartSolApp());
}

class DartSolApp extends StatelessWidget {
  const DartSolApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WalletBalancePage(),
    );
  }
}
