import 'package:dartsol/cluster_url.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solana/solana.dart';

final rpcClientProvider = Provider((_) => RpcClient(ClusterUrl.devnet.url));
