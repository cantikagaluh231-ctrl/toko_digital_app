import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _items = [
    Product(
      id: 'p1',
      name: 'Cromboloni',
      description: 'Pastry renyah dengan isian cokelat lumer yang lezat.',
      price: 28000,
      imageUrl: 'assets/images/Cromboloni.jpeg',
      category: 'Pastry',
    ),
    Product(
      id: 'p2',
      name: 'Croissant Sandwich',
      description: 'Croissant gurih dengan isian daging dan sayuran segar.',
      price: 32000,
      imageUrl: 'assets/images/Croissant Sandwich.jpeg',
      category: 'Pastry',
    ),
    Product(
      id: 'p3',
      name: 'Donat',
      price: 12000,
      description: 'Donat lembut dengan taburan gula halus dan meses.',
      imageUrl: 'assets/images/Donat.jpeg',
      category: 'Roti',
    ),
    Product(
      id: 'p4',
      name: 'Roti Brioche',
      description: 'Roti mentega khas Prancis yang sangat lembut dan manis.',
      price: 25000,
      imageUrl: 'assets/images/Roti Brioche.jpeg',
      category: 'Roti',
    ),
    Product(
      id: 'p5',
      name: 'Kue Coklat',
      description: 'Kue spons cokelat kaya rasa dengan lapisan fuji cokelat.',
      price: 35000,
      imageUrl: 'assets/images/Kue Coklat.jpeg',
      category: 'Kue',
    ),
    Product(
      id: 'p6',
      name: 'Tiramisu',
      description: 'Kue khas Italia dengan aroma kopi dan keju mascarpone.',
      price: 38000,
      imageUrl: 'assets/images/Tiramisu.jpeg',
      category: 'Kue',
    ),
    Product(
      id: 'p7',
      name: 'Oreo Cheesecake',
      description: 'Cheesecake lembut bersalut biskuit Oreo renyah.',
      price: 40000,
      imageUrl: 'assets/images/Oreo Cheesecake.jpeg',
      category: 'Kue',
    ),
    Product(
      id: 'p8',
      name: 'Cupcake',
      description: 'Kue mangkuk manis dengan topping krim lembut berwarna-warni.',
      price: 18000,
      imageUrl: 'assets/images/Cupcake.jpeg',
      category: 'Kue',
    ),
    Product(
      id: 'p9',
      name: 'Lotus Biscoff Ice Cream Latte',
      description: 'Minuman kopi latte dingin dipadu es krim dan selai Lotus Biscoff.',
      price: 30000,
      imageUrl: 'assets/images/Lotus Biscoff Ice Cream Latte.jpeg',
      category: 'Minuman',
    ),
    Product(
      id: 'p10',
      name: 'Mochaccino Shake',
      description: 'Olahan kopi dan cokelat milkshake yang manis dan menyegarkan.',
      price: 27000,
      imageUrl: 'assets/images/Mochaccino Shake.jpeg',
      category: 'Minuman',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  // Method untuk menambahkan produk baru dari AddProductScreen
  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      category: product.category,
    );
    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    notifyListeners();
  }
}