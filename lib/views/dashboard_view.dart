import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/custom_sidebar.dart';
import '../widgets/sales_chart.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade800],
            ),
          ),
        ),
      ),
      drawer: const CustomSidebar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _buildStatCard(
                      title: 'Total Penjualan Hari Ini',
                      futureValue: controller.getTodayTotalSales(),
                      prefix: 'Rp ',
                      icon: Icons.money,
                    ),
                    const SizedBox(width: 32),
                  ],
                ),
                Row(
                  children: [
                    _buildStatCard(
                      title: 'Jumlah Transaksi Hari Ini',
                      futureValue: controller.getTodayTransactionCount(),
                      icon: Icons.receipt,
                    ),
                    const SizedBox(width: 32),
                  ],
                ),
                const SizedBox(height: 16),
                const SalesChart(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required Future<dynamic> futureValue,
    String prefix = '',
    String suffix = '',
    required IconData icon,
  }) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Icon(icon, color: Colors.blue.shade300),
                ],
              ),
              const SizedBox(height: 8),
              FutureBuilder<dynamic>(
                future: futureValue,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData 
                      ? '$prefix${snapshot.data}$suffix' 
                      : 'Memuat...',
                    style: const TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Metode untuk menyegarkan data
  Future<void> _refreshData() async {
    await controller.loadTransactions();
  }
}