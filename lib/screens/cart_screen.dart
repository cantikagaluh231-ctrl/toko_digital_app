import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // Format angka Rupiah tanpa desimal
  String formatRupiah(num number) {
    return number.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItemsList = cart.items.values.toList();
    final cartItemKeys = cart.items.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F0),
      appBar: AppBar(
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            color: Color(0xFF4A3428),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A3428)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                'Keranjang Anda Kosong',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // List Produk di Keranjang
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      final item = cartItemsList[i];
                      final productId = cartItemKeys[i];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            // Gambar Produk
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.bakery_dining,
                                      size: 30, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Detail Info Produk
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                      // Tombol Hapus Produk
                                      GestureDetector(
                                        onTap: () {
                                          cart.removeItem(productId);
                                        },
                                        child: Icon(
                                          Icons.delete_outline,
                                          size: 20,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${formatRupiah(item.price)}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Control Jumlah (+ -)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3EDE7),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                                minWidth: 32, minHeight: 32),
                                            icon: const Icon(Icons.remove,
                                                size: 16),
                                            onPressed: () {
                                              cart.removeSingleItem(productId);
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: Text(
                                              '${item.quantity}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                                minWidth: 32, minHeight: 32),
                                            icon: const Icon(Icons.add, size: 16),
                                            onPressed: () {
                                              cart.addItem(
                                                item as dynamic,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Card Ringkasan Pembayaran & Tombol Checkout
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2ECE4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Rincian Daftar Produk di Ringkasan
                      ...cartItemsList.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.name} ${item.quantity > 1 ? '(${item.quantity})' : ''}',
                                style: const TextStyle(
                                  color: Color(0xFF5D524A),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Rp ${formatRupiah(item.price * item.quantity)}',
                                style: const TextStyle(
                                  color: Color(0xFF5D524A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Divider(height: 20, thickness: 1),

                      // Total Pembayaran
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A3428),
                            ),
                          ),
                          Text(
                            'Rp ${formatRupiah(cart.totalAmount)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A3428),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Tombol Checkout
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7A513E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            cart.clear();
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Pesanan Berhasil'),
                                content: const Text(
                                    'Terima kasih! Pesanan Anda telah berhasil di-checkout.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.payment, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Checkout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Teks Dekorasi Bawah
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Freshly Baked With Love ♡',
                        style: TextStyle(
                          fontFamily: 'Serif',
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF8C7A6B),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.bakery_dining_outlined,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}