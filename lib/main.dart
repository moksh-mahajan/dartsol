import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/airdrop_page.dart';

void main() {
  runApp(const ProviderScope(child: DartSolApp()));
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
      home: const AirdropPage(),
    );
  }
}
