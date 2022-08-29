import 'dart:developer';

import 'package:dartsol/cluster_url.dart';
import 'package:dartsol/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solana/solana.dart';

class WalletBalancePage extends StatefulWidget {
  const WalletBalancePage({Key? key}) : super(key: key);

  @override
  State<WalletBalancePage> createState() => _WalletBalancePageState();
}

class _WalletBalancePageState extends State<WalletBalancePage> {
  final _addressController = TextEditingController();

  var _isLoadingBalance = false;
  var _balance;

  Future<double?> _getWalletBalance(String publicKey) async {
    try {
      final lamports = await ProviderContainer()
          .read(rpcClientProvider)
          .getBalance(publicKey);
      return lamports / lamportsPerSol;
    } catch (error) {
      log('Something went wrong: $error');
      return null;
    }
  }

  void _onButtonPress() async {
    setState(() {
      _isLoadingBalance = true;
    });

    final balance = await _getWalletBalance(_addressController.text.trim());
    setState(() {
      _isLoadingBalance = false;
      _balance = balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check Wallet Balance')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Cluster Url',
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(ClusterUrl.devnet.url),
          const SizedBox(
            height: 48,
          ),
          TextField(
            autofocus: true,
            controller: _addressController,
            style: Theme.of(context).textTheme.titleSmall,
            decoration: InputDecoration(
                suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => _addressController.clear(),
            )),
          ),
          const SizedBox(
            height: 8,
          ),
          _isLoadingBalance
              ? const SizedBox.square(
                  dimension: 24, child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _onButtonPress,
                  child: const Text('Check SOL Balance')),
          const SizedBox(
            height: 24,
          ),
          if (_balance != null && !_isLoadingBalance) ...[
            Text(
              'Address',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(_addressController.text.trim()),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Balance',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text('$_balance SOL')
          ]
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}
