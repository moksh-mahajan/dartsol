enum ClusterUrl {
  devnet('https://api.devnet.solana.com');

  const ClusterUrl(this.url);
  final String url;
}
