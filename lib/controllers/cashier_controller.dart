import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/transaction_model.dart';
import 'dashboard_controller.dart';

class CashierController extends GetxController {
  final RxList<Product> currentProducts = <Product>[].obs;
  final RxDouble totalPrice = 0.0.obs;

  void addProduct(String name, double price) {
    Product product = Product(name: name, price: price);
    currentProducts.add(product);
    updateTotalPrice();
  }

  void updateTotalPrice() {
    totalPrice.value = currentProducts.fold(
      0.0, 
      (sum, product) => sum + product.price
    );
  }

  void completeTransaction() {
    if (currentProducts.isNotEmpty) {
      Transaction transaction = Transaction(
        products: List.from(currentProducts),
        date: DateTime.now(),
        totalAmount: totalPrice.value
      );

      // Simpan transaksi di dashboard
      Get.put(DashboardController()).addTransaction(transaction);

      // Reset kasir
      currentProducts.clear();
      totalPrice.value = 0.0;

      Get.snackbar('Sukses', 'Transaksi berhasil diselesaikan');
    }
  }
}