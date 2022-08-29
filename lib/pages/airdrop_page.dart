import 'dart:developer';

import 'package:dartsol/cluster_url.dart';
import 'package:dartsol/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solana/solana.dart';

class AirdropPage extends StatefulWidget {
  const AirdropPage({Key? key}) : super(key: key);

  @override
  State<AirdropPage> createState() => _AirdropPageState();
}

class _AirdropPageState extends State<AirdropPage> {
  var _isAirdropping = false;
  var _isLoadingBalance = false;
  String? _walletAddress;
  String? _txSignature;
  double _balance = 0.0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Airdrop SOL'),
          actions: [
            if (_walletAddress != null)
              _isLoadingBalance
                  ? const Align(
                      child: SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                    )
                  : ElevatedButton(
                      onPressed: _onCheckBalancePress,
                      child: const Text('CHECK BALANCE'))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cluster Url',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(ClusterUrl.devnet.url),
              const SizedBox(
                height: 8,
              ),
              _isAirdropping
                  ? const SizedBox.square(
                      dimension: 24, child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _walletAddress == null
                          ? _onGenerateKeypairPress
                          : _onAirdropPress,
                      child: Text(_walletAddress == null
                          ? 'Generate Keypair'
                          : 'Airdrop 1 SOL')),
              const SizedBox(
                height: 24,
              ),
              if (_walletAddress != null) ...[
                Text(
                  'Wallet Address',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(_walletAddress!),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'SOL Balance',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text('$_balance SOL')
              ],
              if (_txSignature != null) ...[
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Tx Signature',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(_txSignature!)
              ]
            ],
          ),
        ),
      );

  Future<void> _onGenerateKeypairPress() async {
    final keypair = await _generateKeypair();
    setState(() {
      _walletAddress = keypair.address;
    });
  }

  Future<void> _onAirdropPress() async {
    setState(() {
      _isAirdropping = true;
    });
    final signature = await _airdrop1Sol(_walletAddress!);
    setState(() {
      _isAirdropping = false;
      _txSignature = signature;
    });
  }

  Future<void> _onCheckBalancePress() async {
    setState(() {
      _isLoadingBalance = true;
    });
    await Future.delayed(const Duration(seconds: 10));
    final balance = await _getWalletBalance(_walletAddress!);
    setState(() {
      _isLoadingBalance = false;
      _balance = balance!;
    });
  }
}

Future<double?> _getWalletBalance(String publicKey) async {
  try {
    final lamports =
        await ProviderContainer().read(rpcClientProvider).getBalance(publicKey);
    return lamports / lamportsPerSol;
  } catch (error) {
    log('Something went wrong: $error');
    return null;
  }
}

Future<String> _airdrop1Sol(
  String pubKey,
) async =>
    ProviderContainer()
        .read(rpcClientProvider)
        .requestAirdrop(pubKey, lamportsPerSol * 1);

Future<Ed25519HDKeyPair> _generateKeypair() async => Ed25519HDKeyPair.random();
