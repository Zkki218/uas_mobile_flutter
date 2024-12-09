import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cashier_controller.dart';
import '../widgets/custom_sidebar.dart';

class CashierView extends GetView<CashierController> {
  const CashierView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController productNameController = TextEditingController();
    final TextEditingController productPriceController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade800],
            ),
          ),
        ),
      ),
      drawer: const CustomSidebar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: productNameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Produk',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: productPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Harga',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (productNameController.text.isNotEmpty && 
                            productPriceController.text.isNotEmpty) {
                          controller.addProduct(
                            productNameController.text, 
                            double.parse(productPriceController.text)
                          );
                          productNameController.clear();
                          productPriceController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Tambah'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() => ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: controller.currentProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.currentProducts[index];
                    return ListTile(
                      title: Text(product.name),
                      trailing: Text(
                        'Rp ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text('${index + 1}'),
                      ),
                    );
                  },
                )),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      'Total: Rp ${controller.totalPrice.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    )),
                ElevatedButton(
                  onPressed: controller.completeTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Selesaikan Transaksi'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}