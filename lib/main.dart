import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/coin_wallet_provider.dart';
import 'screens/initial_login_selection_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CoinWalletProvider())],
      child: BarterApp(),
    ),
  );
}

class BarterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarterApp',
      theme: ThemeData(
        primaryColor: Color(0xFF1E3A8A),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(secondary: Color(0xFFF97316)),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: InitialLoginSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
