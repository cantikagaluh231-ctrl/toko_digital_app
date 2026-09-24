import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Roti & Kue',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7A4E3A),
            primary: const Color(0xFF7A4E3A),
          ),
          scaffoldBackgroundColor: const Color(0xFFFAF7F2),
          useMaterial3: true,
        ),
        builder: (context, child) {
          // Menjaga tampilan selalu seukuran layar HP di Browser Chrome PC
          return Container(
            color: const Color(0xFF2B2B2B), // Background gelap di luar mockup HP
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 430, // Lebar standar HP (iPhone 14 / Android Large)
                  height: 900, // Tinggi standar HP
                  decoration: const BoxDecoration(
                    color: Color(0xFFFAF7F2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: child,
                ),
              ),
            ),
          );
        },
        home: const ProductListScreen(),
      ),
    );
  }
}