import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../models/transaction_model.dart';
import 'dart:convert';

class DashboardController extends GetxController {
  final RxList<Transaction> transactions = <Transaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  // Simpan transaksi ke SharedPreferences
  Future<void> saveTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Konversi list transaksi ke JSON
      final transactionJsonList = transactions
          .map((transaction) => {
                'products': transaction.products
                    .map((product) =>
                        {'name': product.name, 'price': product.price})
                    .toList(),
                'date': transaction.date.toIso8601String(),
                'totalAmount': transaction.totalAmount
              })
          .toList();

      await prefs.setString('transactions', json.encode(transactionJsonList));
    } catch (e) {
      debugPrint('Error saving transactions: $e');
    }
  }

  // Muat transaksi dari SharedPreferences
  Future<void> loadTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final transactionString = prefs.getString('transactions');

      if (transactionString != null) {
        // Parse JSON kembali ke list transaksi
        final List<dynamic> transactionJsonList =
            json.decode(transactionString);

        transactions.value = transactionJsonList.map((transactionJson) {
          return Transaction(
              products: (transactionJson['products'] as List)
                  .map((productJson) => Product(
                      name: productJson['name'], price: productJson['price']))
                  .toList(),
              date: DateTime.parse(transactionJson['date']),
              totalAmount: transactionJson['totalAmount']);
        }).toList();
      }
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    }
  }

  // Metode untuk menambahkan transaksi baru
  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    saveTransactions(); // Simpan setelah menambahkan transaksi
  }

  // Metode untuk menghitung total penjualan hari ini dengan SharedPreferences
  Future<double> getTodayTotalSales() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final transactionString = prefs.getString('transactions');

      if (transactionString != null) {
        final List<dynamic> transactionJsonList =
            json.decode(transactionString);

        // Filter transaksi hari ini
        final todayTransactions = transactionJsonList.where((transactionJson) {
          final transactionDate = DateTime.parse(transactionJson['date']);
          return _isSameDay(transactionDate, DateTime.now());
        }).toList();

        // Hitung total penjualan
        double totalSales = 0.0;
        for (var transaction in todayTransactions) {
          totalSales += transaction['totalAmount'];
        }

        return totalSales;
      }
      return 0.0;
    } catch (e) {
      debugPrint('Error menghitung total penjualan hari ini: $e');
      return 0.0;
    }
  }

  // Metode untuk menghitung jumlah transaksi hari ini dengan SharedPreferences
  Future<int> getTodayTransactionCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final transactionString = prefs.getString('transactions');

      if (transactionString != null) {
        final List<dynamic> transactionJsonList =
            json.decode(transactionString);

        // Filter transaksi hari ini
        final todayTransactions = transactionJsonList.where((transactionJson) {
          final transactionDate = DateTime.parse(transactionJson['date']);
          return _isSameDay(transactionDate, DateTime.now());
        });

        return todayTransactions.length;
      }
      return 0;
    } catch (e) {
      debugPrint('Error menghitung jumlah transaksi hari ini: $e');
      return 0;
    }
  }

  // Utility method untuk memeriksa apakah dua tanggal adalah hari yang sama
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
