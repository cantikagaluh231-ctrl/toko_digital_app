import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../helpers/db_helper.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  CartProvider() {
    // Otomatis muat data dari SQLite saat CartProvider dibuat
    fetchAndSetCart();
  }

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // Mengambil data dari database SQLite ke memori
  Future<void> fetchAndSetCart() async {
    final cartList = await DBHelper.getCartItems();
    final Map<String, CartItem> loadedCart = {};
    for (var item in cartList) {
      loadedCart[item.id] = item;
    }
    _items = loadedCart;
    notifyListeners();
  }

  // Menambah item dari Halaman Beranda / Katalog Produk
  Future<void> addItem(Product product) async {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
          imageUrl: existingItem.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: product.id,
          name: product.name,
          price: product.price,
          quantity: 1,
          imageUrl: product.imageUrl,
        ),
      );
    }
    // Simpan/update item ke SQLite
    await DBHelper.insertCartItem(_items[product.id]!);
    notifyListeners();
  }

  // Menambah jumlah (+1) langsung dari Halaman Keranjang
  Future<void> addItemDirectly(String productId) async {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
          imageUrl: existingItem.imageUrl,
        ),
      );
      // Update item di SQLite
      await DBHelper.insertCartItem(_items[productId]!);
      notifyListeners();
    }
  }

  // Mengurangi jumlah (-1) item dari Halaman Keranjang
  Future<void> removeSingleItem(String productId) async {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          quantity: existingItem.quantity - 1,
          imageUrl: existingItem.imageUrl,
        ),
      );
      // Update item di SQLite
      await DBHelper.insertCartItem(_items[productId]!);
    } else {
      _items.remove(productId);
      // Hapus item dari SQLite jika jumlahnya 0
      await DBHelper.deleteCartItem(productId);
    }
    notifyListeners();
  }

  // Menghapus seluruh item tertentu dari keranjang
  Future<void> removeItem(String productId) async {
    _items.remove(productId);
    await DBHelper.deleteCartItem(productId);
    notifyListeners();
  }

  // Mengosongkan seluruh isi keranjang
  Future<void> clear() async {
    _items.clear();
    await DBHelper.clearCart();
    notifyListeners();
  }
}