import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class SalesChart extends GetView<DashboardController> {
  const SalesChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Ambil data transaksi 7 hari terakhir
      final last7DaysSales = _calculateLast7DaysSales();

      return AspectRatio(
        aspectRatio: 1.7,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Penjualan Mingguan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      barGroups: _generateBarGroups(last7DaysSales),
                      titlesData: _buildTitlesData(last7DaysSales),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (BarChartGroupData group) => Colors.blue.withOpacity(0.8),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              'Rp ${rod.toY.toStringAsFixed(2)}',
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Fungsi untuk menghitung total penjualan 7 hari terakhir
  Map<String, double> _calculateLast7DaysSales() {
    final now = DateTime.now();
    Map<String, double> salesByDay = {};

    // Inisialisasi 7 hari dengan nilai 0
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dayName = _getDayName(day.weekday);
      salesByDay[dayName] = 0.0;
    }

    // Hitung total penjualan per hari
    for (var transaction in controller.transactions) {
      if (transaction.date.isAfter(now.subtract(const Duration(days: 7)))) {
        final dayName = _getDayName(transaction.date.weekday);
        salesByDay[dayName] = (salesByDay[dayName] ?? 0) + transaction.totalAmount;
      }
    }

    return salesByDay;
  }

  // Konversi angka hari ke nama singkat
  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Sen';
      case DateTime.tuesday:
        return 'Sel';
      case DateTime.wednesday:
        return 'Rab';
      case DateTime.thursday:
        return 'Kam';
      case DateTime.friday:
        return 'Jum';
      case DateTime.saturday:
        return 'Sab';
      case DateTime.sunday:
        return 'Min';
      default:
        return '';
    }
  }

  // Buat bar groups untuk grafik
  List<BarChartGroupData> _generateBarGroups(Map<String, double> salesData) {
    return salesData.entries.map((entry) {
      return BarChartGroupData(
        x: salesData.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.blue,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  // Konfigurasi label judul
  FlTitlesData _buildTitlesData(Map<String, double> salesData) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            final index = value.toInt();
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                salesData.keys.toList()[index],
                style: const TextStyle(fontSize: 10),
              ),
            );
          },
          reservedSize: 28,
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }
}